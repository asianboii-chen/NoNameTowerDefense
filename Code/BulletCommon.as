/**
 * 2016/1/16 11:21
 *
 * [抽象基类] 子弹
 * （炮弹、弓箭等的基类）
 */
package
{
	import com.greensock.easing.Strong;
	import com.greensock.TweenMax;
	
	public class BulletCommon extends LevelEntity
	{
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	CONSTRUCTOR
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
		
		/**
		 * [抽象基类] BulletCommon 类是抽象基类，实例化该类可能会出现异常。
		 *
		 * @param	x - 子弹的初始 X 坐标。
		 * @param	y - 子弹的初始 Y 坐标。
		 * @param	tower - 发射该子弹的塔台。
		 * @param	target - 子弹的目标位置。
		 */
		public function BulletCommon(x:int, y:int, tower:Tower, target:Node = null)
		{
			super(x, y, tower.level.bullets);
			
			this.mouseChildren = false;
			this.mouseEnabled = false;
			this.tower = tower;
			this.minDamage = tower.towerMinDamage;
			this.maxDamage = tower.towerMaxDamage;
			
			this._flyingTime = 1 * 30;
			this._mass = 1;
			this._originalX = this.x;
			this._originalY = this.y;
			
			if (target)
			{
				this.target = target;
				this._distanceX = target.x - this.x;
				this._distanceY = target.y - this.y;
			}
			else
			{
				this.target = new Node();
			}
			
			this.gotoAndStop(1);
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	PROPERTIES
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
		
		/**
		 * 发射该子弹的塔台。
		 */
		public var tower:Tower;
		/**
		 * 子弹的目标位置。
		 */
		public var target:Node;
		/**
		 * 子弹的最小伤害。
		 */
		public var minDamage:int;
		/**
		 * 子弹的最大伤害。
		 */
		public var maxDamage:int;
		
		/**
		 * 子弹的飞行总时间。
		 */
		protected var _flyingTime:int;
		/**
		 * 子弹的当前飞行时间。
		 */
		protected var _flyingTimeCounter:int;
		/**
		 * 子弹的质量。这个质量可以决定子弹的坠落速度。
		 */
		protected var _mass:Number;
		/**
		 * 子弹的初始 X 坐标。
		 */
		protected var _originalX:Number;
		/**
		 * 子弹的初始 Y 坐标。
		 */
		protected var _originalY:Number;
		/**
		 * 子弹和目标的 X 轴距离。
		 */
		protected var _distanceX:Number;
		/**
		 * 子弹和目标的 Y 轴距离。
		 */
		protected var _distanceY:Number;
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	ACCESSORS
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	INITIALIZATION
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
		
		override public function init():void 
		{
			super.init();
			
			this.level.addBullet(this);
		}

// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	METHODS
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
		
		/**
		 * 更新子弹的位置。
		 */
		public function move():void
		{
		}
		
		/**
		 * 更新子弹的旋转。
		 */
		public function rotate():void
		{
		}
		
		/**
		 * 淡出子弹。
		 */
		public function fadeout():void
		{
			TweenMax.fromTo(this, 0.7, {ease: Strong.easeOut, scaleX: 0, scaleY: 0, autoAlpha: 1}, {scaleX: 1, scaleY: 1, autoAlpha: 0, onComplete: this.onFadeoutComplete});
		}
		
		/**
		 * 使子弹击中目标。
		 */
		public function hit():void
		{
			this.fadeout();
			this.isActive = false;
		}
		
		/**
		 * 获取子弹的随机伤害。
		 */
		public function getDamage():int
		{
			return int(this.minDamage + Math.random() * (this.maxDamage - this.minDamage + 1));
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	FRAME_UPDATER
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
		
		override public function updateFrame():void
		{
			super.updateFrame();
			
			if (this._flyingTimeCounter < this._flyingTime)
			{
				this._flyingTimeCounter++;
				this.move();
				this.rotate();
				return;
			}
			
			if (!this.isActive)
				return;
			
			this.hit();
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	EVENT_HANDLERS
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
		
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
		
		override public function destroy():void
		{
			this.level.removeBullet(this);
			
			this.tower = null;
			this.target = null;
			
			super.destroy();
		}
	
	}

}