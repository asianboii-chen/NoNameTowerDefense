package
{
	import com.greensock.TweenMax;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class WindowLevelSettings extends Window
	{
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	CONSTRUCTOR
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		public function WindowLevelSettings(map:Map)
		{
			this.map = map;
			
			super(map.windows);
			
			this.txtTitle.mouseEnabled = false;
			this.txtTitle.mouseWheelEnabled = false;
			this.txtTitle.text = "关卡 0";
			
			this.buttonStart.label = "To Battle!";
			this.buttonCampaign.label = "Campaign";
			this.buttonIron.label = "Ironic";
			
			this.selectedMode = LevelMode.CAMPAIGN;
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	PROPERTIES
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		public var map:Map;
		public var buttonClose:ButtonClose;
		public var buttonStart:ButtonBase;
		public var buttonCampaign:ButtonSelection;
		public var buttonIron:ButtonSelection;
		public var levelIcon:LevelIcon;
		public var tinyMap:MovieClip;
		public var txtTitle:TextField;
		public var selectedMode:String;
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	ACCESSORS
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	INITIALIZATION
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	METHODS
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		override public function fadein():void
		{
			throw new Error("请使用 show 方法！！");
		}
		
		public function show(levelIcon:LevelIcon):void
		{
			this.txtTitle.text = "Stage " + (levelIcon.id + 1);
			this.tinyMap.gotoAndStop(levelIcon.id + 1);
			
			this.levelIcon = levelIcon;
			
			this.selectedMode = LevelMode.CAMPAIGN;
			this.buttonCampaign.selected = true;
			this.buttonIron.visible = levelIcon.stars > 0;
			this.buttonIron.visible && (this.buttonIron.selected = false);
			
			this.tinyMap.addEventListener(MouseEvent.ROLL_OVER, this.onTinyMapRollOver, false, 0, true);
			this.tinyMap.addEventListener(MouseEvent.ROLL_OUT, this.onTinyMapRollOut, false, 0, true);
			this.buttonClose.addEventListener(MouseEvent.CLICK, this.onButtonCloseClick, false, 0, true);
			this.buttonStart.addEventListener(MouseEvent.CLICK, this.onButtonStartClick, false, 0, true);
			this.buttonCampaign.addEventListener(MouseEvent.ROLL_OVER, this.onButtonCampaignRollOver, false, 0, true);
			this.buttonCampaign.addEventListener(MouseEvent.ROLL_OUT, this.onButtonCampaignRollOut, false, 0, true);
			this.buttonCampaign.addEventListener(MouseEvent.CLICK, this.onButtonCampaignClick, false, 0, true);
			this.buttonIron.addEventListener(MouseEvent.ROLL_OVER, this.onButtonIronRollOver, false, 0, true);
			this.buttonIron.addEventListener(MouseEvent.ROLL_OUT, this.onButtonIronRollOut, false, 0, true);
			this.buttonIron.addEventListener(MouseEvent.CLICK, this.onButtonIronClick, false, 0, true);
			
			super.fadein();
		}
		
		public function hide():void
		{
			this.fadeout();
		}
		
		override public function fadeout():void
		{
			this.buttonClose.removeEventListener(MouseEvent.CLICK, this.onButtonCloseClick);
			this.buttonStart.removeEventListener(MouseEvent.CLICK, this.onButtonStartClick);
			this.buttonCampaign.removeEventListener(MouseEvent.ROLL_OVER, this.onButtonCampaignRollOver);
			this.buttonCampaign.removeEventListener(MouseEvent.ROLL_OUT, this.onButtonCampaignRollOut);
			this.buttonCampaign.removeEventListener(MouseEvent.CLICK, this.onButtonCampaignClick);
			this.buttonIron.removeEventListener(MouseEvent.CLICK, this.onButtonIronClick);
			this.tinyMap.removeEventListener(MouseEvent.ROLL_OVER, this.onTinyMapRollOver);
			this.buttonIron.removeEventListener(MouseEvent.ROLL_OVER, this.onButtonIronRollOver);
			this.buttonIron.removeEventListener(MouseEvent.ROLL_OUT, this.onButtonIronRollOut);
			this.tinyMap.removeEventListener(MouseEvent.ROLL_OUT, this.onTinyMapRollOut);
			
			this.levelIcon = null;
			
			super.fadeout();
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	FRAME_UPDATER
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	EVENT_HANDLERS
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		protected function onTinyMapRollOver(event:MouseEvent):void
		{
			this.game.showInfoPanel(this.levelIcon.panel, 280);
		}
		
		protected function onTinyMapRollOut(event:MouseEvent):void
		{
			this.game.hideInfoPanel();
		}
		
		protected function onButtonCloseClick(event:MouseEvent):void
		{
			this.fadeout();
		}
		
		protected function onButtonStartClick(event:MouseEvent):void
		{
			if (!this.levelIcon)
				return;
			
			this.map.startLevel(this.levelIcon.id, this.selectedMode);
			
			this.fadeout();
		}
		
		protected function onButtonCampaignRollOver(event:MouseEvent):void
		{
			this.game.showInfoPanel([[GameStrings.MODE_CAMPAIGN_TITLE, 6, 7, 0xF9CE06, 20, true], "----", [GameStrings.MODE_CAMPAIGN_DESCRIPTION, 5, 5, 0xDDDDDD, 15]]);
		}
		
		protected function onButtonCampaignRollOut(event:MouseEvent):void
		{
			this.game.hideInfoPanel();
		}
		
		protected function onButtonCampaignClick(event:MouseEvent):void
		{
			this.selectedMode = LevelMode.CAMPAIGN;
			
			this.buttonIron.selected = false;
		}
		
		protected function onButtonIronRollOver(event:MouseEvent):void
		{
			var panel:Array = [];
			
			panel[0] = [GameStrings.MODE_IRON_TITLE, 6, 7, 0xF97906, 20, true];
			panel[1] = "----";
			panel[2] = [GameStrings.MODE_IRON_DESCRIPTION, 5, 5, 0xDDDDDD, 15];
			panel[3] = "----";
			panel[4] = ["One total wave", 3, 1, 0xAA5304, 13];
			panel[5] = ["One total life", 3, 1, 0xAA5304, 13];
			panel[6] = ["Unknown number of total enemies", 3, 1, 0xAA5304, 13];
			panel[7] = ["Limited types of defensive towers", 3, 3, 0xAA5304, 13];
			
			this.game.showInfoPanel(panel, 350);
			
			panel.length = 0;
			panel = null;
		}
		
		protected function onButtonIronRollOut(event:MouseEvent):void
		{
			this.game.hideInfoPanel();
		}
		
		protected function onButtonIronClick(event:MouseEvent):void
		{
			this.selectedMode = LevelMode.IRON;
			
			this.buttonCampaign.selected = false;
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
			TweenMax.killTweensOf(this);
			
			this.removeChild(this.tinyMap);
			this.tinyMap = null;
			this.removeChild(this.txtTitle);
			this.txtTitle = null;
			
			this.buttonClose.destroy();
			this.buttonClose = null;
			
			this.levelIcon = null;
			this.map = null;
			
			super.destroy();
		}
	
	}

}