/**
 * 2016/7/2 11:56
 *
 * 游戏配置中的一个项目
 */
package
{
	
	public class GameSettingItem
	{
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	CONSTRUCTOR
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
		
		/**
		 * 创建新的 GameSettingItem 对象。
		 *
		 * @param	settings - 该对象所拥有的属性。
		 */
		public function GameSettingItem(settings:Object = null)
		{
			if (!settings)
				return;
			
			for (var p:String in settings)
			{
				this[p] = settings[p];
			}
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	PROPERTIES
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
		
		/**
		 * 对象的名字（塔、敌人或士兵）。
		 */
		public var name:String = "[object Object]";
		/**
		 * 对象的速度（敌人或士兵）。
		 */
		public var speed:Number;
		/**
		 * 对象的装甲（敌人或士兵）。
		 */
		public var armor:Number;
		/**
		 * 对象的魔法抗性（敌人或士兵）。
		 */
		public var magicArmor:Number;
		/**
		 * 对象的闪避几率（敌人或士兵）。
		 */
		public var dodge:Number;
		/**
		 * 对象的生命（敌人或士兵）。
		 */
		public var hp:int;
		/**
		 * 对象攻击所能造成的最小伤害（塔、敌人或士兵）。
		 */
		public var minDamage:int;
		/**
		 * 对象攻击所能造成的最大伤害（塔、敌人或士兵）。
		 */
		public var maxDamage:int;
		/**
		 * 对象攻击的间隔（30 为一秒，塔、敌人或士兵）。
		 */
		public var reload:int;
		/**
		 * 对象每次回复的生命值（敌人或士兵）。
		 */
		public var regen:int;
		/**
		 * 对象的重生时间（30 为一秒，士兵）。
		 */
		public var respawn:int;
		/**
		 * 对象攻击的范围（以像素为单位，塔或士兵）。
		 */
		public var range:int;
		/**
		 * 对象相比升级之前增加的范围（以像素为单位，塔）。
		 */
		public var rangeExtra:int;
		/**
		 * 对象攻击的溅射范围（以像素为单位，塔或士兵）。
		 */
		public var rangeSplash:int;
		/**
		 * 对象的造价（塔）或杀死后的奖励（敌人）。
		 */
		public var price:int;
		/**
		 * 对象逃跑后的代价（敌人）。
		 */
		public var loseLife:int;
		/**
		 * 对象的 X 轴校准（塔、敌人或士兵）。
		 */
		public var adjustX:int;
		/**
		 * 对象的 Y 轴校准（塔、敌人或士兵）。
		 */
		public var adjustY:int;
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	ACCESSORS
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	METHODS
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
		
		/**
		 * [覆盖] 返回此 GameSettingItem 对象的字符串表现形式。
		 */
		public function toString():String
		{
			return "[name=\"" + this.name + "\",speed=" + this.speed + ",armor=" + this.armor + ",magicArmor=" + this.magicArmor + ",hp=" + this.hp + ",minDamage=" + this.minDamage + ",maxDamage=" + this.maxDamage + ",range=" + this.range + ",rangeExtra=" + this.rangeExtra + ",rangeSplash=" + this.rangeSplash + ",reload=" + this.reload + ",respawn=" + this.respawn + ",price=" + this.price + ",loseLife=" + this.loseLife + ",adjustX=" + this.adjustX + ",adjustY=" + this.adjustY + "]";
		}
	
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	EVENT_HANDLERS
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
	
	}

}