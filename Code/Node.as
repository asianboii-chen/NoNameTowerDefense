/**
 * 2016/1/17 11:28
 *
 * 路径节点
 */
package
{
	import flash.geom.Point;
	
	public class Node extends Point
	{
		
		/// /// /// /// ///
		///    STATIC   ///
		/// /// /// /// ///
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	STATIC_PROPERTIES_AND_ACCESSORS
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	STATIC_METHODS
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
		
		/**
		 * 计算两个点之间的距离。这两个点可以填入两个对象，也可以分别填入
		 * 两点的 X 和 Y 坐标。
		 *
		 * @param	arg0 - 第一个点或第一个点的 X 坐标。
		 * @param	arg1 - 第二个点或第一个点的 Y 坐标。
		 * @param	x1 - 第二个点的 X 坐标。
		 * @param	y1 - 第二个点的 Y 坐标。
		 */
		static public function distance(arg0:*, arg1:*, x1:Number = NaN, y1:Number = NaN):Number
		{
			var distanceX:Number;
			var distanceY:Number;
			var distance:Number;
			
			if (arg0 is Number && arg1 is Number)
			{
				distanceX = x1 - arg0;
				distanceY = y1 - arg1;
			}
			else
			{
				distanceX = arg1.x - arg0.x;
				distanceY = arg1.y - arg0.y;
			}
			
			distance = Math.sqrt(distanceX * distanceX + distanceY * distanceY);
			
			return distance *= (distance < 0 ? -1 : 1);
		}
		
		/**
		 * 计算第二个点相对于第一个点的方向。这两个点可以填入两个
		 * 对象，也可以分别填入两点的 X 和 Y 坐标。
		 *
		 * @param	arg0 - 第一个点或第一个点的 X 坐标。
		 * @param	arg1 - 第二个点或第一个点的 Y 坐标。
		 * @param	x1 - 第二个点的 X 坐标。
		 * @param	y1 - 第二个点的 Y 坐标。
		 */
		static public function direction(arg0:*, arg1:*, x1:Number = NaN, y1:Number = NaN):Number
		{
			var distanceX:Number;
			var distanceY:Number;
			
			if (arg0 is Number && arg1 is Number)
			{
				distanceX = x1 - arg0;
				distanceY = y1 - arg1;
			}
			else
			{
				distanceX = arg1.x - arg0.x;
				distanceY = arg1.y - arg0.y;
			}
			
			return Math.atan2(distanceY, distanceX) * 180 / Math.PI;
		}
		
		/// /// /// /// ///
		///   INSTANCE	///
		/// /// /// /// ///
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	CONSTRUCTOR
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		/**
		 * 创建新的 Node 对象。
		 *
		 * @param	x - 节点的 X 坐标。
		 * @param	y - 节点的 Y 坐标。
		 * @param	visible - 处在该节点上的敌人是否显示。
		 * @param	isBegining - 节点是否为路径的开始。
		 * @param	isEnd - 节点是否为路径的结束。
		 */
		public function Node(x:Number = 0, y:Number = 0, visible:Boolean = true, isBegining:Boolean = false, isEnd:Boolean = false):void
		{
			super(x, y);
			
			this.visible = visible;
			this.isBegining = isBegining;
			this.isEnd = isEnd;
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	PROPERTIES
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
		
		/**
		 * [尚未使用] 处在该节点上的敌人是否显示。
		 */
		public var visible:Boolean;
		/**
		 * 节点是否为路径的开始。
		 */
		public var isBegining:Boolean;
		/**
		 * 节点是否为路径的结束。
		 */
		public var isEnd:Boolean;
	
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	ACCESSORS
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
	
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	METHODS
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
		
		override public function toString():String
		{
			return "[x=" + this.x + ",y=" + this.y + ",visible=" + this.visible + ",isBegining=" + this.isBegining + ",isEnd=" + this.isEnd + "]";
		}
	
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	EVENT_HANDLERS
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
	
	}
}
