/**
 * 2016/6/27 18:59
 *
 * [抽象基类] 敌人
 * （所有敌人的基类）
 */
package
{
	import com.greensock.TweenMax;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	
	public class Enemy extends LevelEntity
	{
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	CONSTRUCTOR
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		/**
		 * [抽象基类] Enemy 类是抽象基类，实例化该类可能会出现异常。
		 *
		 * @param	path - 敌人的行走路径。
		 * @param	info - 敌人的信息。它能提供生命值、装甲等属性。
		 * @param	parent - 要将敌人显示在哪一个对象上。
		 */
		public function Enemy(path:Array, info:GameSettingItem, parent:Sprite = null)
		{
			var x0:int = path[0].x;
			var y0:int = path[0].y;
			
			super(x0, y0, parent);
			
			this.buttonMode = true;
			this.path = path;
			
			for (var i:int = this.path.length - 1; i >= 0; i--)
			{
				if (Node(this.path[i]).isEnd)
				{
					this.totalNodes = i + 1;
					break;
				}
			}
			i == 0 && (this.totalNodes = this.path.length - 5);
			
			this.isActive = false;
			
			this.enemyName = info.name;
			this.enemySpeed = info.speed;
			this.enemyArmor = info.armor;
			this.enemyMagicArmor = info.magicArmor;
			this.enemyMinDamage = info.minDamage;
			this.enemyMaxDamage = info.maxDamage;
			this.enemyDodge = info.dodge;
			this.enemyReload = info.reload;
			this.enemyPrice = info.price;
			this.enemyLoseLife = info.loseLife;
			this.enemyHP = this.enemyMaxHP = info.hp;
			this.enemyAdjustX = info.adjustX;
			this.enemyAdjustY = info.adjustY;
			
			this.hpBar = new HPBar(this);
			
			this._glowing = new GlowFilter();
			this._glowing.color = 0xFFFF00;
			this._glowing.quality = 15;
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	PROPERTIES
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		/**
		 * 当前正在和敌人战斗的士兵。
		 */
		public var soldier:Soldier;
		/**
		 * 敌人的生命条 HPBar 对象。
		 */
		public var hpBar:HPBar;
		/**
		 * 敌人的移动路径。
		 */
		public var path:Array;
		/**
		 * 当前正在和敌人战斗位置（敌人两侧）的士兵数量。
		 */
		public var fighters:Array;
		/**
		 * 敌人的名字。
		 */
		public var enemyName:String;
		/**
		 * 敌人的移动速度。
		 */
		public var enemySpeed:Number;
		/**
		 * 敌人的 X 轴移动速度。
		 */
		public var enemySpeedX:Number;
		/**
		 * 敌人的 Y 轴移动速度。
		 */
		public var enemySpeedY:Number;
		/**
		 * 敌人的行进方向（度）。
		 */
		public var enemyWalkingDirection:Number;
		/**
		 * 敌人的装甲。取值范围为 0 （接受所有物理伤害） 至 1 （完全抵抗物理伤害）。
		 */
		public var enemyArmor:Number;
		/**
		 * 敌人的魔法抗性。取值范围为 0 （接受所有魔法伤害）至 1 （完全抵抗魔法伤害）。
		 */
		public var enemyMagicArmor:Number;
		/**
		 * 敌人的闪避几率。取值范围为0至1。
		 */
		public var enemyDodge:Number;
		/**
		 * 敌人的当前生命值。
		 */
		public var enemyHP:int;
		/**
		 * 敌人的最大生命值。
		 */
		public var enemyMaxHP:int;
		/**
		 * 敌人攻击造成的最小伤害。
		 */
		public var enemyMinDamage:int;
		/**
		 * 敌人攻击造成的最大伤害。
		 */
		public var enemyMaxDamage:int;
		/**
		 * 敌人两次攻击之间的间隔（30 为一秒）。
		 */
		public var enemyReload:int;
		/**
		 * 杀死敌人后可获得的奖励。
		 */
		public var enemyPrice:int;
		/**
		 * 敌人逃跑后造成的代价。
		 */
		public var enemyLoseLife:int;
		/**
		 * 敌人目标位置 X 轴校准。该校准为塔能打到的（瞄准的）目标中心。
		 */
		public var enemyAdjustX:int;
		/**
		 * 敌人目标位置 Y 轴校准。该校准为塔能打到的（瞄准的）目标中心。
		 */
		public var enemyAdjustY:int;
		/**
		 * 敌人当前所处的路径节点索引。
		 */
		public var currentNodeIndex:int;
		/**
		 * 敌人的路径共有多少个节点。
		 */
		public var totalNodes:int;
		/**
		 * 敌人当前是否已被士兵阻挡。
		 */
		public var isBlocked:Boolean;
		/**
		 * 敌人当前是否正在战斗。
		 */
		public var isFighting:Boolean;
		/**
		 * 敌人当前是否正在攻击。
		 */
		public var isAttacking:Boolean;
		/**
		 * 发光滤镜。
		 */
		protected var _glowing:GlowFilter;
		
		/**
		 * 敌人两次攻击的间隔的计时器。
		 */
		protected var _reloadCounter:int;
		/**
		 * 敌人的进攻时间。
		 */
		protected var _attackTime:int;
		/**
		 * 敌人的进攻时间计时器。
		 */
		protected var _attackCounter:int;
		/**
		 * 敌人是否被选中。
		 */
		protected var _selected:Boolean;
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	ACCESSORS
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		/**
		 * [只读] 获取当前敌人所处的节点。
		 */
		public function get currentNode():Node
		{
			return this.path[this.currentNodeIndex];
		}
		
		/**
		 * [只读] 获取敌人已经过的路程的百分比。
		 */
		public function get passed():Number
		{
			return this.currentNodeIndex / this.totalNodes;
		}
		
		/**
		 * 获取或设置敌人当前是否被选中。
		 */
		public function get selected():Boolean
		{
			return this._selected;
		}
		
		public function set selected(value:Boolean):void
		{
			if (!this.level)
				return;
			
			if (!this.isActive)
				value = false;
			
			this._selected = value;
			
			if (value)
			{
				this.addGlow();
				this.level.levelInfo.showEnemyInfo(this);
			}
			else
			{
				this.removeGlow();
				this.level.selectedEnemy || this.level.levelInfo.showingMode == LevelInfo.SHOW_ENEMY_INFO || this.level.levelInfo.showLevelInfo();
				this.level.selectedEnemy = null;
			}
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	INITIALIZATION
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		override public function init():void
		{
			super.init();
			
			this.fighters = [];
			this.fighters[FightingPosition.LEFT_SIDE] = 0;
			this.fighters[FightingPosition.RIGHT_SIDE] = 0;
			
			this.level.addEnemy(this);
			this.level.updateEnemyOnStage(1);
			
			this.addEventListener(MouseEvent.CLICK, this.onEnemyClick, false, 0, true);
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	METHODS
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		/**
		 * 为该敌人添加发光滤镜。
		 */
		public function addGlow():void
		{
			this.filters = [this._glowing];
		}
		
		/**
		 * 取消该敌人的发光滤镜。
		 */
		public function removeGlow():void
		{
			this.filters = [];
		}
		
		/**
		 * 水平翻转敌人。
		 * 
		 * @param	scaleX - 设置为 -1 为水平翻转，1 为恢复，0 为当前基础上水平翻转。
		 */
		public function flip(scaleX:int):void
		{
			this.scaleX = this.hpBar.scaleX = scaleX;
		}
		
		/**
		 * 获取一个炮塔的目标位置。该位置表示当炮塔瞄准该敌人进行发射时，
		 * 会以哪里作为炮弹的目标位置。
		 */
		public function getArtilleryTarget():Node
		{
			if (this.isBlocked)
				return new Node(this.x, this.y);
			
			var targetNodeIndex:int = Math.min(this.currentNodeIndex + this.enemySpeed * 2, this.totalNodes - 1);
			
			return this.path[targetNodeIndex];
		}
		
		/**
		 * 获取一个箭塔的目标位置。该位置表示当箭塔瞄准该敌人进行发射时，
		 * 会以哪里作为弓箭的目标位置。
		 */
		public function getArcherTarget(archerLevel:int = 1):Node
		{
			if (this.isBlocked)
				return new Node(this.x + this.enemyAdjustX, this.y + this.enemyAdjustY);
			
			var randomSpeedX:Number = this.enemySpeedX * (Math.random() * 2 / archerLevel - 1 / archerLevel);
			var randomSpeedY:Number = this.enemySpeedY * (Math.random() * 2 / archerLevel - 1 / archerLevel);
			var targetNode:Node = new Node(this.x + 0.6 * 30 * this.enemySpeedX + this.enemyAdjustX + randomSpeedX, this.y + 0.6 * 30 * this.enemySpeedY + this.enemyAdjustY + randomSpeedY);
			
			return targetNode;
		}
		
		/**
		 * 获取一个魔法塔的目标位置。该位置表示当魔法塔瞄准该敌人进行发射时，
		 * 会以哪里作为能量弹的目标位置。
		 */
		public function getMageTarget():Node
		{
			return new Node(this.x + this.enemyAdjustX, this.y + this.enemyAdjustY);
		}
		
		/**
		 * 用士兵阻挡该敌人。
		 * 
		 * @param	soldier - 将要阻挡该敌人的士兵。
		 */
		public function block(soldier:Soldier):void
		{
			this.soldier = soldier;
			this.isBlocked = true;
		}
		
		/**
		 * 指定敌人能否躲避攻击。
		 */
		public function dodgeAttack():Boolean
		{
			return this.enemyDodge && Math.random() < this.enemyDodge;
		}
		
		/**
		 * 返回将与其作战的士兵的战斗位置。
		 */
		public function addFighter():int
		{
			var position:int;
			
			if (this.fighters[FightingPosition.LEFT_SIDE] == 0)
				position = FightingPosition.LEFT_SIDE;
			else if (this.fighters[FightingPosition.RIGHT_SIDE] == 0)
				position = FightingPosition.RIGHT_SIDE;
			else
				position = Math.random() < 0.5 ? FightingPosition.LEFT_SIDE : FightingPosition.RIGHT_SIDE;
			
			this.fighters[position]++;
			
			return position;
		}
		
		/**
		 * 移除指定战斗位置上的士兵。
		 * 
		 * @param	fightingPosition - 战斗位置的编号。
		 */
		public function removeFighter(fightingPosition:int):void
		{
			if (!this.isActive)
				return;
			
			this.fighters[fightingPosition]--;
		}
		
		/**
		 * 使敌人进入肉搏状态。
		 */
		public function startFighting():void
		{
			this.isBlocked = true;
			this.isFighting = true;
			this.isAttacking = false;
			this._reloadCounter = this.enemyReload;
		}
		
		/**
		 * 使敌人结束肉搏状态。
		 */
		public function stopFighting():void
		{
			this.isFighting = false;
			this.isBlocked = false;
			this.isAttacking = false;
			this._reloadCounter = 0;
			this.soldier = null;
		}
		
		/**
		 * 对该敌人造成物理伤害。
		 *
		 * @param	damage - 所造成的物理伤害。
		 * @param	isTrueDamage - 是否为真实伤害。
		 */
		public function damage(damage:int, isTrueDamage:Boolean = false):void
		{
			if (!this.isActive)
				return;
			
			isTrueDamage || (damage *= 1 - this.enemyArmor);
			
			this.enemyHP = Math.max(this.enemyHP - damage, 0);
			this.hpBar.updateHP();
			this.selected && this.level.levelInfo.showEnemyInfo(this);
			
			if (this.enemyHP == 0)
				this.fadeout();
		}
		
		/**
		 * 对该敌人造成魔法伤害。
		 *
		 * @param	damage - 所造成的魔法伤害。
		 * @param	isTrueDamage - 是否为真实伤害。
		 */
		public function magicDamage(damage:int, isTrueDamage:Boolean = false):void
		{
			if (!this.isActive)
				return;
			
			isTrueDamage || (damage *= 1 - this.enemyMagicArmor);
			
			this.enemyHP = Math.max(this.enemyHP - damage, 0);
			this.hpBar.updateHP();
			this.selected && this.level.levelInfo.showEnemyInfo(this);
			
			if (this.enemyHP == 0)
				this.fadeout();
		}
		
		/**
		 * 对该敌人造成火焰伤害，即无视任何防护的伤害。
		 * 
		 * @param	damage - 所造成的伤害。
		 */
		public function fireDamage(damage:int):void
		{
			if (!this.isActive)
				return;
			
			this.enemyHP = Math.max(this.enemyHP - damage, 0);
			this.hpBar.updateHP();
			this.selected && this.level.levelInfo.showEnemyInfo(this);
			
			if (this.enemyHP == 0)
				this.fadeout();
		}
		
		/**
		 * 行走。
		 */
		public function walk():void
		{
			this.move();
		}
		
		/**
		 * 战斗。为进攻充能（计时）。
		 */
		public function fight():void
		{
			this.currentFrame == 1 && this.gotoAndPlay(2);
			
			if (this._attackCounter < this._attackTime)
			{
				this._attackCounter++;
				return;
			}
			
			this.attack();
			this.isAttacking = false;
			this._attackCounter = 0;
			this.gotoAndStop(1);
		}
		
		/**
		 * 进攻。
		 */
		public function attack():void
		{
			if (!(this.soldier && this.soldier.isActive))
			{
				this.stopFighting();
				return;
			}
			
			if (this.soldier.dodgeAttack())
				return;
			
			if (Math.random() < 0.25)
				new Pop((this.soldier.x + this.soldier.soldierAdjustX + this.x + this.enemyAdjustX) * 0.5, (this.soldier.y + this.soldier.soldierAdjustY + this.y + this.enemyAdjustY) * 0.5, Math.random() < 0.5 ? Pop.SOK : Pop.POW, this.level);
			
			this.soldier.damage(this.getDamage());
			
			if (!(this.soldier && this.soldier.isActive))
				this.stopFighting();
		}
		
		/**
		 * 获取敌人进攻造成的随机伤害（最小伤害与最大伤害之间）。
		 */
		public function getDamage():int
		{
			return int(this.enemyMinDamage + Math.random() * (this.enemyMaxDamage - this.enemyMinDamage + 1));
		}
		
		/**
		 * 更新该敌人的位置。
		 */
		public function move():void
		{
			this.enemyWalkingDirection = Node.direction(this, this.path[this.currentNodeIndex + 1]);
			
			var angleSpeed:Point = Point.polar(this.enemySpeed, this.enemyWalkingDirection / 180 * Math.PI);
			
			this.enemySpeedX = angleSpeed.x;
			this.enemySpeedY = angleSpeed.y;
			
			this.x += enemySpeedX;
			this.y += enemySpeedY;
			
			if (Point.distance(new Node(this.x, this.y), this.path[this.currentNodeIndex + 1]) < 5)
			{
				this.currentNodeIndex++;
				this.visible = this.currentNode.visible;
				this.currentNode.isBegining && (this.isActive = true)
			}
			
			if (this.currentNodeIndex == this.totalNodes - 1)
				this.isActive = false;
			
			if (this.currentNodeIndex == this.path.length - 1)
			{
				this.level.updateLife(-this.enemyLoseLife);
				this.level.updateEnemyOnStage(-1);
				this.level.life > 0 && this.destroy();
			}
		}
		
		/**
		 * 淡出该敌人。
		 */
		public function fadeout():void
		{
			this.buttonMode = false;
			this.isActive = false;
			this.enemySpeed = 0;
			this.removeGlow();
			this.hpBar.visible = false;
			this.level.updateEnemyOnStage(-1);
			this.level.updateCash(this.enemyPrice);
			this.level.selectedEnemy && this.level.selectedEnemy == this && this.level.levelInfo.showLevelInfo();
			
			this.removeEventListener(MouseEvent.CLICK, this.onEnemyClick);
			
			TweenMax.to(this, 0.5, {y: "-20", autoAlpha: 0, onComplete: this.onFadeoutComplete});
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	FRAME_UPDATER
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		override public function updateFrame():void
		{
			super.updateFrame();
			
			if (this.isBlocked)
			{
				if (!(this.soldier && this.soldier.isActive && !this.soldier.isDead && this.soldier.isBlocking))
					this.stopFighting();
				
				if (this.isFighting)
				{
					if (!(this.soldier && this.soldier.isActive))
					{
						this.stopFighting();
						return;
					}
					
					if (this.isAttacking)
						this.fight();
					else
						this.updateFighting();
				}
			}
			else
			{
				this.walk();
			}
		}
		
		/**
		 * 更新敌人的进攻冷却时间。
		 */
		public function updateFighting():void
		{
			if (this._reloadCounter < this.enemyReload)
			{
				this._reloadCounter++;
				return;
			}
			
			this._reloadCounter = 0;
			this.isAttacking = true;
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	EVENT_HANDLERS
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		/**
		 * 鼠标单击。
		 */
		protected function onEnemyClick(event:MouseEvent):void
		{
			this.level.hideAllGUIs();
			
			if (this.level.selectedEnemy && this.level.selectedEnemy == this)
				return;
			
			this.selected = true;
			this.level.selectedEnemy = this;
		}
		
		/**
		 * 淡出完毕。
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
			this.removeEventListener(MouseEvent.CLICK, this.onEnemyClick);
			
			this.hpBar.destroy();
			this.hpBar = null;
			
			this.path = null;
			
			this.level.removeEnemy(this);
			
			super.destroy();
		}
	
	}

}