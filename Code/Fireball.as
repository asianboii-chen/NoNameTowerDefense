/**
 * 2016/6/27 19:17
 * 
 * 火球
 */
package
{
	import com.greensock.easing.Strong;
	import com.greensock.TweenMax;
	import org.casalib.math.geom.Ellipse;
	
	public class Fireball extends LevelEntity
	{
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	CONSTRUCTOR
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		/**
		 * 创建新的 Fireball 对象。
		 * 
		 * @param	level - 所属的关卡。
		 * @param	target - 火球的目标位置。
		 * @param	speed - 火球的降落速度。
		 * @param	damage - 火球的伤害。
		 * @param	rangeSplash - 火球的爆炸溅射范围。
		 */
		public function Fireball(level:Level, target:Node, speed:Number, damage:int, rangeSplash:int)
		{
			super(target.x, -30, level.bullets);
			
			this.target = target;
			this.speed = speed;
			this.damage = damage;
			this.rangeSplash = rangeSplash;
			this.isFalling = true;
			
			this._acceleration = 13;
			this._maxAcceleration = 19;
			this._hitTime = 10;
			
			level.addBullet(this);
			
			this.gotoAndStop(1);
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	PROPERTIES
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		/**
		 * 火球的目标位置。
		 */
		public var target:Node;
		/**
		 * 火球的降落速度。
		 */
		public var speed:Number;
		/**
		 * 火球的伤害。
		 */
		public var damage:int;
		/**
		 * 火球爆炸的溅射范围。
		 */
		public var rangeSplash:int;
		/**
		 * 指示火球是否正在降落（正在降落或正在爆炸）。
		 */
		public var isFalling:Boolean;
		
		/**
		 * 火球的加速度。
		 */
		protected var _acceleration:Number;
		/**
		 * 火球的最大加速度。
		 */
		protected var _maxAcceleration:Number;
		/**
		 * 火球的爆炸时间。
		 */
		protected var _hitTime:int;
		
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
		 * 更新火球的位置。
		 */
		public function move():void
		{
			this._acceleration < this._maxAcceleration && (this._acceleration = Math.min(this._acceleration * 1.1, this._maxAcceleration));
			
			this.y += this._acceleration;
			
			if (this.target.y - this.y <= this._acceleration)
			{
				this.x = this.target.x;
				this.y = this.target.y;
				
				this.hit();
			}
		}
		
		/**
		 * 使火球击中敌人。
		 */
		public function hit():void
		{
			this.isFalling = false;
			
			this.gotoAndPlay(2);
			
			var splashRange:Ellipse = new Ellipse(this.x - this.rangeSplash * 0.5, this.y - this.rangeSplash * 0.7 * 0.5, this.rangeSplash, 0.7 * this.rangeSplash);
			var position:Node = new Node();
			
			for each(var p:Enemy in this.level.dEnemies)
			{
				position.x = p.x;
				position.y = p.y;
				
				if (!splashRange.containsPoint(position))
					continue;
				
				p.fireDamage(Math.random() < 0.5 ? this.damage : this.damage * (1 - splashRange.pointPosition(position) * 0.75));
			}
			p = null;
			
			splashRange = null;
			position = null;
		}
		
		/**
		 * [覆盖] 暂停火球。
		 */
		override public function pause():void
		{
			this.stop();
		}
		
		/**
		 * [覆盖] 取消暂停火球。
		 */
		override public function unpause():void
		{
			this.currentFrame == 1 || this.currentFrame == this._hitTime || this.play();
		}
		
		/**
		 * 淡出火球。
		 */
		public function fadeout():void
		{
			this.gotoAndStop(10);
			
			this.isActive = false;
			
			TweenMax.to(this, 0.7, {ease: Strong.easeOut, scaleX: 1.5, scaleY: 1.5, autoAlpha: 0, onComplete: this.onFadeoutComplete});
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	FRAME_UPDATER
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		override public function updateFrame():void
		{
			if (!this.isActive)
				return;
			
			if (this.isFalling)
			{
				this.move();
			}
			else
			{
				if (this.currentFrame == this._hitTime)
					this.fadeout();
			}
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	EVENT_HANDLERS
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		/**
		 * 火球淡出完毕。
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
			
			super.destroy();
		}
		
	}

}