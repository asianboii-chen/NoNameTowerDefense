/**
 * 2016/1/16 10:59
 *
 * 炮弹
 */
package
{
	import org.casalib.math.geom.Ellipse;
	
	public class Bomb extends BulletCommon
	{
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	CONSTRUCTOR
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		/**
		 * 创建新的 Bomb 对象。
		 *
		 * @param	x - 炮弹的初始 X 坐标。
		 * @param	y - 炮弹的初始 Y 坐标。
		 * @param	artillery - 发射炮弹的炮塔对象。
		 * @param	target - 炮弹的目标位置。
		 */
		public function Bomb(x:int, y:int, artillery:TowerArtillery, target:Node)
		{
			super(x, y, artillery, target);
			
			this.rangeSplash = artillery.towerRangeSplash;
			
			this.rotation = Math.random() * 360;
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	PROPERTIES
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		/**
		 * 获取或设置炮弹的溅射范围。
		 */
		public var rangeSplash:int;
		
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
		 * [覆盖] 获取炮弹的随机伤害值。每个炮弹有 50% 几率释放上限伤害。
		 */
		override public function getDamage():int
		{
			return Math.random() < 0.5 ? this.maxDamage : super.getDamage();
		}
		
		/**
		 * [覆盖] 更新炮弹的位置。
		 */
		override public function move():void
		{
			super.move();
			
			var speedX:Number = this._distanceX / this._flyingTime;
			var speedY:Number = this._distanceY / this._flyingTime - this._mass * this._flyingTime * 0.5;
			var speedMass:Number = this._mass * this._flyingTimeCounter * this._flyingTimeCounter * 0.5;
			
			this.x = this._originalX + speedX * this._flyingTimeCounter;
			this.y = this._originalY + speedY * this._flyingTimeCounter + speedMass;
		}
		
		/**
		 * [覆盖] 更新炮弹的旋转。
		 */
		override public function rotate():void
		{
			super.rotate();
			
			this.rotation += (this.target.x - this._originalX) * 0.14 + (this.target.x - this._originalX >= 0 ? 7 : -7);
		}
		
		/**
		 * [覆盖] 引爆炮弹。
		 */
		override public function hit():void
		{
			super.hit();
			
			this.rotation = 0;
			this.gotoAndStop(2);
			
			new Pop(this.x, this.y, Pop.KBOOM, this.level);
			
			var splashRange:Ellipse = new Ellipse(this.x - this.rangeSplash * 0.5, this.y - this.rangeSplash * 0.7 * 0.5, this.rangeSplash, 0.7 * this.rangeSplash);
			var position:Node = new Node();
			var damage:int = this.getDamage();
			
			for each (var p:Enemy in this.level.dEnemies)
			{
				position.x = p.x;
				position.y = p.y;
				
				if (!splashRange.containsPoint(position))
					continue;
				
				p.damage(Math.random() < 0.5 ? damage : damage * (1 - splashRange.pointPosition(position) * 0.75));
			}
			p = null;
			
			splashRange = null;
			position = null;
		}
	
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	FRAME_UPDATER
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
	
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	EVENT_HANDLERS
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
	
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	DESTROTER
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
	
	}

}