package
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class MainMenu extends GameScene
	{
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	CONSTRUCTOR
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		public function MainMenu(game:Game = null)
		{
			super(game);
			
			this.txtVersion.text = "v2017.12";
			
			this.buttonStart.label = "Start";
			
			this.txtCredit.addEventListener(MouseEvent.ROLL_OVER, this.ontxtCreditRollOver, false, 0, true);
			this.txtCredit.addEventListener(MouseEvent.ROLL_OUT, this.ontxtCreditRollOut, false, 0, true);
			this.txtVersion.addEventListener(MouseEvent.ROLL_OVER, this.onTxtVersionRollOver, false, 0, true);
			this.txtVersion.addEventListener(MouseEvent.ROLL_OUT, this.onTxtVersionRollOut, false, 0, true);
			this.txtVersion.addEventListener(MouseEvent.MOUSE_WHEEL, this.onTxtVersionMouseWheel, false, 0, true);
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	PROPERTIES
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		public var title:MovieClip;
		public var buttonStart:ButtonBase;
		public var txtCredit:TextField;
		public var txtVersion:TextField;
		protected var _showingVersion:int;
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	ACCESSORS
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	INITIALIZATION
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		override public function init():void
		{
			super.init();
			
			this.buttonStart.addEventListener(MouseEvent.CLICK, this.onButtonStartClick, false, 0, true);
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	METHODS
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		override public function fadein():void
		{
			var blackBack:BlackBackgraound = new BlackBackgraound(this);
			
			//blackBack.fadeout(1);
			blackBack.fadeout(2);
			blackBack.addEventListener(Event.COMPLETE, this.onBlackFadeoutComplete, false, 0, true);
			
			blackBack = null;
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	FRAME_UPDATER
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	EVENT_HANDLERS
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		protected function onButtonStartClick(event:MouseEvent):void
		{
			this.buttonStart.removeEventListener(MouseEvent.CLICK, this.onButtonStartClick);
			
			this.game.loadScene(Map);
		}
		
		protected function ontxtCreditRollOver(event:MouseEvent):void
		{
			this.game.showInfoPanel([[GameVersions.CREDIT_TITLE, 6, 7, 0xFF4444, 20, true], "----", [GameVersions.CREDIT_LIST, 5, 5, 0xDDDDDD, 15], "----", [GameVersions.CREDIT_WARNING, 5, 5, 0xFF0000, 15]], 360);
		}
		
		protected function ontxtCreditRollOut(event:MouseEvent):void
		{
			this.game.hideInfoPanel();
		}
		
		protected function onTxtVersionRollOver(event:MouseEvent):void
		{
			this._showingVersion = 0;
			
			this.game.showInfoPanel([[GameVersions.VERSIONS[0].date, 6, 7, 0x44FFFF, 20, true], "----", [GameVersions.VERSIONS[0].data.join("\n"), 5, 5, 0xCCCCCC, 15], "----", [GameVersions.VERSIONS_WARNING, 4, 4, 0x009999, 12]], 400);
		}
		
		protected function onTxtVersionRollOut(event:MouseEvent):void
		{
			this.game.hideInfoPanel();
		}
		
		protected function onTxtVersionMouseWheel(event:MouseEvent):void
		{
			if (event.delta > 0)
				this._showingVersion < GameVersions.VERSIONS.length - 1 && this._showingVersion++;
			else
				this._showingVersion > 0 && this._showingVersion--;
			
			this.game.showInfoPanel([[GameVersions.VERSIONS[this._showingVersion].date, 6, 7, 0x44FFFF, 20, true], "----", [GameVersions.VERSIONS[this._showingVersion].data.join("\n"), 5, 5, 0xCCCCCC, 15], "----", [GameVersions.VERSIONS_WARNING, 4, 4, 0x009999, 12]], 400);
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	DESTROYER
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		override public function destroy():void
		{
			this.buttonStart.removeEventListener(MouseEvent.CLICK, this.onButtonStartClick);
			this.txtCredit.removeEventListener(MouseEvent.ROLL_OVER, this.ontxtCreditRollOver);
			this.txtCredit.removeEventListener(MouseEvent.ROLL_OUT, this.ontxtCreditRollOut);
			this.txtVersion.removeEventListener(MouseEvent.ROLL_OVER, this.onTxtVersionRollOver);
			this.txtVersion.removeEventListener(MouseEvent.ROLL_OUT, this.onTxtVersionRollOut);
			this.txtVersion.removeEventListener(MouseEvent.MOUSE_WHEEL, this.onTxtVersionMouseWheel);
			
			this.title.stop();
			
			this.removeChild(this.title);
			this.title = null;
			this.removeChild(this.buttonStart);
			this.buttonStart = null;
			
			super.destroy();
		}
	
	}

}