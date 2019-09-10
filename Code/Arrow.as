/**
 * 2016/6/27 18:35
 *
 * 弓箭
 */
package
{
	import com.greensock.easing.Strong;
	import com.greensock.TweenMax;
	
	public class Arrow extends BulletCommon
	{
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	CONSTRUCTOR
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		/**
		 * 创建新的 Arrow 对象。
		 *
		 * @param	x - 弓箭的初始 X 坐标。
		 * @param	y - 弓箭的初始 Y 坐标。
		 * @param	archer - 发射弓箭的弓箭塔。
		 * @param	target - 弓箭的目标位置。
		 * @param	targetEnemy - 弓箭的目标对象。
		 */
		public function Arrow(x:int, y:int, archer:TowerArcher, target:Node, targetEnemy:Enemy)
		{
			super(x, y, archer, target);
			
			this.enemy = targetEnemy;
			
			this._flyingTime = 0.55 * 30;
			
			this.isFlying = true;
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	PROPERTIES
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		/**
		 * 获取或设置弓箭的目标对象。
		 */
		public var enemy:Enemy;
		/**
		 * 指定弓箭是否正在飞行。
		 */
		public var isFlying:Boolean;
		
		/**
		 * 弓箭的水平方向移动速度。
		 */
		protected var _speedX:Number;
		/**
		 * 弓箭的垂直方向移动速度。
		 */
		protected var _speedY:Number;
		/**
		 * 弓箭的重力在垂直方向上的速度，用于影响弓箭的坠落速度。
		 */
		protected var _speedMass:Number;
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	ACCESSORS
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	METHODS
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		/**
		 * [覆盖] 更新弓箭的位置。
		 */
		override public function move():void
		{
			super.move();
			
			this._speedX = this._distanceX / this._flyingTime;
			this._speedY = (this._distanceY - this._flyingTime * this._flyingTime * 0.5) / this._flyingTime;
			this._speedMass = this._mass * this._flyingTimeCounter * this._flyingTimeCounter * 0.5;
			
			this.x = this._originalX + this._speedX * this._flyingTimeCounter;
			this.y = this._originalY + this._speedY * this._flyingTimeCounter + this._speedMass;
		}
		
		/**
		 * 使弓箭进行额外的移动。该移动是指弓箭没有击中目标后的坠落过程。
		 */
		public function extraMove():void
		{
			this._speedMass = this._mass * this._flyingTimeCounter * this._flyingTimeCounter * 0.5;
			
			this.x = this._originalX + this._speedX * this._flyingTimeCounter;
			this.y = this._originalY + this._speedY * this._flyingTimeCounter + this._speedMass;
			
			if (this.y >= this.target.y - this.enemy.enemyAdjustY || this._flyingTimeCounter >= this._flyingTime * 2)
			{
				this.gotoAndStop(2);
				
				this.isFlying = false;
				
				super.hit();
			}
		}
		
		/**
		 * [覆盖] 更新弓箭的旋转。
		 */
		override public function rotate():void
		{
			var position1:Node = new Node(this.x - this.width * 0.5, this.y - this.height * 0.5);
			var position2:Node = new Node();
			
			this._flyingTimeCounter++;
			
			var speedMass:Number = this._mass * this._flyingTimeCounter * this._flyingTimeCounter * 0.5;
			
			position2.x = this._originalX + this._speedX * this._flyingTimeCounter - this.width * 0.5;
			position2.y = this._originalY + this._speedY * this._flyingTimeCounter + speedMass - this.height * 0.5;
			
			this._flyingTimeCounter--;
			
			this.rotation = Math.atan2(position2.y - position1.y, position2.x - position1.x) * 180 / Math.PI;
			
			position1 = null;
			position2 = null;
		}
		
		/**
		 * [覆盖] 淡出弓箭。
		 */
		override public function fadeout():void
		{
			if (this.currentFrame == 3)
				TweenMax.fromTo(this, 0.7, {ease: Strong.easeOut, scaleX: 0, scaleY: 0, autoAlpha: 1}, {scaleX: 1, scaleY: 1, autoAlpha: 0, onComplete: this.onFadeoutComplete});
			else
				TweenMax.to(this, 1.2, {autoAlpha: 0, onComplete: this.onFadeoutComplete});
		}
		
		/**
		 * [覆盖] 使弓箭对目标造成伤害。
		 */
		override public function hit():void
		{
			if (!(this.enemy.isActive && this.enemy.hitTestPoint(this.x, this.y, true)))
				return;
			
			this.gotoAndStop(3);
			this.enemy.damage(this.getDamage());
			
			this.isFlying = false;
			
			if (enemy.enemyHP == 0)
			{
				if (Math.random() < 0.5)
					new Pop(this.enemy.x, this.enemy.y, Pop.OOF, this.level);
				else
					new Pop(this.enemy.x, this.enemy.y, Pop.SHUNT, this.level);
			}
			
			super.hit();
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	FRAME_UPDATER
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		override public function updateFrame():void
		{
			if (!this.isFlying)
				return;
			
			this._flyingTimeCounter++;
			if (this._flyingTimeCounter < this._flyingTime)
				this.move();
			else
				this.extraMove();
			
			this.rotate();
			
			if (!this.isActive)
				return;
			
			if (this._flyingTimeCounter == this._flyingTime)
				this.hit();
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	EVENT_HANDLERS
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	DESTROYER
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
		
		override public function destroy():void
		{
			this.enemy = null;
			
			super.destroy();
		}
	
	}

}