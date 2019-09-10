/**
 * 2016/7/2 12:16
 *
 * 炮塔
 */
package
{
	import org.casalib.math.geom.Ellipse;
	
	public class TowerArtillery extends Tower
	{
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	CONSTRUCTOR
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
		
		/**
		 * 创建一个新的 TowerArtillery 对象。
		 * 
		 * @param	x - 炮塔的 X 轴位置。
		 * @param	y - 炮塔的 Y 轴位置。
		 * @param	towerLevel - 炮塔的等级。
		 * @param	holder - 炮塔所属的 TowerHolder 对象。
		 * @param	info - 炮塔的信息。
		 * @param	timeLoaded - 炮塔的已加载时间。
		 * @param	costAdded - 炮塔目前的总价值。
		 */
		public function TowerArtillery(x:int, y:int, towerLevel:int, holder:TowerHolder, info:GameSettingItem, timeLoaded:int = 0, costAdded:int = 0)
		{
			super(x, y, Tower.ARTILLERY, towerLevel, holder, info, timeLoaded, costAdded);
			
			this.towerRangeSplash = info.rangeSplash;
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	PROPERTIES
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
		
		/**
		 * 炮塔炮弹爆炸的溅射范围。
		 */
		public var towerRangeSplash:int;
		
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
		 * [覆盖] 升级此炮塔。
		 *
		 * @param	type - 升级的塔类型。
		 */
		override public function upgradeTower(type:String):void
		{
			var tower:TowerArtillery;
			
			if (type == TowerMenuContentType.UPGRADED_TOWER)
			{
				if (this.towerLevel == 1)
					tower = new TowerArtillery(this.x, this.y, 2, this.holder, this.game.gameSettings.towerArtillery2, this._reloadCounter, this.towerCost);
				if (this.towerLevel == 2)
					tower = new TowerArtillery(this.x, this.y, 3, this.holder, this.game.gameSettings.towerArtillery3, this._reloadCounter, this.towerCost);
			}
			
			this.fadeout();
			
			tower = null;
		}
		
		/**
		 * [覆盖] 获取炮塔升级的信息。
		 */
		override public function getUpgradeIntro():Array
		{
			var intro:Array = [];
			
			intro[0] = [this.game.gameSettings["towerArtillery" + (this.towerLevel + 1)].name, 6, 7, 0xFD3D0D, 20, true];
			intro[1] = ["----"];
			intro[2] = [GameStrings.TOWER_ARTILLERY_UPGRADE_DESCRIPTION, 5, 5, 0xCCCCCC, 15];
			intro[3] = ["----"];
			intro[4] = ["Damage: " + this.game.gameSettings["towerArtillery" + (this.towerLevel + 1)].minDamage + "~" + this.game.gameSettings["towerArtillery" + (this.towerLevel + 1)].maxDamage + "\nRange: " + GameSettings.getRangeGrade(this.game.gameSettings["towerArtillery" + (this.towerLevel + 1)].range) + "\nCooldown: " + GameSettings.getReloadGrade(this.game.gameSettings["towerArtillery" + (this.towerLevel + 1)].reload), 4, 4, 0xC60000, 12];
			
			return intro;
		}
		
		/**
		 * [覆盖] 该炮塔攻击范围内是否存在攻击目标。
		 */
		override public function hasTarget():Boolean
		{
			var towerRange:Ellipse = new Ellipse(this.x + this.towerAdjustX - this.towerRange * 0.5, this.y + this.towerAdjustY - this.towerRange * 0.7 * 0.5, this.towerRange, this.towerRange * 0.7);
			
			for each (var p:Enemy in this.level.dEnemies)
			{
				if (p.enemyMaxDamage == 0)
					continue;
				
				if (p.isActive && towerRange.containsPoint(p.getArtilleryTarget()))
					return true;
			}
			p = null;
			
			return false;
		}
		
		/**
		 * [覆盖] 获取该炮塔的优先攻击目标。
		 */
		override public function findTarget():Enemy
		{
			var target:Enemy;
			var towerRange:Ellipse = new Ellipse(this.x + this.towerAdjustX - this.towerRange * 0.5, this.y + this.towerAdjustY - this.towerRange * 0.7 * 0.5, this.towerRange, this.towerRange * 0.7);
			
			for each (var p:Enemy in this.level.dEnemies)
			{
				if (!towerRange.containsPoint(p.getArtilleryTarget()) || p.enemyMaxDamage == 0)
					continue;
				
				if (p.isActive)
					if (!target || p.totalNodes - p.currentNodeIndex < target.totalNodes - target.currentNodeIndex)
						target = p;
			}
			p = null;
			
			towerRange = null;
			
			return target;
		}
		
		/**
		 * [覆盖] 生成一个新的炮弹。
		 */
		override public function createBullet():BulletCommon
		{
			switch (this.towerLevel)
			{
				case 1: 
					return new Bomb(this.x, this.y - 55, this, this.findTarget().getArtilleryTarget());
				
				case 2: 
					return new BombBanger(this.x, this.y - 68, this, this.findTarget().getArtilleryTarget());
				
				case 3: 
					return new BombHowitzer(this.x, this.y - 84, this, this.findTarget().getArtilleryTarget());
			}
			
			return null;
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