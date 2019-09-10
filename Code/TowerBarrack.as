/**
 * 2016/7/2 12:18
 * 
 * 兵营
 */
package
{
	import flash.events.MouseEvent;
	import org.casalib.math.geom.Ellipse;
	
	public class TowerBarrack extends Tower
	{
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	CONSTRUCTOR
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		/**
		 * 创建新的 TowerBarrack 对象。
		 * 
		 * @param	x - 兵营的 X 轴位置。
		 * @param	y - 兵营的 Y 轴位置。
		 * @param	initialRallyPoint - 兵营的初始士兵集结点位置。
		 * @param	towerLevel - 兵营的等级。
		 * @param	holder - 兵营所属的 TowerHolder 对象。
		 * @param	info - 兵营的信息。
		 * @param	costAdded - 兵营增加的价值。
		 * @param	soldiers - 兵营现有的士兵。
		 */
		public function TowerBarrack(x:int, y:int, initialRallyPoint:Node, towerLevel:int, holder:TowerHolder, info:GameSettingItem, costAdded:int = 0, soldiers:Array = null)
		{
			super(x, y, Tower.BARRACK, towerLevel, holder, info, -1, costAdded);
			
			this.totalSoldiers = 3;
			this.rallyPoint = initialRallyPoint;
			
			this.soldiers = soldiers || [];
			
			this._soldierEllipseWidth = 55;
			
			towerLevel == 1 ? this.fadein() : this.initTower();
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	PROPERTIES
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		/**
		 * 兵营的集结点。
		 */
		public var rallyPoint:Node;
		/**
		 * 兵营中的士兵。
		 */
		public var soldiers:Array;
		/**
		 * 兵营的士兵上限数量。
		 */
		public var totalSoldiers:int;
		
		/**
		 * 兵营士兵站立的椭圆大小。
		 */
		protected var _soldierEllipseWidth:int;
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	ACCESSORS
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	INITIALIZATION
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		override public function initTower():void
		{
			super.initTower();
			
			this.initSoldiers();
		}
		
		/**
		 * 初始化该兵营的士兵。
		 */
		public function initSoldiers():void
		{
			for (var i:int = (this.towerLevel == 1 ? this.soldiers.length : 0); i < this.totalSoldiers; i++)
			{
				switch (this.towerLevel)
				{
					case 1: 
						this.soldiers[i] = new Soldier(this.x, this.y, this, this.getSoldierInfo());
						break;
					
					case 2: 
						this.soldiers[i] = new SoldierInfantry(this.soldiers[i], this, this.getSoldierInfo());
						break;
					
					case 3: 
						this.soldiers[i] = new SoldierKnight(this.soldiers[i], this, this.getSoldierInfo());
				}
			}
			
			if (this.towerLevel == 1)
			{
				this.changeRallyPoint();
				
				for (i = 0; i < this.totalSoldiers; i++)
				{
					this.soldiers[i].isActive = true;
				}
			}
		}
		
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
			var tower:TowerBarrack;
			
			if (this.soldiers.length < this.totalSoldiers)
				this.initSoldiers();
			
			if (type == TowerMenuContentType.UPGRADED_TOWER)
			{
				switch (this.towerLevel)
				{
					case 1: 
						tower = new TowerBarrack(this.x, this.y, this.rallyPoint, 2, this.holder, this.game.gameSettings.towerBarrack2, this.towerCost, this.soldiers);
						break;
					
					case 2: 
						tower = new TowerBarrack(this.x, this.y, this.rallyPoint, 3, this.holder, this.game.gameSettings.towerBarrack3, this.towerCost, this.soldiers);
						break;
				}
			}
			
			this.fadeoutBarrack(false);
			
			tower = null;
		}
		
		/**
		 * 获取兵营士兵的配置。
		 */
		public function getSoldierInfo():GameSettingItem
		{
			return this.game.gameSettings["soldier" + this.towerLevel];
		}
		
		/**
		 * [覆盖] 获取箭塔升级的信息。
		 */
		override public function getUpgradeIntro():Array
		{
			var settings:GameSettingItem = this.game.gameSettings["soldier" + (this.towerLevel + 1)];
			var intro:Array = [];
			
			intro[0] = [this.game.gameSettings["towerBarrack" + (this.towerLevel + 1)].name, 6, 7, 0xE8CB00, 20, true];
			intro[1] = ["----"];
			intro[2] = [GameStrings.TOWER_BARRACK_UPGRADE_DESCRIPTION, 5, 5, 0xCCCCCC, 15];
			intro[3] = ["----"];
			intro[4] = ["Damage: " + settings.minDamage + "~" + settings.maxDamage + "\nHealth: " + settings.hp + "\nArmor: " + GameSettings.getArmorGrade(settings.armor) + "\nRespawn: " + int(settings.respawn * 3.4) / 100 + "s", 4, 4, 0xA4A400, 12];
			
			settings = null;
			
			return intro;
		}
		
		/**
		 * 更改士兵的集结点。
		 * 
		 * @param	rallyPoint - 要更改的士兵的集结点。
		 */
		public function changeRallyPoint(rallyPoint:Node = null):void
		{
			rallyPoint && (this.rallyPoint = rallyPoint);
			
			if (this.totalSoldiers == 1)
			{
				this.soldiers[0].changeRallyPoint(this.rallyPoint);
			}
			else
			{
				var soldierEllipse:Ellipse = new Ellipse(this.rallyPoint.x - this._soldierEllipseWidth * 0.5, this.rallyPoint.y - this._soldierEllipseWidth * 0.7 * 0.5, this._soldierEllipseWidth, this._soldierEllipseWidth * 0.7);
				var soldierAngle:Number = 180;
				
				for each (var p:Soldier in this.soldiers)
				{
					
					p.changeRallyPoint(soldierEllipse.getNodeOfDegree(soldierAngle));
					soldierAngle += 360 / this.totalSoldiers;
				}
				p = null;
				
				soldierEllipse = null;
			}
		}
		
		/**
		 * [覆盖] 高亮此兵营。
		 */
		override public function addGlow():void
		{
			super.addGlow();
			
			for each (var p:Soldier in this.soldiers)
			{
				p.addGlow();
			}
		}
		
		/**
		 * [覆盖] 取消高亮此兵营。
		 */
		override public function removeGlow():void
		{
			super.removeGlow();
			
			for each (var p:Soldier in this.soldiers)
			{
				p.removeGlow();
			}
		}
		
		/**
		 * [覆盖] 淡出此兵营。
		 */
		override public function fadeout():void
		{
			this.fadeoutBarrack();
		}
		
		/**
		 * [覆盖] 淡出此兵营。
		 * 
		 * @param	destroySoldiers - 是否摧毁所有士兵。
		 */
		public function fadeoutBarrack(destroySoldiers:Boolean = true):void
		{
			if (destroySoldiers)
			{
				for each (var p:Soldier in this.soldiers)
				{
					p.destroy();
				}
			}
			
			super.fadeout();
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	FRAME_UPDATER
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	EVENT_HANDLERS
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		/**
		 * 单击兵营。
		 */
		override public function onTowerClick(event:MouseEvent = null):void
		{
			this.level.hideTowerRange();
			this.level.hideTowerRangeNew();
			this.level.selectedEnemy && (this.level.selectedEnemy.selected = false);
			this.level.selectedSoldier && (this.level.selectedSoldier.selected = false);
			
			if (this.level.towerMenu)
			{
				if (this.level.towerMenu.tower == this)
				{
					this.level.towerMenu.fadeout();
					this.level.levelInfo.showLevelInfo();
					this.level.towerMenu = null;
					return;
				}
				this.level.towerMenu.destroy();
				this.level.towerMenu = null;
			}
			
			this.level.towerMenu = new TowerMenu();
			this.level.towerMenu.fadein(this, this.towerMenuContent);
			this.level.levelInfo.showTowerInfo(this);
			
			this.addGlow();
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	DESTROYER
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		override public function destroy():void
		{
			this.soldiers = null;
			
			this.rallyPoint = null;
			
			super.destroy();
		}
	
	}

}