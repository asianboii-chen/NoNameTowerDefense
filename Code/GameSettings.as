/**
 * 2016/7/2 12:07
 *
 * 游戏配置
 */
package
{
	
	public class GameSettings
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
		 * [静态] 根据范围获取范围所处的级别。该级别有“近”、“中”、“远”、“很远”和“极远”。
		 *
		 * @param	range - 范围。
		 */
		static public function getRangeGrade(range:int):String
		{
			if (range < 0)
				throw new Error("不支持的值！");
			
			if (range < 330)
				return "Short";
			
			if (range < 380)
				return "Average";
			
			if (range < 430)
				return "Long";
			
			if (range < 480)
				return "Great";
			
			return "Extreme";
		}
		
		/**
		 * [静态] 根据攻击间隔获取射速所处的级别。该级别有“很慢”、“慢”、“中”、“快”和“很快”。
		 *
		 * @param	reload - 攻击间隔。
		 */
		static public function getReloadGrade(reload:int):String
		{
			if (reload < 0)
				throw new Error("不支持的值！");
			
			if (reload > 2.75 * 30)
				return "Very Slow";
			
			if (reload > 1.5 * 30)
				return "Slow";
			
			if (reload > 1 * 30)
				return "Average";
			
			if (reload > 0.5 * 30)
				return "Fast";
			
			return "Very Fast";
		}
		
		/**
		 * [静态] 根据装甲或魔法抗性获取所处的等级。该级别有“无”、“低”、“中”、“高”和“很高”。
		 *
		 * @param	armor - 装甲或魔法抗性。
		 */
		static public function getArmorGrade(armor:Number):String
		{
			if (armor < 0 || armor > 1)
				throw new Error("不支持的值！");
			
			if (armor == 0)
				return "None";
			
			if (armor < 0.3)
				return "Low";
			
			if (armor < 0.6)
				return "Medium";
			
			if (armor < 0.8)
				return "High";
			
			if (armor < 1)
				return "Great";
			
			return "Immune";
		}
		
		/// /// /// /// ///
		///   INSTANCE	///
		/// /// /// /// ///
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	CONSTRUCTOR
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
		
		/**
		 * 创建新的 GameSettings 对象。
		 */
		public function GameSettings()
		{
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	PROPERTIES
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
		
//==== TOWERS =============================================================================
		
		/**
		 * 等级 1 箭塔配置。
		 */
		public var towerArcher1:GameSettingItem;
		/**
		 * 等级 2 箭塔配置。
		 */
		public var towerArcher2:GameSettingItem;
		/**
		 * 等级 3 箭塔配置。
		 */
		public var towerArcher3:GameSettingItem;
		/**
		 * 等级 1 炮塔配置。
		 */
		public var towerArtillery1:GameSettingItem;
		/**
		 * 等级 2 炮塔配置。
		 */
		public var towerArtillery2:GameSettingItem;
		/**
		 * 等级 3 炮塔配置。
		 */
		public var towerArtillery3:GameSettingItem;
		/**
		 * 等级 1 魔法塔配置。
		 */
		public var towerMage1:GameSettingItem;
		/**
		 * 等级 2 魔法塔配置。
		 */
		public var towerMage2:GameSettingItem;
		/**
		 * 等级 3 魔法塔配置。
		 */
		public var towerMage3:GameSettingItem;
		/**
		 * 等级 1 兵营配置。
		 */
		public var towerBarrack1:GameSettingItem;
		/**
		 * 等级 2 兵营配置。
		 */
		public var towerBarrack2:GameSettingItem;
		/**
		 * 等级 3 兵营配置。
		 */
		public var towerBarrack3:GameSettingItem;
		
//==== SOLDIERS ===========================================================================
		
		/**
		 * 等级 1 兵营士兵配置。
		 */
		public var soldier1:GameSettingItem;
		/**
		 * 等级 2 兵营士兵配置。
		 */
		public var soldier2:GameSettingItem;
		/**
		 * 等级 3 兵营士兵配置。
		 */
		public var soldier3:GameSettingItem;
		
//==== ENEMIES ============================================================================
		
		/**
		 * 小型敌人配置。
		 */
		public var enemySmall:GameSettingItem;
		/**
		 * 中型敌人配置。
		 */
		public var enemyMedium:GameSettingItem;
		/**
		 * 大型敌人配置。
		 */
		public var enemyLarge:GameSettingItem;
		/**
		 * 飞行敌人配置。
		 */
		public var enemyFlying:GameSettingItem;
		/**
		 * 快速敌人配置。
		 */
		public var enemyRunner:GameSettingItem;
		/**
		 * [尚未使用] 装甲敌人配置。
		 */
		public var enemyArmored:GameSettingItem;
		/**
		 * [尚未使用] 巨型敌人配置。
		 */
		public var enemyGiant:GameSettingItem;
		/**
		 * [尚未使用] 敌人 Boss 配置。
		 */
		public var enemyBoss:GameSettingItem;
		
//==== SPELLS =============================================================================
		
		/**
		 * 等级 1 火雨技能配置。
		 */
		public var spellFireball1:GameSettingItem;
		/**
		 * 等级 1 援军技能配置。
		 */
		public var spellReinforcement1:GameSettingItem;
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	ACCESSORS
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	METHODS
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
		
		/**
		 * 从本地加载游戏配置。
		 */
		public function loadLocal():void
		{
			
//==== TOWERS =============================================================================
			
			this.towerArcher1 = new GameSettingItem();
			this.towerArcher1.name = "Archers";
			this.towerArcher1.range = 380;
			this.towerArcher1.rangeExtra = 0;
			this.towerArcher1.reload = 0.7 * 30;
			this.towerArcher1.minDamage = 3;
			this.towerArcher1.maxDamage = 6;
			this.towerArcher1.price = 70;
			this.towerArcher1.adjustX = 0;
			this.towerArcher1.adjustY = -30;
			
			this.towerArcher2 = new GameSettingItem();
			this.towerArcher2.name = "Marksmen";
			this.towerArcher2.range = 430;
			this.towerArcher2.rangeExtra = 50;
			this.towerArcher2.reload = 0.6 * 30;
			this.towerArcher2.minDamage = 6;
			this.towerArcher2.maxDamage = 10;
			this.towerArcher2.price = 110;
			this.towerArcher2.adjustX = 0;
			this.towerArcher2.adjustY = -30;
			
			this.towerArcher3 = new GameSettingItem();
			this.towerArcher3.name = "Sharpshooters";
			this.towerArcher3.range = 485;
			this.towerArcher3.rangeExtra = 55;
			this.towerArcher3.reload = 0.5 * 30;
			this.towerArcher3.minDamage = 10;
			this.towerArcher3.maxDamage = 14;
			this.towerArcher3.price = 160;
			this.towerArcher3.adjustX = 0;
			this.towerArcher3.adjustY = -30;
			
			this.towerArtillery1 = new GameSettingItem();
			this.towerArtillery1.name = "Dwarven Bombard";
			this.towerArtillery1.range = 345;
			this.towerArtillery1.rangeExtra = 0;
			this.towerArtillery1.rangeSplash = 125;
			this.towerArtillery1.reload = 2.75 * 30;
			this.towerArtillery1.minDamage = 8;
			this.towerArtillery1.maxDamage = 15;
			this.towerArtillery1.price = 125;
			this.towerArtillery1.adjustX = 0;
			this.towerArtillery1.adjustY = -23;
			
			this.towerArtillery2 = new GameSettingItem();
			this.towerArtillery2.name = "Dwarven Artillery";
			this.towerArtillery2.range = 345;
			this.towerArtillery2.rangeExtra = 0;
			this.towerArtillery2.rangeSplash = 150;
			this.towerArtillery2.reload = 2.75 * 30;
			this.towerArtillery2.minDamage = 15;
			this.towerArtillery2.maxDamage = 30;
			this.towerArtillery2.price = 220;
			this.towerArtillery2.adjustX = 0;
			this.towerArtillery2.adjustY = -26;
			
			this.towerArtillery3 = new GameSettingItem();
			this.towerArtillery3.name = "Dwarven Howitzer";
			this.towerArtillery3.range = 410;
			this.towerArtillery3.rangeExtra = 65;
			this.towerArtillery3.rangeSplash = 175;
			this.towerArtillery3.reload = 2.75 * 30;
			this.towerArtillery3.minDamage = 30;
			this.towerArtillery3.maxDamage = 60;
			this.towerArtillery3.price = 320;
			this.towerArtillery3.adjustX = 0;
			this.towerArtillery3.adjustY = -30;
			
			this.towerMage1 = new GameSettingItem();
			this.towerMage1.name = "Mage Tower";
			this.towerMage1.range = 310;
			this.towerMage1.rangeExtra = 0;
			this.towerMage1.reload = 1.5 * 30;
			this.towerMage1.minDamage = 9;
			this.towerMage1.maxDamage = 17;
			this.towerMage1.price = 100;
			this.towerMage1.adjustX = 0;
			this.towerMage1.adjustY = -30;
			
			this.towerMage2 = new GameSettingItem();
			this.towerMage2.name = "Adept Tower";
			this.towerMage2.range = 350;
			this.towerMage2.rangeExtra = 40;
			this.towerMage2.reload = 1.5 * 30;
			this.towerMage2.minDamage = 23;
			this.towerMage2.maxDamage = 43;
			this.towerMage2.price = 160;
			this.towerMage2.adjustX = 0;
			this.towerMage2.adjustY = -31;
			
			this.towerMage3 = new GameSettingItem();
			this.towerMage3.name = "Wizard";
			this.towerMage3.range = 390;
			this.towerMage3.rangeExtra = 40;
			this.towerMage3.reload = 1.5 * 30;
			this.towerMage3.minDamage = 40;
			this.towerMage3.maxDamage = 74;
			this.towerMage3.price = 240;
			this.towerMage3.adjustX = 0;
			this.towerMage3.adjustY = -32;
			
			this.towerBarrack1 = new GameSettingItem();
			this.towerBarrack1.name = "Barrack";
			this.towerBarrack1.range = 345;
			this.towerBarrack1.price = 90;
			this.towerBarrack1.adjustX = 0;
			this.towerBarrack1.adjustY = -26;
			
			this.towerBarrack2 = new GameSettingItem();
			this.towerBarrack2.name = "Footmen";
			this.towerBarrack2.range = 345;
			this.towerBarrack2.price = 135;
			this.towerBarrack2.adjustX = 0;
			this.towerBarrack2.adjustY = -27;
			
			this.towerBarrack3 = new GameSettingItem();
			this.towerBarrack3.name = "Knights";
			this.towerBarrack3.range = 345;
			this.towerBarrack3.price = 180;
			this.towerBarrack3.adjustX = 0;
			this.towerBarrack3.adjustY = -27;
			
//==== SOLDIERS ===========================================================================
			
			this.soldier1 = new GameSettingItem();
			this.soldier1.range = 150;
			this.soldier1.reload = 1 * 30;
			this.soldier1.respawn = 10 * 30;
			this.soldier1.regen = 5;
			this.soldier1.hp = 55;
			this.soldier1.minDamage = 2;
			this.soldier1.maxDamage = 4;
			this.soldier1.armor = 0;
			this.soldier1.dodge = 0;
			this.soldier1.speed = 2.5;
			this.soldier1.adjustX = 0;
			this.soldier1.adjustY = -16;
			
			this.soldier2 = new GameSettingItem();
			this.soldier2.range = 150;
			this.soldier2.reload = 1 * 30;
			this.soldier2.respawn = 11 * 30;
			this.soldier2.regen = 5;
			this.soldier2.hp = 110;
			this.soldier2.minDamage = 3;
			this.soldier2.maxDamage = 7;
			this.soldier2.armor = 0.15;
			this.soldier2.dodge = 0;
			this.soldier2.speed = 2.5;
			this.soldier2.adjustX = 0;
			this.soldier2.adjustY = -16;
			
			this.soldier3 = new GameSettingItem();
			this.soldier3.range = 150;
			this.soldier3.reload = 1 * 30;
			this.soldier3.respawn = 12 * 30;
			this.soldier3.regen = 5;
			this.soldier3.hp = 165;
			this.soldier3.minDamage = 5;
			this.soldier3.maxDamage = 11;
			this.soldier3.armor = 0.3;
			this.soldier3.dodge = 0;
			this.soldier3.speed = 2.5;
			this.soldier3.adjustX = 0;
			this.soldier3.adjustY = -16;
			
//==== SPELLS =============================================================================
			
			this.spellFireball1 = new GameSettingItem();
			this.spellFireball1.name = "Rain of Fire";
			this.spellFireball1.respawn = 75 * 30; // 技能的冷却时间。
			this.spellFireball1.reload = 0.35 * 30; // 两个火球降落的间隔。
			this.spellFireball1.hp = 3; // 火雨的数量。
			this.spellFireball1.minDamage = 25;
			this.spellFireball1.maxDamage = 75;
			this.spellFireball1.range = 80; // 火雨落地距离释放中心的最大误差。
			this.spellFireball1.rangeSplash = 180;
			this.spellFireball1.speed = 4;
			this.spellFireball1.adjustX = 0;
			this.spellFireball1.adjustY = 0;
			
			this.spellReinforcement1 = new GameSettingItem();
			this.spellReinforcement1.name = "Call Reinforcements";
			this.spellReinforcement1.respawn = 15 * 30; // 技能的冷却时间。
			this.spellReinforcement1.range = 120;
			this.spellReinforcement1.reload = 1 * 30;
			this.spellReinforcement1.loseLife = 22 * 30; // 援军从出现到离开的时间。
			this.spellReinforcement1.regen = 5;
			this.spellReinforcement1.hp = 40;
			this.spellReinforcement1.minDamage = 1;
			this.spellReinforcement1.maxDamage = 2;
			this.spellReinforcement1.armor = 0;
			this.spellReinforcement1.dodge = 0;
			this.spellReinforcement1.speed = 2.5;
			this.spellReinforcement1.adjustX = 0;
			this.spellReinforcement1.adjustY = -16;
			
//==== ENEMIES ============================================================================
			
			this.enemySmall = new GameSettingItem();
			this.enemySmall.name = "Swarmling";
			this.enemySmall.hp = 36;
			this.enemySmall.minDamage = 2;
			this.enemySmall.maxDamage = 4;
			this.enemySmall.reload = 1 * 30;
			this.enemySmall.regen = 0;
			this.enemySmall.armor = 0;
			this.enemySmall.magicArmor = 0;
			this.enemySmall.dodge = 0;
			this.enemySmall.speed = 1;
			this.enemySmall.price = 5;
			this.enemySmall.loseLife = 1;
			this.enemySmall.adjustX = 0;
			this.enemySmall.adjustY = -15;
			
			this.enemyMedium = new GameSettingItem();
			this.enemyMedium.name = "Reaver";
			this.enemyMedium.hp = 120;
			this.enemyMedium.minDamage = 5;
			this.enemyMedium.maxDamage = 10;
			this.enemyMedium.reload = 1.2 * 30;
			this.enemyMedium.regen = 0;
			this.enemyMedium.armor = 0.3;
			this.enemyMedium.magicArmor = 0;
			this.enemyMedium.dodge = 0;
			this.enemyMedium.speed = 1;
			this.enemyMedium.price = 15;
			this.enemyMedium.loseLife = 2;
			this.enemyMedium.adjustX = 0;
			this.enemyMedium.adjustY = -22;
			
			this.enemyLarge = new GameSettingItem();
			this.enemyLarge.name = "Giant";
			this.enemyLarge.hp = 380;
			this.enemyLarge.minDamage = 15;
			this.enemyLarge.maxDamage = 25;
			this.enemyLarge.reload = 2 * 30;
			this.enemyLarge.regen = 0;
			this.enemyLarge.armor = 0.1;
			this.enemyLarge.magicArmor = 0;
			this.enemyLarge.dodge = 0;
			this.enemyLarge.speed = 0.5;
			this.enemyLarge.price = 40;
			this.enemyLarge.loseLife = 3;
			this.enemyLarge.adjustX = 0;
			this.enemyLarge.adjustY = -28;
			
			this.enemyRunner = new GameSettingItem();
			this.enemyRunner.name = "Runner";
			this.enemyRunner.hp = 18;
			this.enemyRunner.minDamage = 1;
			this.enemyRunner.maxDamage = 6;
			this.enemyRunner.armor = 0;
			this.enemyRunner.magicArmor = 0.55;
			this.enemyRunner.reload = 1.6 * 30;
			this.enemyRunner.regen = 0;
			this.enemyRunner.dodge = 0.4;
			this.enemyRunner.speed = 2.8;
			this.enemyRunner.price = 5;
			this.enemyRunner.loseLife = 1;
			this.enemyRunner.adjustX = 0;
			this.enemyRunner.adjustY = -12;
			
			this.enemyFlying = new GameSettingItem();
			this.enemyFlying.name = "Flying";
			this.enemyFlying.hp = 30;
			this.enemyFlying.minDamage = 0;
			this.enemyFlying.maxDamage = 0;
			this.enemyFlying.armor = 0;
			this.enemyFlying.magicArmor = 0;
			this.enemyFlying.reload = 0 * 30;
			this.enemyFlying.regen = 0;
			this.enemyFlying.dodge = 0;
			this.enemyFlying.speed = 1.6;
			this.enemyFlying.price = 7;
			this.enemyFlying.loseLife = 1;
			this.enemyFlying.adjustX = 0;
			this.enemyFlying.adjustY = -97;
			
			this.enemyArmored = new GameSettingItem();
			this.enemyArmored.name = "装甲敌人";
			this.enemyArmored.hp = 100;
			this.enemyArmored.minDamage = 3;
			this.enemyArmored.maxDamage = 9;
			this.enemyArmored.armor = 0.7;
			this.enemyArmored.magicArmor = 0;
			this.enemyArmored.reload = 1 * 30;
			this.enemyArmored.regen = 0;
			this.enemyArmored.dodge = 0;
			this.enemyArmored.speed = 0.9;
			this.enemyArmored.price = 30;
			this.enemyArmored.loseLife = 2;
			
			this.enemyGiant = new GameSettingItem();
			this.enemyGiant.name = "巨人";
			this.enemyGiant.hp = 1250;
			this.enemyGiant.armor = 0;
			this.enemyGiant.magicArmor = 0.72;
			this.enemyGiant.dodge = 0;
			this.enemyGiant.speed = 0.15;
			this.enemyGiant.price = 165;
			this.enemyGiant.loseLife = 5;
			
			this.enemyBoss = new GameSettingItem();
			this.enemyBoss.name = "Boss";
			this.enemyBoss.hp = 6666;
			this.enemyBoss.armor = 0;
			this.enemyBoss.magicArmor = 0;
			this.enemyBoss.dodge = 0;
			this.enemyBoss.speed = 0.02;
			this.enemyBoss.price = 1;
			this.enemyBoss.loseLife = 10;
		}
		
		/**
		 * [尚未使用] 从远程加载游戏配置。
		 * 
		 * @param	url - 远程或本地文件的地址。
		 */
		public function loadFile(url:String):void
		{
			throw new Error("暂不支持此功能！！");
		}
		
		/**
		 * 根据类名获取相应的配置。
		 * 
		 * @param	definition - 待获取配置的类名。
		 * @param	level - 该类的等级。
		 */
		public function getSettingsByClass(definition:Class, level:int = 1):GameSettingItem
		{
			switch (definition)
			{
				case TowerArcher: 
					return this[Tower.ARCHER + level];
				
				case TowerBarrack: 
					return this[Tower.BARRACK + level];
				
				case TowerMage: 
					return this[Tower.MAGE + level];
				
				case TowerArtillery: 
					return this[Tower.ARTILLERY + level];
				
				case Soldier: 
					return this["soldier" + level];
				
				case SoldierInfantry: 
					return this.soldier2;
				
				case SoldierKnight: 
					return this.soldier3;
				
				case EnemySmall: 
					return this.enemySmall;
				
				case EnemyMedium: 
					return this.enemyMedium;
				
				case EnemyLarge: 
					return this.enemyLarge;
				
				case EnemyRunner: 
					return this.enemyRunner;
				
				case EnemyFlying: 
					return this.enemyFlying;
				
				case EnemyArmored: 
					return this.enemyArmored;
				
				case EnemyGiant: 
					return this.enemyGiant;
				
				case EnemyBoss: 
					return this.enemyBoss;
				
				case SpellFireball: 
					return this["spellFireball" + level];
				
				case SpellReinforcement: 
					return this["spellReinforcement" + level];
				
				default: 
					throw new Error("不支持的值！");
			}
		}
	
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	EVENT_HANDLERS
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
	
	}

}