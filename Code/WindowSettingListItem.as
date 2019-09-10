package
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class WindowSettingListItem extends MovieClip
	{
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	CONSTRUCTOR
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		public function WindowSettingListItem(list:WindowSettingList, title:String, x:int, y:int, width:int, height:int, setFunction:Function = null)
		{
			super();
			
			list.addChildAt(this, 0);
			
			this.list = list;
			
			this.x = x;
			this.y = y;
			
			this.buttonMode = true;
			
			this.setFunction = setFunction;
			
			this._title = title;
			
			this.gotoAndStop("roll out");
			
			this.addEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage, false, 0, true);
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	PROPERTIES
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		public var list:WindowSettingList;
		public var txt:TextField;
		public var setFunction:*;
		protected var _title:String;
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	ACCESSORS
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		public function get title():String
		{
			return this.txt.text;
		}
		
		public function set title(value:String):void
		{
			this.txt.text = value;
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	INITIALIZATION
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		protected function onAddedToStage(event:Event = null):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage);
			
			this.title = this._title;
			
			this.txt.mouseEnabled = false;
			this.txt.mouseWheelEnabled = false;
			
			this.addEventListener(MouseEvent.ROLL_OVER, this.onItemRollOver, false, 0, true);
			this.addEventListener(MouseEvent.ROLL_OUT, this.onItemRollOut, false, 0, true);
			
			this.init();
		}
		
		public function init():void
		{
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	METHODS
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		public function adjust(value:*, sendEvent:Boolean = true):void
		{
			if (!(sendEvent && this.setFunction))
				return;
			
			this.setFunction(value);
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	FRAME_UPDATER
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	EVENT_HANDLERS
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		protected function onItemRollOver(event:MouseEvent):void
		{
			this.gotoAndStop("roll over");
		}
		
		protected function onItemRollOut(event:MouseEvent):void
		{
			this.gotoAndStop("roll out");
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	DESTROYER
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		public function destroy():void
		{
			this.list = null;
			this.setFunction = null;
			
			this.parent.removeChild(this);
		}
	
	}

}