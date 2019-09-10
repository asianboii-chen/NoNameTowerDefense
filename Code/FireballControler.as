/**
 * 2016/6/27 19:21
 * 
 * 火球的控制者
 */
package
{
	
	public class FireballControler extends LevelEntity
	{
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	CONSTRUCTOR
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		/**
		 * 创建新的 FirebassControler 对象。
		 * 
		 * @param	target - 火雨降落的目标中心位置。
		 * @param	spell - 火雨技能。
		 */
		public function FireballControler(target:Node, spell:SpellFireball)
		{
			super(0, 0, spell.level.bullets);
			
			spell.level.addBullet(this);
			
			this.spell = spell;
			this.target = target;
			this.speed = spell.fireballSpeed;
			this.reload = spell.fireballReload;
			this.number = spell.fireballNumber;
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	PROPERTIES
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		/**
		 * 火雨技能。
		 */
		public var spell:SpellFireball;
		/**
		 * 火雨降落的目标中心位置。
		 */
		public var target:Node;
		/**
		 * 火球降落的速度。
		 */
		public var speed:Number;
		/**
		 * 火球的数量。
		 */
		public var number:int;
		/**
		 * 两个火球降落的间隔。
		 */
		public var reload:int;
		/**
		 * 火球降落离火雨中心的最大误差。
		 */
		public var range:int;
		/**
		 * 火球爆炸的溅射范围。
		 */
		public var rangeSplash:int;
		
		/**
		 * 火球个数计数器。
		 */
		protected var _counter:int;
		/**
		 * 火球降落间隔计时器。
		 */
		protected var _reloadCounter:int;
		
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
		 * 降落一个火球。
		 */
		public function dropFireball():Fireball
		{
			var target:Node = new Node();
			var damage:int;
			
			target.x = this.target.x + this.spell.fireballRange * (Math.random() - 0.5);
			target.y = this.target.y + this.spell.fireballRange * (Math.random() - 0.5) * 0.7;
			
			damage = int(this.spell.fireballMinDamage + Math.random() * (this.spell.fireballMaxDamage - this.spell.fireballMinDamage + 1));
			
			return new Fireball(this.level, target, this.spell.fireballSpeed, damage, this.spell.fireballRangeSplash);
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	FRAME_UPDATER
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		override public function updateFrame():void
		{
			if (this._counter >= this.number)
				return;
			
			if (this._reloadCounter < this.reload)
			{
				this._reloadCounter++;
				return;
			}
			
			this._reloadCounter = 0;
			
			this.dropFireball();
			
			this._counter++;
			
			if (this._counter == this.number)
				this.destroy();
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	EVENT_HANDLERS
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	DESTROYER
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		override public function destroy():void
		{
			this.spell = null;
			this.target = null;
			
			this.level.removeBullet(this);
			
			super.destroy();
		}
	
	}

}