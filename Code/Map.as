package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.getDefinitionByName;
	
	public class Map extends GameScene
	{
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	CONSTRUCTOR
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		public function Map(game:Game = null, levelBeatID:int = -1, starsEarned:int = -1, ironBeat:Boolean = false)
		{
			this.levels = Levels.LEVELS;
			
			this.icons = new Sprite();
			this.windows = new Sprite();
			
			super(game);
			
			this._levelBeatID = levelBeatID;
			this._starsEarned = starsEarned;
			this._ironBeat = ironBeat;
			
			this.addChild(this.icons);
			this.addChild(this.windows);
			
			this.windowLevelSettings = new WindowLevelSettings(this);
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	PROPERTIES
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		public var windowLevelSettings:WindowLevelSettings;
		public var icons:Sprite;
		public var windows:Sprite;
		public var levels:Array;
		protected var _levelBeatID:int;
		protected var _starsEarned:int;
		protected var _ironBeat:Boolean;
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	ACCESSORS
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	INITIALIZATION
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		public function initLevels():void
		{
			var levelCookies:Array = this.game.gameCookie.levels;
			
			for (var i:int = 0, n:int = this.levels.length; i < n; i++)
			{
				new LevelIcon(this, this.levels[i].mapLocation, i, levelCookies[i].enabled, levelCookies[i].stars, i == this._levelBeatID ? this._starsEarned : -1, levelCookies[i].iron, i == this._levelBeatID ? this._ironBeat : false);
			}
			
			levelCookies = null;
		}
		
		override public function init():void
		{
			super.init();
			
			this.initLevels();
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	METHODS
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		public function unlockLevels(ids:Array):void
		{
			for each (var p:int in ids)
			{
				LevelIcon(this.icons.getChildAt(p)).enabled = true;
				
				this.game.gameCookie.writeLevelCookie(p, true);
			}
		}
		
		public function showLevelSettings(levelIcon:LevelIcon):void
		{
			this.windowLevelSettings.show(levelIcon);
		}
		
		public function startLevel(id:int, mode:String = "campaign"):void
		{
			this.game.loadScene(Class(getDefinitionByName("Level" + (id + 1))), mode);
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	FRAME_UPDATER
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	EVENT_HANDLERS
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	DESTROYER
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		override public function destroy():void
		{
			while (this.icons.numChildren > 0)
			{
				LevelIcon(this.icons.getChildAt(0)).destroy();
			}
			while (this.windows.numChildren > 0)
			{
				Window(this.windows.getChildAt(0)).destroy();
			}
			
			this.removeChild(this.icons);
			this.icons = null;
			this.removeChild(this.windows);
			this.windows = null;
			
			this.levels = null;
			
			super.destroy();
		}
	
	}

}