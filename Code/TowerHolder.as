/**
 * 2016/1/17 12:49
 *
 * 塔位
 */
package
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	
	public class TowerHolder extends LevelEntity
	{
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	CONSTRUCTOR
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		/**
		 * 创建新的 TowerHolder 对象。
		 *
		 * @param	x - 塔位的 X 坐标。
		 * @param	y - 塔位的 Y 坐标。
		 */
		public function TowerHolder(x:int, y:int, initialRallyPoint:Node)
		{
			super(x, y);
			
			this.buttonMode = true;
			this.adjustX = 0;
			this.adjustY = -20;
			this.rallyPoint = initialRallyPoint;
			
			this._glowing = new GlowFilter();
			this._glowing.color = 0xFFFF00;
			this._glowing.quality = 15;
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	PROPERTIES
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		public var tower:Tower;
		/**
		 * 塔位的建筑菜单内容。
		 */
		public var towerMenuContent:TowerMenuContent;
		public var rallyPoint:Node;
		public var adjustX:int;
		public var adjustY:int;
		
		/**
		 * 发光滤镜。
		 */
		private var _glowing:GlowFilter;
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	ACCESSORS
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	INITIALIZATION
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		override public function init():void
		{
			super.init();
			
			this.level.addTower(this);
			
			this.towerMenuContent = new TowerMenuContent();
			this.towerMenuContent.content = TowerMenuContentType.BASIC_TOWER;
			
			this.towerMenuContent.towers = [];
			this.towerMenuContent.towers[0] = this.level.towerArcherLevelEnabled > 0 ? TowerType.ARCHER_TOWER : TowerMenuContentType.LOCKED;
			this.towerMenuContent.towers[1] = this.level.towerBarrackLevelEnabled > 0 ? TowerType.BARRACK_TOWER : TowerMenuContentType.LOCKED;
			this.towerMenuContent.towers[2] = this.level.towerMageLevelEnabled > 0 ? TowerType.MAGE_TOWER : TowerMenuContentType.LOCKED;
			this.towerMenuContent.towers[3] = this.level.towerArtilleryLevelEnabled > 0 ? TowerType.ARTILLERY_TOWER : TowerMenuContentType.LOCKED;
			
			this.towerMenuContent.prices = [this.game.gameSettings.towerArcher1.price, this.game.gameSettings.towerBarrack1.price, this.game.gameSettings.towerMage1.price, this.game.gameSettings.towerArtillery1.price];
			
			this.addEventListener(MouseEvent.ROLL_OVER, this.onHolderRollOver, false, 0, true);
			this.addEventListener(MouseEvent.ROLL_OUT, this.onHolderRollOut, false, 0, true);
			this.addEventListener(MouseEvent.CLICK, this.onHolderClick, false, 0, true);
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	METHODS
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		/**
		 * 获取指定类型的塔的范围。
		 *
		 * @param	type - 塔的类型。
		 */
		public function getTowerRange(type:String):int
		{
			switch (type)
			{
				case TowerType.ARCHER_TOWER: 
					return this.game.gameSettings.towerArcher1.range;
				
				case TowerType.ARTILLERY_TOWER: 
					return this.game.gameSettings.towerArtillery1.range;
				
				case TowerType.MAGE_TOWER: 
					return this.game.gameSettings.towerMage1.range;
				
				case TowerType.BARRACK_TOWER: 
					return this.game.gameSettings.towerBarrack1.range;
				
				default: 
					throw new Error("不支持的值！");
			}
		}
		
		/**
		 * 在此塔位上建造塔。
		 *
		 * @param	type - 塔的类型。
		 */
		public function buildTower(type:String):Tower
		{
			this.removeGlow();
			
			switch (type)
			{
				case TowerType.ARCHER_TOWER: 
					return new TowerArcher(this.x, this.y, 1, this, this.game.gameSettings.towerArcher1);
				
				case TowerType.ARTILLERY_TOWER: 
					return new TowerArtillery(this.x, this.y, 1, this, this.game.gameSettings.towerArtillery1);
				
				case TowerType.MAGE_TOWER: 
					return new TowerMage(this.x, this.y, 1, this, this.game.gameSettings.towerMage1);
				
				case TowerType.BARRACK_TOWER: 
					return new TowerBarrack(this.x, this.y, this.rallyPoint, 1, this, this.game.gameSettings.towerBarrack1);
				
				default: 
					throw new Error("不支持的值！");
			}
		}
		
		/**
		 * 添加发光效果。
		 */
		public function addGlow():void
		{
			this.filters = [this._glowing];
		}
		
		/**
		 * 移除发光效果。
		 */
		public function removeGlow():void
		{
			this.filters = [];
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	FRAME_UPDATER
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	EVENT_HANDLERS
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		/**
		 * 鼠标移入。
		 */
		protected function onHolderRollOver(event:MouseEvent):void
		{
			if (this.tower)
			{
				this.tower.onTowerRollOver();
				return;
			}
			
			this.addGlow();
		}
		
		/**
		 * 鼠标移出。
		 */
		protected function onHolderRollOut(event:MouseEvent):void
		{
			if (this.tower)
			{
				this.tower.onTowerRollOut();
				return;
			}
			
			if (this.level.towerMenu && this.level.towerMenu.tower == this)
				return;
			
			this.removeGlow();
		}
		
		/**
		 * 鼠标单击。
		 */
		protected function onHolderClick(event:MouseEvent):void
		{
			if (this.tower)
			{
				this.tower.onTowerClick();
				return;
			}
			
			this.level.hideTowerRange();
			this.level.hideTowerRangeNew();
			this.level.selectedEnemy && this.level.selectedEnemy.level && (this.level.selectedEnemy.selected = false);
			this.level.selectedSoldier && this.level.selectedSoldier.level && (this.level.selectedSoldier.selected = false);
			this.level.levelInfo.showLevelInfo();
			
			if (this.level.towerMenu)
			{
				if (this.level.towerMenu.tower == this)
				{
					this.level.towerMenu.fadeout();
					this.level.towerMenu = null;
					this.addGlow();
					return;
				}
				this.level.towerMenu.destroy();
				this.level.towerMenu = null;
			}
			
			this.addGlow();
			this.level.towerMenu = new TowerMenu();
			this.level.towerMenu.fadein(this, this.towerMenuContent);
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	DESTROYER
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		override public function destroy():void
		{
			this.removeEventListener(MouseEvent.ROLL_OVER, this.onHolderRollOver);
			this.removeEventListener(MouseEvent.ROLL_OUT, this.onHolderRollOut);
			this.removeEventListener(MouseEvent.CLICK, this.onHolderClick);
			
			this.tower = null;
			
			this.filters = [];
			this._glowing = null;
			
			this.level.removeTower(this);
			
			super.destroy();
		}
	
	}

}