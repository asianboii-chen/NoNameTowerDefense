package
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	
	public class WindowSettingListSlider extends WindowSettingListItem
	{
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	CONSTRUCTOR
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		public function WindowSettingListSlider(list:WindowSettingList, title:String, x:int, y:int, width:int, height:int, initial:Number = 0, setFunction:Function = null)
		{
			super(list, title, x, y, width, height, setFunction);
			
			this.value = initial;
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	PROPERTIES
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		public var slider:MovieClip;
		public var railway:Sprite;
		public var iTxt:TextField;
		public var value:Number;
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	ACCESSORS
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	INITIALIZATION
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		override protected function onAddedToStage(event:Event = null):void
		{
			this.txt = this.iTxt;
			
			this.slider.gotoAndStop("mouse up");
			
			this.slider.x = this.value * (this.railway.width - this.slider.width) + this.railway.x;
			
			super.onAddedToStage(event);
		}
		
		override public function init():void
		{
			this.slider.addEventListener(MouseEvent.MOUSE_DOWN, this.onSliderMouseDown, false, 0, true);
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	METHODS
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		override public function adjust(value:*, sendEvent:Boolean = true):void
		{
			this.list.window.game.showInfoPanel([[int(value * 100) + "%", 4, 4, 0xBBBBBB, 13]], 100);
			
			super.adjust(value, sendEvent);
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	FRAME_UPDATER
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		protected function onFrameUpdate(event:Event):void
		{
			this.value = int((this.slider.x - this.railway.x) / (this.railway.width - this.slider.width) * 100 + 2) / 100;
			
			this.adjust(this.value);
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	EVENT_HANDLERS
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		protected function onSliderMouseDown(event:MouseEvent):void
		{
			var range:Rectangle = new Rectangle(this.railway.x, this.railway.y, this.railway.width - this.slider.width);
			
			this.slider.gotoAndStop("mouse down");
			this.slider.startDrag(false, range);
			
			this.slider.addEventListener(Event.ENTER_FRAME, this.onFrameUpdate, false, 0, true);
			this.stage.addEventListener(MouseEvent.MOUSE_UP, this.onSliderMouseUp, false, 0, true);
			
			range = null;
		}
		
		protected function onSliderMouseUp(event:MouseEvent):void
		{
			this.slider.removeEventListener(Event.ENTER_FRAME, this.onFrameUpdate);
			this.stage.removeEventListener(MouseEvent.MOUSE_UP, this.onSliderMouseUp);
			
			this.slider.gotoAndStop("mouse up");
			this.slider.stopDrag();
			
			this.hitTestPoint(event.target.mouseX, event.target.mouseY, true) || this.list.window.game.hideInfoPanel();
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	DESTROYER
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		override public function destroy():void
		{
			this.slider.removeEventListener(Event.ENTER_FRAME, this.onFrameUpdate);
			this.slider.removeEventListener(MouseEvent.MOUSE_DOWN, this.onSliderMouseDown);
			this.stage.removeEventListener(MouseEvent.MOUSE_UP, this.onSliderMouseUp);
			
			this.removeChild(this.iTxt);
			this.iTxt = null;
			this.removeChild(this.railway);
			this.railway = null;
			this.removeChild(this.slider);
			this.slider = null;
			
			super.destroy();
		}
	
	}

}