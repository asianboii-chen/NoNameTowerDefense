package
{
	import flash.display.Sprite;
	import org.casalib.math.geom.Ellipse;
	
	public class TowerMage extends Tower
	{
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	CONSTRUCTOR
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		public function TowerMage(x:int, y:int, towerLevel:int, holder:TowerHolder, info:GameSettingItem, timeLoaded:int = 0, costAdded:int = 0)
		{
			super(x, y, Tower.MAGE, towerLevel, holder, info, timeLoaded, costAdded);
			
			this._idleTime = (Math.random() * 6 + 7) * 30;
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	PROPERTIES
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		public var wizard:Sprite;
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	ACCESSORS
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	INITIALIZATION
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	METHODS
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		override public function upgradeTower(type:String):void
		{
			var tower:TowerMage;
			
			if (type == TowerMenuContentType.UPGRADED_TOWER)
			{
				if (this.towerLevel == 1)
					tower = new TowerMage(this.x, this.y, 2, this.holder, this.game.gameSettings.towerMage2, this._reloadCounter, this.towerCost);
				if (this.towerLevel == 2)
					tower = new TowerMage(this.x, this.y, 3, this.holder, this.game.gameSettings.towerMage3, this._reloadCounter, this.towerCost);
			}
			
			this.fadeout();
			
			tower = null;
		}
		
		override public function getUpgradeIntro():Array
		{
			var intro:Array = [];
			
			intro[0] = [this.game.gameSettings["towerMage" + (this.towerLevel + 1)].name, 6, 7, 0x00E1E1, 20, true];
			intro[1] = ["----"];
			intro[2] = [GameStrings.TOWER_MAGE_UPGRADE_DESCRIPTION, 5, 5, 0xCCCCCC, 15];
			intro[3] = ["----"];
			intro[4] = ["Damage: " + this.game.gameSettings["towerMage" + (this.towerLevel + 1)].minDamage + "~" + this.game.gameSettings["towerMage" + (this.towerLevel + 1)].maxDamage + "\nRange: " + GameSettings.getRangeGrade(this.game.gameSettings["towerMage" + (this.towerLevel + 1)].range) + "\nCooldown: " + GameSettings.getReloadGrade(this.game.gameSettings["towerMage" + (this.towerLevel + 1)].reload), 4, 4, 0x00A6A6, 12];
			
			return intro;
		}
		
		override public function hasTarget():Boolean
		{
			var towerRange:Ellipse = new Ellipse(this.x + this.towerAdjustX - this.towerRange * 0.5, this.y + this.towerAdjustY - this.towerRange * 0.7 * 0.5, this.towerRange, this.towerRange * 0.7);
			
			for each (var p:Enemy in this.level.dEnemies)
			{
				if (p.isActive && towerRange.containsPoint(new Node(p.x, p.y)))
					return true;
			}
			p = null;
			
			return false;
		}
		
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
		
		override public function createBullet():BulletCommon
		{
			var enemy:Enemy = this.findTarget();
			
			if (enemy.y < this.y)
				this.wizard.scaleX = -1;
			else
				this.wizard.scaleX = 1;
			
			return new Bolt(this.wizard.x - 14 * this.wizard.scaleX + this.x, this.wizard.y - 14 + this.y, this, enemy);
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	FRAME_UPDATER
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		override public function updateIdle():void
		{
			if (this._idleCounter < this._idleTime)
			{
				this._idleCounter++;
				return;
			}
			
			this._idleCounter = 0;
			this.wizard.scaleX *= -1;
			this._idleTime = (Math.random() * 6 + 7) * 30;
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	EVENT_HANDLERS
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	DESTROYER
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		override public function destroy():void
		{
			this.removeChild(this.wizard);
			this.wizard = null;
			
			super.destroy();
		}
	
	}

}