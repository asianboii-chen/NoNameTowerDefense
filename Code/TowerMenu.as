/**
 * 2016/1/17 13:03
 *
 * 塔的建筑菜单
 */
package
{
	import com.greensock.easing.Expo;
	import com.greensock.TweenMax;
	import flash.display.MovieClip;
	
	public class TowerMenu extends LevelEntity
	{
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	CONSTRUCTOR
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
		
		/**
		 * 创建新的 TowerMenu 对象。
		 */
		public function TowerMenu()
		{
			super();
			
			this.isActive = false;
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	PROPERTIES
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
		
		/**
		 * 左上方的建筑菜单项。
		 */
		public var itemNW:TowerMenuItem;
		/**
		 * 正上方的建筑菜单项。
		 */
		public var itemN:TowerMenuItem;
		/**
		 * 右上方的建筑菜单项。
		 */
		public var itemNE:TowerMenuItem;
		/**
		 * 正下方的建筑菜单项。
		 */
		public var itemSW:TowerMenuItem;
		
		public var itemSE:TowerMenuItem;
		
		public var itemRallyPoint:TowerMenuRallyPoint;
		/**
		 * 拆除塔的建筑菜单项。
		 */
		public var itemSell:TowerMenuSellItem;
		/**
		 * 所属的塔（Tower）或塔位（TowerHolder）。
		 */
		public var tower:LevelEntity;
		/**
		 * 是否在选择任何一个菜单项之后隐藏该菜单。
		 */
		public var fadeoutAfterSelect:Boolean;
		
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
		 * 淡入菜单。
		 *
		 * @param	tower - 所属的塔（Tower）或塔位（TowerHolder）。
		 * @param	content - 菜单项内容。
		 */
		public function fadein(tower:LevelEntity, content:TowerMenuContent):void
		{
			this.tower = tower;
			
			if (tower is Tower)
			{
				this.x = tower.x + Tower(tower).towerAdjustX;
				this.y = tower.y + Tower(tower).towerAdjustY;
			}
			else
			{
				this.x = tower.x;
				this.y = tower.y - 20;
			}
			
			this.level = tower.level;
			this.level.gui.addChild(this);
			
			this.fadeoutAfterSelect = content.fadeoutAfterSelect;
			
			switch (content.content)
			{
				case TowerMenuContentType.BASIC_TOWER: 
					this.itemNW.visible = true;
					this.itemNW.loadContent(this, content.towers[0], content.prices[0]);
					this.itemNE.visible = true;
					this.itemNE.loadContent(this, content.towers[1], content.prices[1]);
					this.itemSW.visible = true;
					this.itemSW.loadContent(this, content.towers[2], content.prices[2]);
					this.itemSE.visible = true;
					this.itemSE.loadContent(this, content.towers[3], content.prices[3]);
					this.itemN.visible = false;
					this.itemSell.visible = false;
					this.itemRallyPoint.visible = false;
					break;
				
				case TowerMenuContentType.UPGRADED_TOWER: 
					this.itemNW.visible = false;
					this.itemNE.visible = false;
					this.itemN.visible = true;
					this.itemN.loadContent(this, content.towers[0], content.prices[0]);
					this.itemSW.visible = false;
					this.itemSE.visible = false;
					this.itemSell.visible = true;
					this.itemRallyPoint.visible = tower is TowerBarrack;
					this.itemRallyPoint.visible && this.itemRallyPoint.loadContent(this);
					this.itemSell.loadContent(this, content.prices[1]);
					break;
					
				case TowerMenuContentType.ADVANCED_TOWER:
					this.itemNW.visible = true;
					this.itemNW.loadContent(this, content.towers[0], content.prices[0]);
					this.itemN.visible = false;
					this.itemNE.visible = true;
					this.itemNE.loadContent(this, content.towers[1], content.prices[1]);
					this.itemSW.visible = false;
					this.itemSE.visible = false;
					this.itemRallyPoint.visible = tower is TowerBarrack;
					this.itemRallyPoint.visible && this.itemRallyPoint.loadContent(this);
					this.itemSell.loadContent(this, content.prices[1]);
					break;
				
				default: 
					throw new Error("不支持的值！");
			}
			
			TweenMax.from(this, 0.25, {ease: Expo.easeOut, autoAlpha: 0, scaleX: 0, scaleY: 0, onComplete: this.onFadeinComplete});
		}
		
		/**
		 * 淡出菜单。
		 */
		public function fadeout():void
		{
			if (this.tower is Tower)
			{
				if (!(this.tower.hitTestPoint(this.tower.level.mouseX, this.tower.level.mouseY, true) || this.tower.holder.hitTestPoint(this.tower.level.mouseX, this.tower.level.mouseY, true)))
					this.level.pointer || this.tower.removeGlow();
			}
			else
			{
				if (!(this.tower.hitTestPoint(this.tower.level.mouseX, this.tower.level.mouseY, true)))
					this.level.pointer || this.tower.removeGlow();
			}
			
			this.level.towerMenu = null;
			this.isActive = false;
			
			TweenMax.to(this, 0.2, {ease: Expo.easeIn, autoAlpha: 0, scaleX: 0, scaleY: 0, onComplete: this.onFadeoutComplete});
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	FRAME_UPDATER
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
		
		override public function updateFrame():void
		{
			super.updateFrame();
			
			var item:*;
			for (var i:int = 0, n:int = this.numChildren; i < n; i++)
			{
				item = this.getChildAt(i);
				if (item is TowerMenuItem || item is TowerMenuSellItem || item is TowerMenuRallyPoint)
				{
					item.visible && item.updateFrame();
				}
			}
			item = null;
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	EVENT_HANDLERS
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
		
		protected function onFadeinComplete():void
		{
			this.isActive = true;
			
			var item:*;
			for (var i:int = 0, n:int = this.numChildren; i < n; i++)
			{
				item = this.getChildAt(i);
				if (item is TowerMenuItem || item is TowerMenuSellItem || item is TowerMenuRallyPoint)
				{
					item.visible && item.enable();
				}
			}
			item = null;
		}
		
		/**
		 * 淡出完成。
		 */
		protected function onFadeoutComplete():void
		{
			this.destroy();
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	DESTROYER
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
		
		override public function destroy():void
		{
			if (this.tower && this.tower.level)
			{
				if (this.tower is Tower)
				{
					if (!(this.tower.hitTestPoint(this.tower.level.mouseX, this.tower.level.mouseY, true) || this.tower.holder.hitTestPoint(this.tower.level.mouseX, this.tower.level.mouseY, true)))
						this.level.pointer || this.tower.removeGlow();
				}
				else
				{
					if (!(this.tower.hitTestPoint(this.tower.level.mouseX, this.tower.level.mouseY, true)))
						this.level.pointer || this.tower.removeGlow();
				}
			}
			
			this.tower = null;
			
			this.itemNW && this.itemNW.destroy();
			this.itemNW = null;
			this.itemN && this.itemN.destroy();
			this.itemN = null;
			this.itemNE && this.itemNE.destroy();
			this.itemNE = null;
			this.itemSE && this.itemSE.destroy();
			this.itemSE = null;
			this.itemSW && this.itemSW.destroy();
			this.itemSW = null;
			this.itemRallyPoint && this.itemRallyPoint.destroy();
			this.itemRallyPoint = null;
			this.itemSell && this.itemSell.destroy();
			this.itemSell = null;
			
			super.destroy();
		}
	
	}

}