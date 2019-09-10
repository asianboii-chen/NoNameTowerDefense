/**
 * 2016/1/16 14:04
 *
 * 关卡失败界面
 */
package
{
	import com.greensock.easing.Back;
	import com.greensock.easing.Strong;
	import com.greensock.TweenMax;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class WindowLevelDefeat extends Window
	{
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	CONSTRUCTOR
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
		
		/**
		 * 创建新的 LevelDefeat 对象。
		 *
		 * @param	level - 所属的关卡。
		 */
		public function WindowLevelDefeat(level:Level)
		{
			super(level.game.windows);
			
			this.level = level;
			
			this.buttonQuit.label = "Quit";
			this.buttonRestart.label = "Restart";
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	PROPERTIES
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
		
		public var level:Level;
		public var buttonQuit:ButtonBase;
		public var buttonRestart:ButtonBase;
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	ACCESSORS
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	INITIALIZATION
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
		
		override public function init():void
		{
			super.init();
			
			this.buttonQuit.addEventListener(MouseEvent.CLICK, this.onButtonQuitClick, false, 0, true);
			this.buttonRestart.addEventListener(MouseEvent.CLICK, this.onButtonRestartClick, false, 0, true);
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	METHODS
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
		
		override public function fadeout():void
		{
			super.fadeout();
			
			this.buttonQuit.removeEventListener(MouseEvent.CLICK, this.onButtonQuitClick);
			this.buttonRestart.removeEventListener(MouseEvent.CLICK, this.onButtonRestartClick);
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	FRAME_UPDATER
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	EVENT_HANDLERS
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
		
		protected function onButtonQuitClick(event:MouseEvent):void
		{
			this.fadeout();
			
			this.game.loadScene(Map);
		}
		
		protected function onButtonRestartClick(event:MouseEvent):void
		{
			this.fadeout();
			
			this.level.restart();
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	DESTROYER
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
		
		override public function destroy():void
		{
			this.buttonQuit.removeEventListener(MouseEvent.CLICK, this.onButtonQuitClick);
			this.buttonRestart.removeEventListener(MouseEvent.CLICK, this.onButtonRestartClick);
			
			this.level = null;
			
			super.destroy();
		}
	
	}

}