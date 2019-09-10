/**
 * 2016/1/17 12:01
 *
 * 弹出的文字气泡
 */
package
{
	import com.greensock.easing.Back;
	import com.greensock.TweenMax;
	import flash.filters.DropShadowFilter;
	
	public class Pop extends LevelEntity
	{
		
		/// /// /// /// ///
		///    STATIC   ///
		/// /// /// /// ///
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	STATIC_PROPERTIES_AND_ACCESSORS
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
		
		/**
		 * [静态] 定义“OOF”样式文字气泡的 pop 参数。
		 */
		static public const OOF:String = "oof";
		/**
		 * [静态] 定义“SHUNT”样式文字气泡的 pop 参数。
		 */
		static public const SHUNT:String = "shunt";
		/**
		 * [静态] 定义“KBOOM”样式文字气泡的 pop 参数。
		 */
		static public const KBOOM:String = "kboom";
		/**
		 * [静态] 定义“ZAP”样式文字气泡的 pop 参数。
		 */
		static public const ZAP:String = "zap";
		
		static public const POW:String = "pow";
		
		static public const SOK:String = "sok";
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	STATIC_METHODS
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
		
		/// /// /// /// ///
		///   INSTANCE	///
		/// /// /// /// ///
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	CONSTRUCTOR
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
		
		/**
		 * 创建新的 Pop 对象。
		 *
		 * @param	x - 文字气泡的目标 X 坐标。
		 * @param	y - 文字气泡的目标 Y 坐标。
		 * @param	pop - 文字气泡的类型。
		 * @param	level - 所属的关卡。
		 */
		public function Pop(x:int, y:int, pop:String, level:Level)
		{
			super(x, y - 60, level.bullets);
			
			this.mouseChildren = false;
			this.mouseEnabled = false;
			
			this.rotation = Math.random() * 72 - 36;
			
			this.gotoAndStop(pop);
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	PROPERTIES
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	ACCESSORS
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	INITIALIZATION
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
		
		override public function init():void
		{
			super.init();
			
			this.fadein();
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	METHODS
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
		
		/**
		 * 淡入气泡。
		 */
		public function fadein():void
		{
			TweenMax.from(this, 0.5, {ease: Back.easeOut, scaleX: 0, scaleY: 0, onComplete: this.onFadeinComplete});
		}
		
		/**
		 * 淡出气泡。
		 */
		public function fadeout():void
		{
			TweenMax.to(this, 0.3, {delay: 0.5, autoAlpha: 0, onComplete: this.onFadeoutComplete});
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	FRAME_UPDATER
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	EVENT_HANDLERS
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
		
		/**
		 * 淡入完成。
		 */
		protected function onFadeinComplete():void
		{
			this.fadeout();
		}
		
		/**
		 * 淡出完成。
		 */
		protected function onFadeoutComplete():void
		{
			this.destroy();
		}
	
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	DESTROYER
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
	
	}

}