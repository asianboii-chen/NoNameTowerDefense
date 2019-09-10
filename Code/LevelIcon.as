package
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Strong;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class LevelIcon extends Sprite
	{
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	CONSTRUCTOR
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		public function LevelIcon(map:Map = null, position:Node = null, levelID:int = -1, enabled:Boolean = false, stars:int = 0, starsEarned:int = -1, iron:Boolean = false, ironBeat:Boolean = false)
		{
			super();
			
			this.id = levelID;
			this.canUnlockIDs = Levels.LEVELS[levelID].canUnlockIDs;
			
			this._enabled = enabled;
			
			this.visible = false;
			this.alpha = 0;
			this.glowing.visible = false;
			this.glowing.alpha = 0;
			this.gold.visible = stars > 0 && starsEarned <= 0;
			this.gold.alpha = starsEarned > 0 ? 0 : 1 / 3 * stars;
			this.silver.visible = iron && !ironBeat;
			this.flashing.visible = false;
			this.flashing.alpha = 0;
			this.stars = stars;
			this.starsEarned = starsEarned;
			this.iron = iron;
			this.ironBeat = ironBeat;
			
			this.buttonMode = true;
			
			if (position)
			{
				this.x = position.x;
				this.y = position.y;
			}
			
			if (map)
			{
				map.icons.addChild(this);
				this.map = map;
				this.game = map.game;
				this.init();
			}
			else
			{
				this.addEventListener(Event.ADDED_TO_STAGE, this.init, false, 0, true);
			}
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	PROPERTIES
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		public var game:Game;
		public var map:Map;
		public var glowing:Sprite;
		public var flashing:Sprite;
		public var gold:Sprite;
		public var silver:Sprite;
		public var canUnlockIDs:Array;
		public var panel:Array;
		public var id:int;
		public var levelInitialCash:int;
		public var levelFirstWaveHP:int;
		public var stars:int;
		public var starsEarned:int;
		public var iron:Boolean;
		public var ironBeat:Boolean;
		protected var _enabled:Boolean;
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	ACCESSORS
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		public function get enabled():Boolean
		{
			return this._enabled;
		}
		
		public function set enabled(value:Boolean):void
		{
			if (this._enabled)
				return;
			
			if (value)
				this.fadein(true);
			else
				this.visible = false;
			
			this._enabled = value;
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	INITIALIZATION
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		protected function init(event:Event = null):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, this.init);
			
			if (!this.map)
			{
				this.map = this.parent as Map;
				this.game = this.map.game;
			}
			
			this.levelInitialCash = Levels.LEVELS[this.id].cash;
			for each (var p:WaveSpawn in LevelWaves.LEVEL_WAVES[this.id][0].spawns)
			{
				this.levelFirstWaveHP += p.numberTotal * this.game.gameSettings.getSettingsByClass(p.enemy).hp;
			}
			p = null;
			
			this.panel = [];
			this.panel[0] = ["Stage " + (this.id + 1), 6, 2, 0xDDDDDD, 20, true];
			this.panel[1] = ["Total waves: " + LevelWaves.LEVEL_WAVES[this.id].length, 4, 3, 0xBBBBBB, 13];
			this.panel[2] = "----";
			this.panel[3] = ["Initial Gold: " + this.levelInitialCash, 3, 1, 0xCCCCCC, 15];
			this.panel[4] = ["First Wave Total Health: " + this.levelFirstWaveHP, 2, 3, 0xCCCCCC, 15];
			if (this.stars > 0)
			{
				this.panel[5] = "----";
				this.panel[6] = ["Campaign completed with " + this.stars + " Star(s)!", 3, 4, 0xFFBB00, 13];
				
				if (this.iron)
					this.panel[7] = ["Ironic completed!", -2, 2, 0xFB8604, 13];
			}
			
			this._enabled && this.fadein();
			
			this.addEventListener(MouseEvent.ROLL_OVER, this.onIconRollOver, false, 0, true);
			this.addEventListener(MouseEvent.ROLL_OUT, this.onIconRollOut, false, 0, true);
			this.addEventListener(MouseEvent.CLICK, this.onIconClick, false, 0, true);
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	METHODS
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		public function fadein(delayed:Boolean = false):void
		{
			TweenMax.fromTo(this, 0.35, {autoAlpha: 0, y: "-90", scaleX: 1.5, scaleY: 1.5}, {autoAlpha: 1, y: this.y, scaleX: 1, scaleY: 1, onComplete: this.onFadeinComplete});
		}
		
		public function checkUnlockLevels():void
		{
			if (this.starsEarned >= 0)
				return;
			
			var levelIDs:Array = [];
			
			for each (var p:int in this.canUnlockIDs)
			{
				if (!LevelIcon(this.map.icons.getChildAt(p)).enabled)
					levelIDs[levelIDs.length] = p;
			}
			
			this.map.unlockLevels(levelIDs);
			
			levelIDs = null;
		}
		
		public function earnStars(stars:int = 0):void
		{
			this.gold.visible = stars > 0;
			this.gold.alpha = 1 / 3 * stars;
		}
		
		public function beatIron():void
		{
			this.silver.visible = true;
		}
		
		public function flashIcon():void
		{
			this.flashing.visible = false;
			this.flashing.alpha = 1;
			
			TweenMax.to(this.flashing, 1.1, {delay: 0.8, autoAlpha: 0, onStart: this.onFlashStart, onComplete: this.onFlashComplete});
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	FRAME_UPDATER
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	EVENT_HANDLERS
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		protected function onIconRollOver(event:MouseEvent):void
		{
			TweenMax.to(this.glowing, 0.25, {autoAlpha: 1});
			
			this.game.showInfoPanel(this.panel, 280);
		}
		
		protected function onIconRollOut(event:MouseEvent):void
		{
			TweenMax.to(this.glowing, 0.25, {autoAlpha: 0});
			
			this.game.hideInfoPanel();
		}
		
		protected function onIconClick(event:MouseEvent):void
		{
			this.map.showLevelSettings(this);
		}
		
		protected function onFadeinComplete():void
		{
			if (this.starsEarned > 0 || this.ironBeat)
				this.flashIcon();
			else
				this._enabled && this.stars > 0 && this.checkUnlockLevels();
		}
		
		protected function onFlashStart():void
		{
			this.flashing.visible = true;
			
			if (this.starsEarned > 0)
				this.earnStars(this.starsEarned);
			
			if (this.ironBeat)
				this.beatIron();
		}
		
		protected function onFlashComplete():void
		{
			this.map && this.map.unlockLevels(this.canUnlockIDs);
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	DESTROYER
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		public function destroy():void
		{
			TweenMax.killTweensOf(this);
			
			this.removeEventListener(MouseEvent.ROLL_OVER, this.onIconRollOver);
			this.removeEventListener(MouseEvent.ROLL_OUT, this.onIconRollOut);
			this.removeEventListener(MouseEvent.CLICK, this.onIconClick);
			
			this.removeChild(this.glowing);
			this.glowing = null;
			this.removeChild(this.flashing);
			this.flashing = null;
			this.removeChild(this.gold);
			this.gold = null;
			
			while (this.panel.length > 0)
			{
				var p:* = this.panel[this.panel.length - 1];
				
				(p is Array) && (p.length = 0);
				this.panel.length--;
			}
			p = null;
			this.panel = null;
			
			this.map = null;
			
			this.parent.removeChild(this);
		}
	
	}

}