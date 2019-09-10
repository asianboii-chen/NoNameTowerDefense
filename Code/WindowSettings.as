package
{
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.display.StageQuality;
	import flash.events.Event;
	import flash.events.FullScreenEvent;
	import flash.events.MouseEvent;
	
	public class WindowSettings extends Window
	{
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	CONSTRUCTOR
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		public function WindowSettings(game:Game)
		{
			this.settingList = new WindowSettingList(this, -272, -121, 543, 220);
			
			super();
			
			this.game = game;
			game.addChild(this);
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	PROPERTIES
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		public var settingList:WindowSettingList;
		public var button1:ButtonBlack;
		public var button2:ButtonBlack;
		public var buttonRed:ButtonBrown;
		public var buttonTop1:ButtonBrown;
		public var buttonTop2:ButtonBrown;
		public var buttonTopRed:ButtonBrown;
		public var currentScene:String;
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	ACCESSORS
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	INITIALIZATION
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		override protected function onAddedToStage(event:Event = null):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage);
			
			this.game = this.parent as Game;
			
			this.initSettingList();
		}
		
		public function initSettingList():void
		{
			var prefs:GamePrefs = this.game.gamePrefs;
			
			this.settingList.addSetting(GameStrings.SETTING_QUALITY_TITLE, WindowSettingMode.SLIDER, prefs.quality == StageQuality.HIGH ? 1 : (prefs.quality == StageQuality.MEDIUM ? 0.5 : 0.25), this.setQuality);
			this.settingList.addSetting(GameStrings.SETTING_FULL_SCREEN_TITLE, WindowSettingMode.CHECKBOX, this.stage.displayState != StageDisplayState.NORMAL, this.setFullScreen);
			this.settingList.addSetting(GameStrings.SETTING_SHOW_PANEL_TITLE, WindowSettingMode.CHECKBOX, prefs.showPanel, this.setShowPanel);
			this.settingList.addSetting(GameStrings.SETTING_AUTO_PAUSE_TITLE, WindowSettingMode.CHECKBOX, prefs.autoPause, this.setAutoPause);
			
			prefs = null;
		}
		
		override public function init():void
		{
			super.init();
			
			this.game.stage.addEventListener(FullScreenEvent.FULL_SCREEN, this.onStageFullScreen, false, 0, true);
			this.button1.addEventListener(MouseEvent.CLICK, this.onButton1Click, false, 0, true);
			this.button2.addEventListener(MouseEvent.CLICK, this.onButton2Click, false, 0, true);
			this.buttonRed.addEventListener(MouseEvent.ROLL_OVER, this.onButtonRedRollOver, false, 0, true);
			this.buttonRed.addEventListener(MouseEvent.ROLL_OUT, this.onButtonRedRollOut, false, 0, true);
			this.buttonRed.addEventListener(MouseEvent.CLICK, this.onButtonRedClick, false, 0, true);
			this.buttonClose.addEventListener(MouseEvent.CLICK, this.onButtonCloseClick, false, 0, true);
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	METHODS
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		override public function fadein():void
		{
			this.buttonTopRed.visible = false;
			this.buttonTop1.visible = false;
			this.buttonTop2.visible = false;
			
			super.fadein();
			
			this.mouseChildren = true;
			this.mouseEnabled = true;
			
			if (!(this.game.scene && this.game.scene.isActive))
			{
				this.buttonRed.visible = false;
				this.button2.visible = false;
				this.button1.visible = false;
				
				return;
			}
			
			switch (this.game.sceneName)
			{
				case GameScene.LEVEL: 
					this.buttonRed.visible = false;
					if (this.game.scene.levelState != LevelState.OVER)
					{
						this.button1.visible = true;
						this.button2.visible = true;
						this.button1.label = "Restart";
						this.button2.label = "Quit";
					}
					else
					{
						this.button1.visible = false;
						this.button2.visible = false;
					}
					break;
				
				case GameScene.MAP: 
					this.buttonRed.visible = false;
					this.button1.visible = false;
					this.button2.visible = true;
					this.button2.label = "Main Menu";
					break;
				
				case GameScene.MAIN_MENU: 
					if (this.game.gameCookie.levels[0].stars > 0)
					{
						this.buttonRed.visible = true;
						this.buttonRed.label = "Reset Prog.";
					}
					else
					{
						this.buttonRed.visible = false;
					}
					this.button1.visible = false;
					this.button2.visible = false;
					break;
				
				default: 
					throw new Error("不支持的值！");
			}
		}
		
		override public function fadeout():void
		{
			this.button1.removeEventListener(MouseEvent.CLICK, this.onButton1Click);
			this.button2.removeEventListener(MouseEvent.CLICK, this.onButton2Click);
			this.buttonRed.removeEventListener(MouseEvent.ROLL_OVER, this.onButtonRedRollOver);
			this.buttonRed.removeEventListener(MouseEvent.ROLL_OUT, this.onButtonRedRollOut);
			this.buttonRed.removeEventListener(MouseEvent.CLICK, this.onButtonRedClick);
			this.buttonClose.removeEventListener(MouseEvent.CLICK, this.onButtonCloseClick);
			
			super.fadeout();
		}
		
		private function setQuality(value:Number):void
		{
			var quality:String;
			
			if (value > 0.6)
				quality = StageQuality.HIGH;
			else if (value > 0.3)
				quality = StageQuality.MEDIUM;
			else
				quality = StageQuality.LOW;
			
			this.stage.quality = quality;
			
			this.game.gamePrefs.quality = quality;
			
			this.game.gamePrefs.writePrefsCookie("quality", quality);
			
			quality = null;
		}
		
		private function setShowPanel(value:Boolean):void
		{
			this.game.gamePrefs.showPanel = value;
			
			this.game.gamePrefs.writePrefsCookie("showPanel", value);
		}
		
		private function setAutoPause(value:Boolean):void
		{
			this.game.gamePrefs.autoPause = value;
			
			this.game.gamePrefs.writePrefsCookie("autoPause", value);
		}
		
		private function setFullScreen(value:Boolean):void
		{
			if (value)
				this.stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
			else
				this.stage.displayState = StageDisplayState.NORMAL;
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	FRAME_UPDATER
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	EVENT_HANDLERS
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		protected function onStageFullScreen(event:FullScreenEvent):void
		{
			this.settingList.getSetting(GameStrings.SETTING_FULL_SCREEN_TITLE).adjust(event.fullScreen, false);
		}
		
		protected function onButton1Click(event:MouseEvent):void
		{
			this.buttonTop1.visible = true;
			this.buttonTop1.label = "Are you sure?";
			
			this.buttonTop1.addEventListener(MouseEvent.ROLL_OUT, this.onButtonTop1RollOut, false, 0, true);
			this.buttonTop1.addEventListener(MouseEvent.CLICK, this.onButtonTop1Click, false, 0, true);
		}
		
		protected function onButton2Click(event:MouseEvent):void
		{
			if (this.game.sceneName == GameScene.MAP)
			{
				this.fadeout();
				this.game.loadScene(MainMenu);
				
				return;
			}
			
			this.buttonTop2.visible = true;
			this.buttonTop2.label = "Are you sure?";
			
			this.buttonTop2.addEventListener(MouseEvent.ROLL_OUT, this.onButtonTop2RollOut, false, 0, true);
			this.buttonTop2.addEventListener(MouseEvent.CLICK, this.onButtonTop2Click, false, 0, true);
		}
		
		protected function onButtonRedRollOver(event:MouseEvent):void
		{
			this.game.showInfoPanel([[GameStrings.SETTING_RESET_PROGRESS_DESCRIPTION, 4, 4, 0xBBBBBB, 13]], 220);
		}
		
		protected function onButtonRedRollOut(event:MouseEvent):void
		{
			this.game.hideInfoPanel();
		}
		
		protected function onButtonRedClick(event:MouseEvent):void
		{
			this.buttonTopRed.visible = true;
			this.buttonTopRed.label = "Are you sure?";
			
			this.buttonTopRed.addEventListener(MouseEvent.ROLL_OUT, this.onButtonTopRedRollOut, false, 0, true);
			this.buttonTopRed.addEventListener(MouseEvent.CLICK, this.onButtonTopRedClick, false, 0, true);
		}
		
		protected function onButtonTop1RollOut(event:MouseEvent):void
		{
			this.buttonTop1.removeEventListener(MouseEvent.CLICK, this.onButtonTop1Click);
			this.buttonTop1.removeEventListener(MouseEvent.CLICK, this.onButtonTop1RollOut);
			
			this.buttonTop1.visible = false;
		}
		
		protected function onButtonTop2RollOut(event:MouseEvent):void
		{
			this.buttonTop2.removeEventListener(MouseEvent.CLICK, this.onButtonTop2Click);
			this.buttonTop2.removeEventListener(MouseEvent.CLICK, this.onButtonTop2RollOut);
			
			this.buttonTop2.visible = false;
		}
		
		protected function onButtonTopRedRollOut(event:MouseEvent):void
		{
			this.buttonTopRed.removeEventListener(MouseEvent.CLICK, this.onButtonTopRedClick);
			this.buttonTopRed.removeEventListener(MouseEvent.CLICK, this.onButtonTopRedRollOut);
			
			this.buttonTopRed.visible = false;
		}
		
		protected function onButtonTop1Click(event:MouseEvent):void
		{
			this.buttonTop1.removeEventListener(MouseEvent.CLICK, this.onButtonTop1Click);
			this.buttonTop1.removeEventListener(MouseEvent.CLICK, this.onButtonTop1RollOut);
			
			this.buttonTop1.visible = false;
			
			this.game.scene.levelState = LevelState.OVER;
			
			this.fadeout();
			
			this.game.scene.restart();
		}
		
		protected function onButtonTop2Click(event:MouseEvent):void
		{
			this.buttonTop2.removeEventListener(MouseEvent.CLICK, this.onButtonTop2Click);
			this.buttonTop2.removeEventListener(MouseEvent.CLICK, this.onButtonTop2RollOut);
			
			this.buttonTop2.visible = false;
			
			this.game.scene.levelState = LevelState.OVER;
			
			this.fadeout();
			
			this.game.loadScene(Map);
		}
		
		protected function onButtonTopRedClick(event:MouseEvent):void
		{
			this.buttonTopRed.removeEventListener(MouseEvent.CLICK, this.onButtonTopRedClick);
			this.buttonTopRed.removeEventListener(MouseEvent.CLICK, this.onButtonTopRedRollOut);
			
			this.buttonTopRed.visible = false;
			
			this.fadeout();
			
			this.game.gameCookie.deleteCookie(0);
		}
		
		protected function onButtonCloseClick(event:MouseEvent):void
		{
			this.fadeout();
		}
		
		override protected function onFadeoutComplete():void
		{
			this.mouseChildren = false;
			this.mouseEnabled = false;
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	DESTROYER
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		override public function destroy():void
		{
		}
	
	}

}