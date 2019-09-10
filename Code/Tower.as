/**
 * 2016/7/2 12:13
 *
 * [抽象基类] 塔
 */
package
{
	import com.greensock.easing.Bounce;
	import com.greensock.TweenMax;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	
	public class Tower extends LevelEntity
	{
		
		/**
		 * 箭塔。
		 */
		static public const ARCHER:String = "towerArcher";
		/**
		 * 兵营。
		 */
		static public const BARRACK:String = "towerBarrack";
		/**
		 * 魔法塔。
		 */
		static public const MAGE:String = "towerMage";
		/**
		 * 炮塔。
		 */
		static public const ARTILLERY:String = "towerArtillery";
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	CONSTRUCTOR
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		/**
		 * [抽象基类] Tower 类是抽象基类，实例化该类可能会出现异常。
		 *
		 * @param	x - 塔所在的 X 轴位置。
		 * @param	y - 塔所在的 Y 轴位置。
		 * @param	towerType - 塔的类型。
		 * @param	towerLevel - 塔的等级。
		 * @param	holder - 塔所属的底座 TowerHolder 对象。
		 * @param	info - 塔的信息。
		 * @param	timeLoaded - 塔已经冷却的时间。
		 * @param	costAdded - 塔目前的总价格。
		 * @param	advancedTowers - [尚未使用] 塔可以升级到的磚家塔。
		 */
		public function Tower(x:int, y:int, towerType:String, towerLevel:int, holder:TowerHolder, info:GameSettingItem, timeLoaded:int = 0, costAdded:int = 0, advancedTowers:Array = null)
		{
			
			this._glowing = new GlowFilter();
			this._glowing.color = 0xFFFF00;
			this._glowing.quality = 15;
			
			this._reloadCounter = timeLoaded;
			
			this.holder = holder;
			this.holder.tower = this;
			this.towerAdvanceds = advancedTowers;
			this.towerLevel = towerLevel;
			this.towerPrice = info.price;
			this.towerName = info.name;
			this.towerType = towerType;
			this.towerRange = info.range;
			this.towerReload = info.reload;
			this.towerMinDamage = info.minDamage;
			this.towerMaxDamage = info.maxDamage;
			this.towerAdjustX = info.adjustX;
			this.towerAdjustY = info.adjustY;
			
			this.towerCost = costAdded + this.towerPrice;
			
			super(x, y, holder.level.entities);
			
			this.buttonMode = true;
			this.gotoAndStop(this.towerLevel);
			
			if (!(this is TowerBarrack))
				this.towerLevel == 1 ? this.fadein() : this.initTower();
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	PROPERTIES
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		/**
		 * 所属的塔位。
		 */
		public var holder:TowerHolder;
		/**
		 * 塔的建筑菜单内容。
		 */
		public var towerMenuContent:TowerMenuContent;
		/**
		 * 塔可升级到的磚家塔。
		 */
		public var towerAdvanceds:Array;
		/**
		 * 塔的名字。
		 */
		public var towerName:String;
		/**
		 * 塔的类型。
		 */
		public var towerType:String;
		/**
		 * 塔的当前等级。
		 */
		public var towerLevel:int;
		/**
		 * 塔的价格。
		 */
		public var towerPrice:int;
		/**
		 * 塔目前的总价格。
		 */
		public var towerCost:int;
		/**
		 * 塔的攻击范围。
		 */
		public var towerRange:int;
		/**
		 * 塔的攻击冷却时间。
		 */
		public var towerReload:int;
		/**
		 * 塔攻击时造成的最小伤害。
		 */
		public var towerMinDamage:int;
		/**
		 * 塔攻击时造成的最大伤害。
		 */
		public var towerMaxDamage:int;
		/**
		 * 塔的 X 坐标校准。
		 */
		public var towerAdjustX:int;
		/**
		 * 塔的 Y 坐标校准。
		 */
		public var towerAdjustY:int;
		/**
		 * 升级塔可获得的范围（增多部分）。
		 */
		public var upgradeRangeExtra:int;
		/**
		 * 塔是否处于冷却状态。
		 */
		public var isCharging:Boolean;
		
		/**
		 * 发光滤镜。
		 */
		protected var _glowing:GlowFilter;
		/**
		 * 塔的冷却计时器。
		 */
		protected var _reloadCounter:int;
		/**
		 * 塔的空闲时间。
		 */
		protected var _idleTime:int;
		/**
		 * 塔的空闲计时器。
		 */
		protected var _idleCounter:int;
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	ACCESSORS
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	INITIALIZATION
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		override public function init():void
		{
			super.init();
			
			this.isCharging = true;
			
			this.level.addTower(this);
			
			this.initTowerMenuContent();
			
			this.addEventListener(MouseEvent.ROLL_OVER, this.onTowerRollOver, false, 0, true);
			this.addEventListener(MouseEvent.ROLL_OUT, this.onTowerRollOut, false, 0, true);
			this.addEventListener(MouseEvent.CLICK, this.onTowerClick, false, 0, true);
		}
		
		public function initTower():void
		{
		}
		
		/**
		 * 初始化塔的建筑菜单选项。
		 */
		public function initTowerMenuContent():void
		{
			var upgradeInfo:GameSettingItem;
			var upgradePrice:int;
			var upgradeRangeExtra:int;
			var menu:TowerMenuContent = new TowerMenuContent();
			
			if (this.towerLevel < 3)
			{
				if (level.game.gameSettings.hasOwnProperty(this.towerType + (towerLevel + 1)))
				{
					upgradeInfo = GameSettingItem(level.game.gameSettings[this.towerType + (towerLevel + 1)]);
					upgradePrice = upgradeInfo.price;
					upgradeRangeExtra = upgradeInfo.rangeExtra;
				}
				else
				{
					upgradePrice = -1;
					upgradeRangeExtra = -1;
				}
			}
			else
			{
				///////////////////////////////////////////////////
				upgradePrice = -1;
				upgradeRangeExtra = -1;
			}
			
			menu.content = this.towerLevel < 3 ? TowerMenuContentType.UPGRADED_TOWER : TowerMenuContentType.ADVANCED_TOWER;
			menu.prices = [upgradePrice, this.towerCost * 0.75];
			
			if (this.towerLevel < 3)
			{
				menu.towers = [level[this.towerType + "LevelEnabled"] > towerLevel ? TowerMenuContentType.UPGRADED_TOWER : TowerMenuContentType.LOCKED];
			}
			else
			{
				if (level[this.towerType + "LevelEnabled"] == 3)
					menu.towers = [TowerMenuContentType.LOCKED, TowerMenuContentType.LOCKED];
				else if (level[this.towerType + "LevelEnabled"] == 4)
					menu.towers = [TowerMenuContentType.ADVANCED_TOWER, TowerMenuContentType.LOCKED];
				else
					menu.towers = [TowerMenuContentType.ADVANCED_TOWER, TowerMenuContentType.ADVANCED_TOWER];
			}
			
			this.towerMenuContent = menu;
			this.upgradeRangeExtra = upgradeRangeExtra;
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	METHODS
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		/**
		 * 升级此塔。
		 *
		 * @param	type - 要升级的塔的类型。
		 */
		public function upgradeTower(type:String):void
		{
		}
		
		/**
		 * 拆除此塔。
		 */
		public function sellTower():void
		{
			this.holder.tower = null;
			this.fadeout();
		}
		
		/**
		 * 获取塔的升级信息。
		 */
		public function getUpgradeIntro():Array
		{
			return ["----"];
		}
		
		/**
		 * 生成一个新的子弹。
		 */
		public function createBullet():BulletCommon
		{
			return null;
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
		
		/**
		 * 该塔的攻击范围内是否有目标。
		 */
		public function hasTarget():Boolean
		{
			return false;
		}
		
		/**
		 * 获取该塔的优先攻击目标。
		 */
		public function findTarget():Enemy
		{
			return null;
		}
		
		/**
		 * 淡入此塔。
		 */
		public function fadein():void
		{
			TweenMax.from(this, 0.75, {ease: Bounce.easeOut, y: "-30", autoAlpha: 0, onUpdate: this.onFadeinUpdate, onComplete: this.onFadeinComplete});
		}
		
		/**
		 * 淡出此塔。
		 */
		public function fadeout():void
		{
			this.isActive = false;
			
			this.removeEventListener(MouseEvent.ROLL_OVER, this.onTowerRollOver);
			this.removeEventListener(MouseEvent.ROLL_OUT, this.onTowerRollOut);
			this.removeEventListener(MouseEvent.CLICK, this.onTowerClick);
			
			TweenMax.to(this, 0.5, {y: "-30", autoAlpha: 0, onComplete: this.onFadeoutComplete});
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	FRAME_UPDATER
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		override public function updateFrame():void
		{
			if (!this.isActive)
				return;
			
			if (this.isCharging && this._reloadCounter < this.towerReload)
			{
				this._reloadCounter++;
				return;
			}
			
			if (!this.hasTarget())
			{
				this.isCharging = false;
				
				this._idleTime > 0 && this.updateIdle();
				
				return;
			}
			
			this.isCharging = true;
			this._reloadCounter = 0;
			
			this.createBullet();
		}
		
		public function updateIdle():void
		{
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	EVENT_HANDLERS
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		/**
		 * 鼠标移入。
		 */
		public function onTowerRollOver(event:MouseEvent = null):void
		{
			this.addGlow();
		}
		
		/**
		 * 鼠标移出。
		 */
		public function onTowerRollOut(event:MouseEvent = null):void
		{
			if (this.level.towerMenu && this.level.towerMenu.tower == this)
				return;
			
			this.removeGlow();
		}
		
		/**
		 * 鼠标单击。
		 */
		public function onTowerClick(event:MouseEvent = null):void
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
			this.level.showTowerRange(this.x + this.towerAdjustX, this.y + this.towerAdjustY, this.towerRange);
			
			this.addGlow();
		}
		
		/**
		 * 塔淡入完成。
		 */
		protected function onFadeinComplete():void
		{
			this.initTower();
		}
		
		/**
		 * 塔淡入更新。
		 */
		protected function onFadeinUpdate():void
		{
			if (this.level.towerMenu && this.level.towerMenu.tower == this)
				this.level.towerRange.y = this.y + this.towerAdjustY;
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
			this.removeEventListener(MouseEvent.ROLL_OVER, this.onTowerRollOver);
			this.removeEventListener(MouseEvent.ROLL_OUT, this.onTowerRollOut);
			this.removeEventListener(MouseEvent.CLICK, this.onTowerClick);
			
			this.filters = [];
			this._glowing = null;
			
			this.towerMenuContent = null;
			
			this.level.removeTower(this);
			
			super.destroy();
		}
	
	}

}