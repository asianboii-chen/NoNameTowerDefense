/**
 * 2016/1/17 13:19
 *
 * 建筑菜单中的一个项目
 */
package
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.utils.getQualifiedClassName;
	
	public class TowerMenuItem extends MovieClip
	{
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	CONSTRUCTOR
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
		
		/**
		 * 创建新的 TowerMenuItem 对象。
		 */
		public function TowerMenuItem()
		{
			super();
			
			this.priceText.mouseEnabled = false;
			
			this._glowing = new GlowFilter();
			this._glowing.quality = 10;
			this._glowing.blurX = this._glowing.blurY = 3;
			this._glowing.color = 0xFFFF00;
			
			this.buttonMode = true;
			
			this.addEventListener(MouseEvent.ROLL_OVER, this.onItemRollOver, false, 0, true);
			this.addEventListener(MouseEvent.ROLL_OUT, this.onItemRollOut, false, 0, true);
			this.addEventListener(MouseEvent.CLICK, this.onItemClick, false, 0, true);
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	PROPERTIES
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
		
		/**
		 * 显示价格的文本框。
		 */
		public var priceText:TextField;
		/**
		 * 所属的建筑菜单。
		 */
		public var menu:TowerMenu;
		/**
		 * 项目的作用。
		 */
		public var selection:String;
		/**
		 * 项目的价格。
		 */
		public var price:int;
		
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
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	METHODS
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
		
		public function enable():void
		{
			if (this.hitTestPoint(this.menu.level.mouseX, this.menu.level.mouseY, true))
				this.onItemRollOver();
		}
		
		/**
		 * 加载显示信息。
		 *
		 * @param	menu - 所属的建筑菜单。
		 * @param	content - 项目的作用。
		 * @param	price - 项目的价格。
		 */
		public function loadContent(menu:TowerMenu, content:String = null, price:int = 0):void
		{
			if (price < 0 && content != TowerMenuContentType.LOCKED)
			{
				this.visible = false;
				return;
			}
			
			this.menu = menu;
			this.selection = content;
			
			if (content != TowerMenuContentType.ADVANCED_TOWER)
				this.gotoAndStop(content);
			
			if (content == TowerMenuContentType.LOCKED)
			{
				return;
			}
			else if (content == TowerMenuContentType.ADVANCED_TOWER)
			{
				switch (getQualifiedClassName(menu.tower))
				{
					default: 
						this.gotoAndStop(TowerMenuContentType.UPGRADED_TOWER);
				}
			}
			
			this.price = price;
			this.priceText.text = "" + price;
			this.priceText.mouseEnabled = false;
		}
		
		public function updatePrice():void
		{
			if (this.menu.level.cash < this.price)
			{
				if (this.alpha == 1)
					this.alpha = 0.75;
			}
			else
			{
				if (this.alpha < 1)
				{
					this.alpha = 1;
					
					this.hitTestPoint(this.menu.level.mouseX, this.menu.level.mouseY, true) && (this.filters = [this._glowing]);
				}
			}
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	FRAME_UPDATER
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
		
		public function updateFrame():void
		{
			if (this.selection == TowerMenuContentType.LOCKED)
			{
				this.alpha == 1 && (this.alpha = 0.75);
				return;
			}
			
			this.updatePrice();
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	EVENT_HANDLERS
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
		
		protected function onItemRollOver(event:MouseEvent = null):void
		{
			if (!this.menu.isActive)
				return;
			
			if (this.alpha == 1)
				this.filters = [this._glowing];
			
			if (this.selection == TowerMenuContentType.LOCKED)
			{
				this.menu.level.showInfoPanel([[GameStrings.TOWER_LOCKED_TITLE, 5, 6, 0xCCCCCC, 20, true], "----", [GameStrings.TOWER_LOCKED_DESCRIPTION, 5, 5, 0xBBBBBB, 13]]);
				return;
			}
			
			if (this.menu.tower is Tower)
			{
				this.menu.tower is TowerBarrack || this.menu.level.showTowerRangeNew(this.menu.tower.x + this.menu.tower.towerAdjustX, this.menu.tower.y + this.menu.tower.towerAdjustY, this.menu.tower.towerRange + this.menu.tower.upgradeRangeExtra);
				
				this.menu.level.showInfoPanel(this.menu.tower.getUpgradeIntro());
			}
			else if (this.menu.tower is TowerHolder)
			{
				this.menu.level.showTowerRangeNew(this.menu.tower.x + this.menu.tower.adjustX, this.menu.tower.y + this.menu.tower.adjustY, this.menu.tower.getTowerRange(this.selection));
				
				switch (this.selection)
				{
					case TowerType.ARCHER_TOWER: 
						this.menu.level.showInfoPanel([[this.menu.game.gameSettings.towerArcher1.name, 6, 7, 0x00BF00, 20, true], "----", [GameStrings.TOWER_ARCHER_DESCRIPTION, 5, 5, 0xCCCCCC, 15], "----", ["Damage: " + this.menu.game.gameSettings.towerArcher1.minDamage + "~" + this.menu.game.gameSettings.towerArcher1.maxDamage + "\nRange: " + GameSettings.getRangeGrade(this.menu.game.gameSettings.towerArcher1.range) + "\nCooldown: " + GameSettings.getReloadGrade(this.menu.game.gameSettings.towerArcher1.reload), 4, 4, 0x008800, 12]]);
						break;
					
					case TowerType.ARTILLERY_TOWER: 
						this.menu.level.showInfoPanel([[this.menu.game.gameSettings.towerArtillery1.name, 6, 7, 0xFD3D0D, 20, true], "----", [GameStrings.TOWER_ARTILLERY_DESCRIPTION, 5, 5, 0xCCCCCC, 15], "----", ["Damage: " + this.menu.game.gameSettings.towerArtillery1.minDamage + "~" + this.menu.game.gameSettings.towerArtillery1.maxDamage + "\nRange: " + GameSettings.getRangeGrade(this.menu.game.gameSettings.towerArtillery1.range) + "\nCooldown: " + GameSettings.getReloadGrade(this.menu.game.gameSettings.towerArtillery1.reload), 4, 4, 0xC60000, 12]]);
						break;
					
					case TowerType.MAGE_TOWER: 
						this.menu.level.showInfoPanel([[this.menu.game.gameSettings.towerMage1.name, 6, 7, 0x00E1E1, 20, true], "----", [GameStrings.TOWER_MAGE_DESCRIPTION, 5, 5, 0xCCCCCC, 15], "----", ["Damage: " + this.menu.game.gameSettings.towerMage1.minDamage + "~" + this.menu.game.gameSettings.towerMage1.maxDamage + "\nRange: " + GameSettings.getRangeGrade(this.menu.game.gameSettings.towerMage1.range) + "\nCooldown: " + GameSettings.getReloadGrade(this.menu.game.gameSettings.towerMage1.reload), 4, 4, 0x00A6A6, 12]]);
						break;
					
					case TowerType.BARRACK_TOWER: 
						this.menu.level.showInfoPanel([[this.menu.game.gameSettings.towerBarrack1.name, 6, 7, 0xE8CB00, 20, true], "----", [GameStrings.TOWER_BARRACK_DESCRIPTION, 5, 5, 0xCCCCCC, 15], "----", ["Damage: " + this.menu.game.gameSettings.soldier1.minDamage + "~" + this.menu.game.gameSettings.soldier1.maxDamage + "\nHealth: " + this.menu.game.gameSettings.soldier1.hp + "\nArmor Level: " + GameSettings.getArmorGrade(this.menu.game.gameSettings.soldier1.armor) + "\nRespawn: " + int(this.menu.game.gameSettings.soldier1.respawn * 3.4) / 100 + "s", 4, 4, 0xA4A400, 12]]);
						break;
					
					default: 
						throw new Error("不支持的值！");
				}
				
			}
		}
		
		protected function onItemRollOut(event:MouseEvent):void
		{
			if (!this.menu.isActive)
				return;
			
			this.filters = [];
			this.menu.level.hideTowerRangeNew();
			this.menu.level.hideInfoPanel();
		}
		
		protected function onItemClick(event:MouseEvent):void
		{
			if (!this.menu.isActive)
				return;
			
			if (this.alpha < 1)
				return;
			
			if (this.menu.tower is TowerHolder)
				TowerHolder(this.menu.tower).buildTower(this.selection);
			else if (this.menu.tower is Tower)
				Tower(this.menu.tower).upgradeTower(this.selection);
			
			if (this.menu.fadeoutAfterSelect)
			{
				this.menu.level.hideTowerRange();
				this.menu.level.hideTowerRangeNew();
				this.menu.level.hideInfoPanel();
				this.menu.level.updateCash(-this.price);
				this.menu.level.levelInfo.showLevelInfo();
				this.menu.fadeout();
				this.removeEventListener(MouseEvent.ROLL_OVER, this.onItemRollOver);
				this.removeEventListener(MouseEvent.ROLL_OUT, this.onItemRollOut);
				this.removeEventListener(MouseEvent.CLICK, this.onItemClick);
			}
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	DESTROYER
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
		
		public function destroy():void
		{
			this.stop();
			
			this.removeEventListener(MouseEvent.ROLL_OVER, this.onItemRollOver);
			this.removeEventListener(MouseEvent.ROLL_OUT, this.onItemRollOut);
			this.removeEventListener(MouseEvent.CLICK, this.onItemClick);
			
			this.filters = [];
			this._glowing = null;
			
			this.parent.removeChild(this);
		}
	
	}

}