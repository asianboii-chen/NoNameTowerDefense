package
{
	import com.greensock.easing.Quad;
	import com.greensock.TweenMax;
	import com.greensock.easing.Strong;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public dynamic class Spell extends LevelEntity
	{
		
		/// /// /// /// ///
		///    STATIC   ///
		/// /// /// /// ///
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	STATIC_PROPERTIES_AND_ACCESSORS
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
		
		static public const CLOSED:String = "closed";
		static public const OPENED:String = "opened";
		static public const SELECTED:String = "over";
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	STATIC_METHODS
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
		
		/// /// /// /// ///
		///   INSTANCE	///
		/// /// /// /// ///
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	CONSTRUCTOR
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
		
		public function Spell(level:Level, x:int, y:int, info:GameSettingItem, panelContents:Array, spellLevel:int)
		{
			super(x, y, level.spells);
			
			this._panelContents = panelContents;
			this.spellName = info.name;
			this.spellReload = info.respawn;
			this.spellLevel = spellLevel;
			this.isActive = false;
			
			this.y += 50;
			this.visible = false;
			this.alpha = 0;
			
			this.gotoAndStop(Spell.CLOSED);
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	PROPERTIES
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
		
		public var light:Sprite;
		public var progressBar:Sprite;
		public var spellName:String;
		public var spellLevel:int;
		public var spellReload:int;
		public var selected:Boolean;
		
		protected var _panelContents:Array;
		protected var _reloadCounter:int;
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	ACCESSORS
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	INITIALIZATION
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
		
		override public function init():void
		{
			super.init();
			
			this.light.visible = false;
			this.light.alpha = 0;
			
			this.progressBar.visible = false;
			
			this.addEventListener(MouseEvent.ROLL_OVER, this.onSpellRollOver, false, 0, true);
			this.addEventListener(MouseEvent.ROLL_OUT, this.onSpellRollOut, false, 0, true);
			this.addEventListener(MouseEvent.CLICK, this.onSpellClick, false, 0, true);
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	METHODS
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
		
		public function fadein():void
		{
			TweenMax.to(this, 0.7, {ease: Strong.easeOut, y: "-50", autoAlpha: 0.75});
		}
		
		public function enable():void
		{
			TweenMax.killTweensOf(this, true);
			
			this.isActive = true;
			this.visible = true;
			this.alpha = 1;
			
			this.gotoAndStop(Spell.OPENED);
			
			this.activate();
		}
		
		public function activate():void
		{
			this.buttonMode = true;
			this.progressBar.visible = false;
			this.alpha = 1;
			this._reloadCounter = this.spellReload;
			
			this.hitTestPoint(this.level.mouseX, this.level.mouseY, true) && this.onSpellRollOver();
			
			TweenMax.to(this.light, 0.3, {ease: Quad.easeOut, autoAlpha: 1, onComplete: this.onLightFadeinComplete});
		}
		
		public function deactivate():void
		{
			this.buttonMode = false;
			
			this.progressBar.visible = true;
			this.progressBar.scaleY = 1;
			this.alpha = 0.75;
			this._reloadCounter = 0;
		}
		
		public function showPanel():void
		{
			var panel:Array = this._panelContents.concat();
			
			if (this.selected)
			{
				panel[panel.length] = "----";
				panel[panel.length] = [GameStrings.SPELL_CANCEL_DESCRIPTION, 4, 4, 0xAAAAAA, 12];
			}
			
			this.level.showInfoPanel(panel, 300);
			
			panel = null;
		}
		
		public function select(useHotkey:Boolean = false):void
		{
			if (!this.isActive)
				return;
			
			if (this.progressBar.visible)
				return;
			
			this.selected = !this.selected;
			
			this.level.hideAllGUIs();
			
			if (this.selected)
			{
				TweenMax.killTweensOf(this.light);
				
				this.level.levelInfo.showSpellInfo(this);
				
				this.light.visible = true;
				this.light.alpha = 1;
				
				this.currentLabel == Spell.SELECTED || this.gotoAndStop(Spell.SELECTED);
				
				if (this.hitTestPoint(this.level.mouseX, this.level.mouseY, true))
					this.game.infoPanel.visible && this.showPanel();
				else
					this.level.hideInfoPanel();
			}
			else
			{
				TweenMax.killTweensOf(this.light);
				
				this.level.levelInfo.showingMode == LevelInfo.SHOW_SPELL_INFO && this.level.levelInfo.showLevelInfo();
				
				this.light.visible = false;
				this.light.alpha = 0;
				
				this.level.hidePointers();
				
				if (this.hitTestPoint(this.level.mouseX, this.level.mouseY, true))
					this.game.infoPanel.visible && this.showPanel();
				else
					this.gotoAndStop(Spell.OPENED);
			}
		}
		
		public function unselect():void
		{
			if (!this.isActive)
				return;
			
			this.selected && this.level.levelInfo.showLevelInfo();
			this.selected = false;
			
			TweenMax.killTweensOf(this.light);
			
			this.light.visible = false;
			this.light.alpha = 0;
			
			this.level.hidePointers();
			
			if (this.hitTestPoint(this.level.mouseX, this.level.mouseY, true))
				this.game.infoPanel.visible && this.showPanel();
			else
				this.gotoAndStop(Spell.OPENED);
		}
		
		public function reward(time:int):void
		{
			this.progressBar.visible && new PopSpellReward(this, Math.max(Math.min(time, (this.spellReload - this._reloadCounter) / 30), 1));
			
			this._reloadCounter += time * 30;
		}
		
		public function fire(position:Node):void
		{
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	FRAME_UPDATER
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
		
		override public function updateFrame():void
		{
			if (!this.isActive)
				return;
			
			if (!this.progressBar.visible)
				return;
			
			if (this._reloadCounter < this.spellReload)
			{
				this._reloadCounter++;
				this.progressBar.scaleY = 1 - this._reloadCounter / this.spellReload;
				return;
			}
			
			this.activate();
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	EVENT_HANDLERS
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
		
		protected function onSpellRollOver(event:MouseEvent = null):void
		{
			if (!this.isActive)
				return;
			
			this.showPanel();
			
			if (this.progressBar.visible)
				return;
			
			this.gotoAndStop(Spell.SELECTED);
		}
		
		protected function onSpellRollOut(event:MouseEvent):void
		{
			if (!this.isActive)
				return;
			
			this.level.hideInfoPanel();
			
			if (this.selected)
				return;
			
			if (this.progressBar.visible)
				return;
			
			this.gotoAndStop(Spell.OPENED);
		}
		
		protected function onSpellClick(event:MouseEvent):void
		{
			this.select();
		}
		
		protected function onLightFadeinComplete():void
		{
			TweenMax.to(this.light, 0.3, {ease: Quad.easeIn, autoAlpha: 0});
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	DESTROYER
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
		
		override public function destroy():void
		{
			this.removeEventListener(MouseEvent.ROLL_OVER, this.onSpellRollOver);
			this.removeEventListener(MouseEvent.ROLL_OUT, this.onSpellRollOut);
			this.removeEventListener(MouseEvent.CLICK, this.onSpellClick);
			
			this.stop();
			
			this.light = null;
			this.progressBar = null;
			
			super.destroy();
		}
	
	}

}