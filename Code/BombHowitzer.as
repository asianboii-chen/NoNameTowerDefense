/**
 * 2016/1/16 11:13
 *
 * 榴炮（3级炮弹）
 */
package
{
	
	public class BombHowitzer extends Bomb
	{
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	CONSTRUCTOR
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
		
		/**
		 * 创建新的 BombHowitzer 对象。
		 *
		 * @param	x - 榴炮的初始 X 坐标。
		 * @param	y - 榴炮的初始 Y 坐标。
		 * @param	artillery - 发射榴炮的炮塔对象。
		 * @param	target - 榴炮的目标位置。
		 */
		public function BombHowitzer(x:int, y:int, artillery:TowerArtillery, target:Node)
		{
			super(x, y, artillery, target);
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
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	METHODS
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
		
/**
 * [覆盖] 更新榴炮的旋转。
 */
		override public function rotate():void
		{
			var position1:Node = new Node(this.x, this.y);
			var position2:Node = new Node();
			
			this._flyingTimeCounter++;
			
			var speedX:Number = this._distanceX / this._flyingTime;
			var speedY:Number = this._distanceY / this._flyingTime - this._mass * this._flyingTime * 0.5;
			var speedMass:Number = this._mass * this._flyingTimeCounter * this._flyingTimeCounter * 0.5;
			
			position2.x = this._originalX + speedX * this._flyingTimeCounter;
			position2.y = this._originalY + speedY * this._flyingTimeCounter + speedMass;
			
			this._flyingTimeCounter--;
			
			this.rotation = Math.atan2(position2.y - position1.y, position2.x - position1.x) * 180 / Math.PI;
			
			position1 = null;
			position2 = null;
		}
	
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	FRAME_UPDATER
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
	
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	EVENT_HANDLERS
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
	
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	DESTROYER
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
	
	}

}