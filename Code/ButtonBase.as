/**
 * 2016/6/27 18:47
 * 
 * 按钮
 */
package
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class ButtonBase extends MovieClip
	{
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	CONSTRUCTOR
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		/**
		 * 创建新的 ButtonBase 对象。
		 */
		public function ButtonBase()
		{
			super();
			
			this.buttonMode = true;
			this.txt && (this.txt.mouseEnabled = false);
			this.txt && (this.txt.mouseWheelEnabled = false);
			
			this.stop();
			
			this.addEventListener(MouseEvent.ROLL_OVER, this.onButtonRollOver, false, 0, true);
			this.addEventListener(MouseEvent.ROLL_OUT, this.onButtonRollOut, false, 0, true);
			this.addEventListener(MouseEvent.MOUSE_DOWN, this.onButtonMouseDown, false, 0, true);
			this.addEventListener(MouseEvent.CLICK, this.onButtonClick, false, 0, true);
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	PROPERTIES
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		/**
		 * 按钮中的文本框。
		 */
		public var txt:TextField;
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	ACCESSORS
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		/**
		 * 获取或设置按钮文本。
		 */
		public function get label():String
		{
			return this.txt.text;
		}
		
		public function set label(value:String):void
		{
			this.txt.text = value;
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	INITIALIZATION
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	METHODS
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	FRAME_UPDATER
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	EVENT_HANDLERS
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		/**
		 * 鼠标移入按钮。
		 */
		protected function onButtonRollOver(event:MouseEvent):void
		{
			this.gotoAndStop("roll over");
		}
		
		/**
		 * 鼠标移出按钮。
		 */
		protected function onButtonRollOut(event:MouseEvent):void
		{
			this.gotoAndStop("roll out");
		}
		
		/**
		 * 鼠标按下按钮。
		 */
		protected function onButtonMouseDown(event:MouseEvent):void
		{
			this.gotoAndStop("mouse down");
		}
		
		/**
		 * 鼠标单击按钮。
		 */
		protected function onButtonClick(event:MouseEvent):void
		{
			this.gotoAndStop("roll over");
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	DESTROYER
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		public function destroy():void
		{
			this.removeEventListener(MouseEvent.ROLL_OVER, this.onButtonRollOver);
			this.removeEventListener(MouseEvent.ROLL_OUT, this.onButtonRollOut);
			this.removeEventListener(MouseEvent.MOUSE_DOWN, this.onButtonMouseDown);
			this.removeEventListener(MouseEvent.CLICK, this.onButtonClick);
			
			this.stop();
			
			this.txt && this.removeChild(this.txt);
			this.txt = null;
			
			this.parent.removeChild(this);
		}
	
	}

}