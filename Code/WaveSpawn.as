/**
 * 2016/1/17 14:58
 *
 * 波中出现的敌人
 */
package
{
	
	public class WaveSpawn
	{
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	CONSTRUCTOR
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
		
		/**
		 * 创建新的 WaveSpawn 对象。
		 *
		 * @param	enemy - 敌人的类型。
		 * @param	numberTotal - 敌人的数量。
		 * @param	delay - 出第一个敌人前的时隔。
		 * @param	interval - 出两个敌人之间的时隔。
		 * @param	pathIndex - 敌人的路线编号。
		 * @param	pathSideIndex - 敌人路线的位置编号。
		 */
		public function WaveSpawn(enemy:Class, numberTotal:int, delay:int = 0, interval:int = 0, pathIndex:int = 0, pathSideIndex:int = -1)
		{
			this.enemy = enemy;
			this.pathIndex = pathIndex;
			this.pathSideIndex = pathSideIndex;
			this.numberTotal = numberTotal;
			this.delay = delay;
			this._intervalCounter = this.interval = interval;
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	PROPERTIES
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
		
		/**
		 * 所属的关卡。
		 */
		public var level:Level;
		/**
		 * 敌人的类型。
		 */
		public var enemy:Class;
		/**
		 * 敌人的路线编号。
		 */
		public var pathIndex:int;
		/**
		 * 敌人路线的位置编号。
		 */
		public var pathSideIndex:int;
		/**
		 * 是否已经出现了所有敌人。
		 */
		public var isDone:Boolean;
		/**
		 * 敌人的数量。
		 */
		public var numberTotal:int;
		/**
		 * 出第一个敌人前的时隔。
		 */
		public var delay:int;
		/**
		 * 出两个敌人之间的时隔。
		 */
		public var interval:int;
		
		/**
		 * numberTotal 的计数器。
		 */
		private var _numberCounter:int;
		/**
		 * delay 的计时器。
		 */
		private var _delayCounter:int;
		/**
		 * interval 的计时器。
		 */
		private var _intervalCounter:int;
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	ACCESSORS
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	INITIALIZATION
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	METHODS
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	FRAME_UPDATER
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
		
		public function updateFrame():void
		{
			if (this.isDone)
				return;
			
			if (this._delayCounter < this.delay)
			{
				this._delayCounter++;
				return;
			}
			
			if (this._intervalCounter < this.interval)
			{
				this._intervalCounter++;
				return;
			}
			
			this._intervalCounter = 0;
			
			var enemyPath:Array = this.level.paths[this.pathIndex];
			
			if (this.pathSideIndex == -1)
				new enemy(enemyPath[int(Math.random() * enemyPath.length)], this.level.game.gameSettings.getSettingsByClass(this.enemy), this.level.entities);
			else
				new enemy(enemyPath[this.pathSideIndex], this.level.game.gameSettings.getSettingsByClass(this.enemy), this.level.entities);
			
			this._numberCounter++;
						
			if (this._numberCounter == this.numberTotal)
				this.isDone = true;
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	EVENT_HANDLERS
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	DESTROYER
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
		
		public function destroy():void
		{
			this.enemy = null;
		}
	
	}

}