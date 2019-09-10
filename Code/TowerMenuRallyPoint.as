package
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	
	public class TowerMenuRallyPoint extends Sprite
	{
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	CONSTRUCTOR
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
		
		/**
		 * 创建新的 TowerMenuSellItem 对象。
		 */
		public function TowerMenuRallyPoint()
		{
			super();
			
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
		 * 所属的建筑菜单对象。
		 */
		public var menu:TowerMenu;
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
		 * @param	price - 拆除塔可获得的价格。
		 */
		public function loadContent(menu:TowerMenu):void
		{
			this.menu = menu;
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	FRAME_UPDATER
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
		
		public function updateFrame():void
		{
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	EVENT_HANDLERS
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
		
		protected function onItemRollOver(event:MouseEvent = null):void
		{
			if (!this.menu.isActive)
				return;
			
				this.filters = [this._glowing];
			
			this.menu.level.showTowerRange(this.menu.tower.x + this.menu.tower.towerAdjustX, this.menu.tower.y + this.menu.tower.towerAdjustY, this.menu.tower.towerRange);
			this.menu.level.showInfoPanel([[GameStrings.TOWER_RALLY_POINT_TITLE, 5, 6, 0x00EEEE, 20, true], "----", [GameStrings.TOWER_RALLY_POINT_DESCRIPTION, 5, 5, 0xCCCCCC, 15]]);
		}
		
		protected function onItemRollOut(event:MouseEvent):void
		{
			if (!this.menu.isActive)
				return;
			
			this.filters = [];
			
			this.menu.level.hideInfoPanel();
			this.menu.level.hideTowerRange();
		}
		
		protected function onItemClick(event:MouseEvent):void
		{
			if (!this.menu.isActive)
				return;
			
			var barrack:TowerBarrack = TowerBarrack(this.menu.tower);
			
			this.menu.level.showTowerRange(barrack.x + barrack.towerAdjustX, barrack.y + barrack.towerAdjustY, barrack.towerRange);
			
			new MouseRallyPoint(barrack);
			
			this.menu.level.hideTowerRangeNew();
			this.menu.level.hideInfoPanel();
			this.menu.fadeout();
			
			barrack = null;
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	DESTROYER
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
		
		public function destroy():void
		{
			this.removeEventListener(MouseEvent.ROLL_OVER, this.onItemRollOver);
			this.removeEventListener(MouseEvent.ROLL_OUT, this.onItemRollOut);
			this.removeEventListener(MouseEvent.CLICK, this.onItemClick);
			
			this.filters = [];
			this._glowing = null;
			
			this.parent.removeChild(this);
		}
	
	}

}