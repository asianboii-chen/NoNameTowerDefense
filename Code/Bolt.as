/**
 * 2016/6/27 18:43
 * 
 * 能量弹
 */
package
{
	import com.greensock.easing.Strong;
	import com.greensock.TweenMax;
	
	public class Bolt extends BulletCommon
	{
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	CONSTRUCTOR
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		/**
		 * 创建新的 Bolt 对象。
		 * 
		 * @param	x - 能量弹的起始 x 轴位置。
		 * @param	y - 能量弹的起始 y 轴位置。
		 * @param	mage - 能量弹所属的魔法塔。
		 * @param	targetEnemy - 能量弹的目标敌人。
		 */
		public function Bolt(x:int, y:int, mage:TowerMage, targetEnemy:Enemy)
		{
			super(x, y, mage);
			
			this.enemy = targetEnemy;
			
			this.target.x = targetEnemy.x + targetEnemy.enemyAdjustX;
			this.target.y = targetEnemy.y + targetEnemy.enemyAdjustY;
			
			this._acceleration = 1;
			this._maxAcceleration = 10;
			
			this.gotoAndStop(1);
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	PROPERTIES
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		/**
		 * 能量弹的目标敌人。
		 */
		public var enemy:Enemy;
		
		/**
		 * 能量弹的当前速度。
		 */
		protected var _acceleration:Number;
		/**
		 * 能量弹的最大速度。
		 */
		protected var _maxAcceleration:Number;
		
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
		 * [覆盖] 更新能量弹的位置。
		 */
		override public function move():void
		{
			super.move();
			
			if (this.enemy)
			{
				this.target.x = this.enemy.x + this.enemy.enemyAdjustX;
				this.target.y = this.enemy.y + this.enemy.enemyAdjustY;
			}
			
			var direction:Number = Node.direction(this, this.target) * Math.PI / 180;
			
			var speedX:Number = Math.cos(direction) * this._acceleration;
			var speedY:Number = Math.sin(direction) * this._acceleration;
			
			this.x += speedX;
			this.y += speedY;
			
			this._acceleration < this._maxAcceleration && (this._acceleration = int(Math.min(this._acceleration * 1.08, this._maxAcceleration) + 1));
			
			if (Node.distance(this.x + speedX, this.y + speedY, this.target.x, this.target.y) < this._acceleration)
			{
				this.x = this.target.x;
				this.y = this.target.y;
				
				this.hit();
			}
		}
		
		/**
		 * [覆盖] 使能量弹击中敌人。
		 */
		override public function hit():void
		{
			if (this.enemy.isActive)
			{
				this.gotoAndStop(2);
				this.enemy.magicDamage(this.getDamage());
				
				if (this.enemy.enemyHP == 0)
					new Pop(this.enemy.x, this.enemy.y, Pop.ZAP, this.level);
			}
			
			super.hit();
		}
		
		/**
		 * [覆盖] 淡出能量弹。
		 */
		override public function fadeout():void
		{
			if (this.currentFrame == 2)
				TweenMax.fromTo(this, 0.7, {ease: Strong.easeOut, scaleX: 0, scaleY: 0, autoAlpha: 1}, {scaleX: 1, scaleY: 1, autoAlpha: 0, onComplete: this.onFadeoutComplete});
			else
				TweenMax.to(this, 1.2, {autoAlpha: 0, onComplete: this.onFadeoutComplete});
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	FRAME_UPDATER
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		override public function updateFrame():void
		{
			if (!this.isActive)
				return;
			
			this.move();
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