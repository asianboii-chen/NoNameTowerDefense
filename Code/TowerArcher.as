/**
 * 2016/7/2 12:16
 *
 * 箭塔
 */
package
{
	import flash.display.Sprite;
	import org.casalib.math.geom.Ellipse;
	
	public class TowerArcher extends Tower
	{
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	CONSTRUCTOR
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
		
		/**
		 * 创建一个新的 TowerArcher 对象。
		 * 
		 * @param	x - 箭塔的 X 轴位置。
		 * @param	y - 箭塔的 Y 轴位置。
		 * @param	towerLevel - 箭塔的等级。
		 * @param	holder - 箭塔所属的 TowerHolder 对象。
		 * @param	info - 箭塔的信息。
		 * @param	timeLoaded - 箭塔的已加载时间。
		 * @param	costAdded - 箭塔目前的总价值。
		 */
		public function TowerArcher(x:int, y:int, towerLevel:int, holder:TowerHolder, info:GameSettingItem = null, timeLoaded:int = 0, costAdded:int = 0)
		{
			super(x, y, Tower.ARCHER, towerLevel, holder, info, timeLoaded, costAdded);
			
			this.archer1.mouseChildren = false;
			this.archer2.mouseChildren = false;
			this.archer1.mouseEnabled = false;
			this.archer2.mouseEnabled = false;
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	PROPERTIES
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
		
		/**
		 * 左侧的射手。
		 */
		public var archer1:Sprite;
		/**
		 * 右侧的射手。
		 */
		public var archer2:Sprite;
		/**
		 * 箭塔发射的总箭数。
		 */
		public var totalArrows:int;
		
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
		 * [覆盖] 升级此箭塔。
		 *
		 * @param	type - 升级的塔类型。
		 */
		override public function upgradeTower(type:String):void
		{
			var tower:TowerArcher;
			
			if (type == TowerMenuContentType.UPGRADED_TOWER)
			{
				if (this.towerLevel == 1)
					tower = new TowerArcher(this.x, this.y, 2, this.holder, this.game.gameSettings.towerArcher2, this._reloadCounter, this.towerCost);
				else if (this.towerLevel == 2)
					tower = new TowerArcher(this.x, this.y, 3, this.holder, this.game.gameSettings.towerArcher3, this._reloadCounter, this.towerCost);
			}
			
			this.fadeout();
			
			tower = null;
		}
		
		/**
		 * [覆盖] 获取箭塔升级的信息。
		 */
		override public function getUpgradeIntro():Array
		{
			var intro:Array = [];
			
			intro[0] = [this.game.gameSettings["towerArcher" + (this.towerLevel + 1)].name, 6, 7, 0x00BF00, 20, true];
			intro[1] = ["----"];
			intro[2] = [GameStrings.TOWER_ARCHER_UPGRADE_DESCRIPTION, 5, 5, 0xCCCCCC, 15];
			intro[3] = ["----"];
			intro[4] = ["Damage: " + this.game.gameSettings["towerArcher" + (this.towerLevel + 1)].minDamage + "~" + this.game.gameSettings["towerArcher" + (this.towerLevel + 1)].maxDamage + "\nRange: " + GameSettings.getRangeGrade(this.game.gameSettings["towerArcher" + (this.towerLevel + 1)].range) + "\nCooldown: " + GameSettings.getReloadGrade(this.game.gameSettings["towerArcher" + (this.towerLevel + 1)].reload), 4, 4, 0x008800, 12];
			
			return intro;
		}
		
		/**
		 * [覆盖] 该箭塔攻击范围内是否存在攻击目标。
		 */
		override public function hasTarget():Boolean
		{
			var towerRange:Ellipse = new Ellipse(this.x + this.towerAdjustX - this.towerRange * 0.5, this.y + this.towerAdjustY - this.towerRange * 0.7 * 0.5, this.towerRange, this.towerRange * 0.7);
			
			for each (var p:Enemy in this.level.dEnemies)
			{
				if (p.isActive && towerRange.containsPoint(new Node(p.x, p.y)))
					return true;
			}
			
			return false;
		}
		
		/**
		 * [覆盖] 获取该箭塔的优先攻击目标。
		 */
		override public function findTarget():Enemy
		{
			var target:Enemy;
			var towerRange:Ellipse = new Ellipse(this.x + this.towerAdjustX - this.towerRange * 0.5, this.y + this.towerAdjustY - this.towerRange * 0.7 * 0.5, this.towerRange, this.towerRange * 0.7);
			
			for each (var p:Enemy in this.level.dEnemies)
			{
				if (!towerRange.containsPoint(new Node(p.x, p.y)))
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
		 * [覆盖] 生成一个新的弓箭。
		 */
		override public function createBullet():BulletCommon
		{
			var archer:Sprite;
			var enemy:Enemy = this.findTarget();
			
			if (!enemy)
			{
				this.isCharging = false;
				return null;
			}
			
			this.totalArrows++;
			
			archer = this["archer" + ((this.totalArrows & 1) + 1)];
			
			return new Arrow(archer.x + this.x, archer.y + this.y, this, enemy.getArcherTarget(this.towerLevel), enemy);
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
		
		override public function destroy():void
		{
			this.removeChild(this.archer1);
			this.archer1 = null;
			this.removeChild(this.archer2);
			this.archer2 = null;
			
			super.destroy();
		}
	
	}

}