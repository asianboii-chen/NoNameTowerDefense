/**
 * 2016/6/27 18:56
 * 
 * 设置菜单按钮
 */
package
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Back;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class ButtonSettings extends ButtonBase
	{
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	CONSTRUCTOR
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		/**
		 * 创建新的 ButtonSettings 对象。
		 * 
		 * @param	game - 所属的 Game 对象。
		 */
		public function ButtonSettings(game:Game)
		{
			super();
			
			this.buttonMode = false;
			this.icon.buttonMode = true;
			
			this.game = game;
			this.x = 900;
			this.y = 0;
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	PROPERTIES
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		/**
		 * 所属的游戏核心对象。
		 */
		public var game:Game;
		/**
		 * 内部的图标。
		 */
		public var icon:Sprite;
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	ACCESSORS
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
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
		 * [覆盖] 鼠标移入按钮。
		 */
		override protected function onButtonRollOver(event:MouseEvent):void
		{
			TweenMax.to(this.icon, 0.4, {ease: Back.easeOut, x: -30, y: 30});
		}
		
		/**
		 * [覆盖] 鼠标移出按钮。
		 */
		override protected function onButtonRollOut(event:MouseEvent):void
		{
			TweenMax.to(this.icon, 0.4, {ease: Back.easeOut, x: 10, y: -10});
		}
		
		/**
		 * [覆盖] 鼠标按下按钮。
		 */
		override protected function onButtonMouseDown(event:MouseEvent):void 
		{
		}
		
		/**
		 * [覆盖] 鼠标单击按钮。
		 */
		override protected function onButtonClick(event:MouseEvent):void 
		{
			TweenMax.killTweensOf(this.icon);
			
			this.game.windowSettings.fadein();
		}
	
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	DESTROYER
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
	
	}

}