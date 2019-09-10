/**
 * 2016/6/27 18:39
 * 
 * 当窗口出现时舞台的黑色背景遮罩
 */
package
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Strong;
	import flash.display.Sprite;
	import flash.events.Event;
	
	[Event(name = "complete", type = "flash.events.Event")];
	
	public class BlackBackgraound extends Sprite
	{
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	CONSTRUCTOR
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		/**
		 * 创建新的 BlackBackground 对象。
		 * 
		 * @param	parent - 背景父级的 Sprite 对象。
		 * @param	color - 背景的颜色。
		 * @param	x - 背景的 x 轴位置。
		 * @param	y - 背景的 y 轴位置。
		 * @param	width - 背景的宽度。
		 * @param	height - 背景的高度。
		 */
		public function BlackBackgraound(parent:Sprite = null, color:uint = 0, x:int = 0, y:int = 0, width:int = 900, height:int = 600)
		{
			super();
			
			this.graphics.beginFill(color);
			this.graphics.drawRect(x, y, width, height);
			
			this.alpha = 0;
			
			parent && parent.addChild(this);
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	PROPERTIES
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		/**
		 * 指示背景是否在淡入或淡出完毕后自动摧毁。
		 */
		public var destroyOnComplete:Boolean;
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	ACCESSORS
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	INITIALIZATION
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	METHODS
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		/**
		 * 淡入背景。
		 * 
		 * @param	duration - 淡入所需的秒数。
		 * @param	alpha - 背景淡入后可达的最大透明度。
		 * @param	destroyOnComplete - 完成后是否摧毁自身背景对象。
		 */
		public function fadein(duration:Number = 1, alpha:Number = 1, destroyOnComplete:Boolean = true):void
		{
			this.alpha == 1 && (this.alpha = 0);
			
			this.destroyOnComplete = destroyOnComplete;
			
			TweenMax.to(this, duration, {ease: Strong.easeOut, autoAlpha: alpha, onComplete: this.onTweenComplete, onUpdate: this.onTweenUpdate});
		}
		
		/**
		 * 淡出背景。
		 * 
		 * @param	duration - 淡出所需的秒数。
		 * @param	destroyOnComplete - 完成后是否摧毁自身背景对象。
		 */
		public function fadeout(duration:Number = 1.25, destroyOnComplete:Boolean = true):void
		{
			this.alpha == 0 && (this.alpha = 1);
			
			this.destroyOnComplete = destroyOnComplete;
			
			TweenMax.to(this, duration, {ease: Strong.easeOut, autoAlpha: 0, onComplete: this.onTweenComplete, onUpdate: this.onTweenUpdate});
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	FRAME_UPDATER
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	EVENT_HANDLERS
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		/**
		 * 淡入或淡出动画更新。
		 */
		protected function onTweenUpdate():void
		{
			this.parent.visible || (this.parent.visible = true);
			
			
			if (this.parent.getChildIndex(this) != this.parent.numChildren - 1)
				this.parent.setChildIndex(this, this.parent.numChildren - 1);
		}
		
		/**
		 * 淡入或淡出动画完成。
		 */
		protected function onTweenComplete():void
		{
			this.dispatchEvent(new Event(Event.COMPLETE));
			
			this.destroyOnComplete && this.destroy();
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	DESTROYER
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		public function destroy():void
		{
			this.graphics.clear();
			
			this.parent && this.parent.removeChild(this);
		}
	
	}

}