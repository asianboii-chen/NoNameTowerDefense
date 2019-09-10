/**
 * com.stickgames
 *
 * SGAnimator
 * 
 * 		- 用于播放试刀游戏特色开场动画
 * 		- 纯代码控制动画的播放
 * 		- 需要提前在 FLA 文档中导入位图
 *
 * 		作者：	陳局長
 * 		版本：	1.0.0
 *
 */
package com.stickgames.sganim
{
	/** 导入 **/
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	/** 事件 **/
	
	[Event(name = "complete", type = "flash.events.Event")]; // flash.events.Event.COMPLETE
	
	/**
	 * -- 试刀游戏特色开场动画 --
	 * 作者：陳局長
	 * 版本：1.0.0
	 */
	public class SGAnimator extends Sprite
	{
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	CONSTRUCTOR
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		/**
		 * 创建新的 SGAnimator 实例，用于播放试刀游戏特色开场动画。
		 */
		public function SGAnimator()
		{
			/** 使用超类初始化 **/
			
			super();
			
			/** 实例属性设置 **/
			
			this.mouseChildren = false;
			this.mouseEnabled = false;
			
			/** 实例变量设置 **/
			
			this._animAFBDrop = 10; // 字母掉落时间
			this._animLogoDrop = 100; // Logo 掉落时间
			this._animAFBShake = 103; // 字母震荡时间
			this._animAFBOut = 146; // 字母退场时间
			this._animLogoOut = 164; // Logo 退场时间
			this._animTime = 228; // 动画总时间
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	PROPERTIES
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		/**
		 * 特色动画中的字母动画实例。
		 */
		public var afbsAnim:SGAnimAlphabets;
		
		/**
		 * 特色动画中的 Logo 动画实例。
		 */
		public var logoAnim:SGAnimLogo;
		
		/** @private **/
		protected var _animTime:int;
		
		/** @private **/
		protected var _animAFBDrop:int;
		
		/** @private **/
		protected var _animLogoDrop:int;
		
		/** @private **/
		protected var _animAFBShake:int;
		
		/** @private **/
		protected var _animAFBOut:int;
		
		/** @private **/
		protected var _animLogoOut:int;
		
		/** @private **/
		protected var _animTimeCounter:int;
		
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
		 * 开始播放试刀游戏特色开场动画。
		 */
		public function start():void
		{
			this.addEventListener(Event.ENTER_FRAME, this.onFrameUpdate, false, 1, true);
		}
		
		/**
		 * 完成播放试刀游戏特色开场动画。
		 *
		 * @internal
		 */
		internal function complete():void
		{
			this.dispatchEvent(new Event(Event.COMPLETE));
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	FRAME_UPDATER
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	EVENT_HANDLERS
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		/** @private **/
		protected function onFrameUpdate(event:Event):void
		{
			if (this._animTimeCounter < 0)
				return;
			
			this._animTimeCounter++;
			
			switch (this._animTimeCounter)
			{
				case this._animAFBDrop: 
					this.afbsAnim.dropAlphabets();
					break;
				
				case this._animLogoDrop: 
					this.logoAnim.drop();
					break;
				
				case this._animAFBShake: 
					this.afbsAnim.shakeAlphabets();
					break;
				
				case this._animAFBOut: 
					this.afbsAnim.fadeoutAlphabets();
					break;
				
				case this._animLogoOut: 
					this.logoAnim.fadeout();
					break;
				
				case this._animTime: 
					this._animTimeCounter = -1;
					this.complete();
					break;
			}
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	DESTROYER
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		/**
		 * 摧毁该 SGAnimator 实例。
		 */
		public function destroy():void
		{
			this.removeEventListener(Event.ENTER_FRAME, this.onFrameUpdate);
			
			this.afbsAnim.destroy();
			this.afbsAnim = null;
			
			this.parent && this.parent.removeChild(this);
		}
	
	}

}