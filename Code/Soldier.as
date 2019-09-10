package
{
	import com.greensock.TweenMax;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.utils.getTimer;
	import org.casalib.math.geom.Ellipse;
	
	public class Soldier extends LevelEntity
	{
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	CONSTRUCTOR
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		public function Soldier(x:int, y:int, tower:TowerBarrack, info:GameSettingItem, rallyPoint:Node = null, parent:Sprite = null)
		{
			super(x, y, tower ? tower.level.entities : parent);
			
			this.buttonMode = true;
			
			this._idleTime = (Math.random() * 6 + 5) * 30;
			this._attackTime = 9;
			this._regenTime = 1 * 30;
			
			this.tower = tower;
			this.soldierAdjustX = info.adjustX;
			this.soldierAdjustY = info.adjustY;
			this.soldierArmor = info.armor;
			this.soldierDodge = info.dodge;
			this.soldierHP = this.soldierMaxHP = info.hp;
			this.soldierMaxDamage = info.maxDamage;
			this.soldierMinDamage = info.minDamage;
			this.soldierRange = info.range;
			this.soldierReload = info.reload - this._attackCounter;
			this.soldierRespawn = info.respawn;
			this.soldierRegen = info.regen;
			this.soldierSpeed = info.speed;
			this.rallyPoint = rallyPoint;
			
			this.hpBar = new HPBar(this);
			
			this.soldierName = this.getSoldierName();
			this.destinationPoint = new Node();
			this.fightingPosition = -1;
			
			this._glowing = new GlowFilter();
			this._glowing.color = 0xFFFF00;
			this._glowing.quality = 15;
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	PROPERTIES
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		public var tower:TowerBarrack;
		public var enemy:Enemy;
		public var hpBar:HPBar;
		public var rallyPoint:Node;
		public var destinationPoint:Node;
		public var soldierName:String;
		public var soldierArmor:Number;
		public var soldierDodge:Number;
		public var soldierSpeed:Number;
		public var soldierHP:int;
		public var soldierMaxHP:int;
		public var soldierMinDamage:int;
		public var soldierMaxDamage:int;
		public var soldierRange:int;
		public var soldierReload:int;
		public var soldierRegen:int;
		public var soldierRespawn:int;
		public var soldierAdjustX:int;
		public var soldierAdjustY:int;
		public var fightingPosition:int;
		public var isWalking:Boolean;
		public var isBlocking:Boolean;
		public var isFighting:Boolean;
		public var isAttacking:Boolean;
		public var isIdle:Boolean;
		public var isDead:Boolean;
		
		protected var _glowing:GlowFilter;
		protected var _reloadCounter:int;
		protected var _idleTime:int;
		protected var _idleCounter:int;
		protected var _regenTime:int;
		protected var _regenCounter:int;
		protected var _attackTime:int;
		protected var _attackCounter:int;
		protected var _dyingCounter:int;
		protected var _selected:Boolean;
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	ACCESSORS
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		public function get selected():Boolean
		{
			return this._selected;
		}
		
		public function set selected(value:Boolean):void
		{
			if (!this.level)
				return;
			
			this._selected = value;
			//trace(value, this.level.selectedSoldier, this.level.selectedSoldier ? this.level.selectedSoldier.name : 000, this.name);
			if (value)
			{
				this.addGlow();
				this.level.levelInfo.showSoldierInfo(this);
			}
			else
			{
				this.removeGlow();
				this.level.selectedSoldier || this.level.levelInfo.showingMode == LevelInfo.SHOW_SOLDIER_INFO || this.level.levelInfo.showLevelInfo();
				this.level.selectedSoldier = null;
			}
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	INITIALIZATION
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		override public function init():void
		{
			super.init();
			
			this.level.addSoldier(this);
			
			this.gotoAndStop(1);
			
			this.addEventListener(MouseEvent.CLICK, this.onSoldierClick, false, 0, true);
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	METHODS
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		public function getSoldierName():String
		{
			return SoldierNames.SOLDIER_NAMES[int(Math.random() * SoldierNames.SOLDIER_NAMES.length)];
		}
		
		public function addGlow():void
		{
			this.filters = [this._glowing];
		}
		
		public function removeGlow():void
		{
			if (!this.selected)
				this.filters = [];
		}
		
		override public function pause():void
		{
			this.stop();
		}
		
		override public function unpause():void
		{
			this.currentFrame == 1 || this.play();
		}
		
		public function flip(scaleX:int = 0):void
		{
			if (scaleX == 0)
			{
				this.scaleX *= -1;
				this.hpBar.flip(0);
			}
			else
			{
				this.scaleX = scaleX;
				this.hpBar.flip(scaleX);
			}
		}
		
		public function changeRallyPoint(rallyPoint:Node = null):void
		{
			rallyPoint && (this.rallyPoint = rallyPoint);
			
			if (this.isDead)
				return;
			
			this.isActive = false;
			
			this.stopFighting();
			this.gotoIdle();
		}
		
		public function findTarget():Boolean
		{
			if (this.isBlocking)
				return false;
			
			var walkingTarget:Enemy;
			var fightingTarget:Enemy;
			var range:Ellipse = new Ellipse(this.tower.rallyPoint.x - this.soldierRange * 0.5, this.tower.rallyPoint.y - this.soldierRange * 0.7 * 0.5, this.soldierRange, this.soldierRange * 0.7);
			var position:Node = new Node();
			
			for each (var p:Enemy in this.level.dEnemies)
			{
				if (!(p.isActive && p.enemyMaxDamage > 0))
					continue;
				
				position.x = p.x;
				position.y = p.y;
				
				if (!range.containsPoint(position))
					continue;
				
				if (!p.isBlocked)
				{
					if (!walkingTarget || p.totalNodes - p.currentNodeIndex < walkingTarget.totalNodes - walkingTarget.currentNodeIndex)
					{
						walkingTarget = p;
					}
				}
				else
				{
					if (!this.isFighting && (!fightingTarget || p.totalNodes - p.currentNodeIndex < fightingTarget.totalNodes - fightingTarget.currentNodeIndex))
					{
						fightingTarget = p;
					}
				}
			}
			p = null;
			
			range = null;
			position = null;
			
			if (walkingTarget)
			{
				this.gotoWalkingEnemy(walkingTarget);
				return true;
			}
			
			if (fightingTarget)
			{
				this.gotoFightingEnemy(fightingTarget);
				return true;
			}
			
			return false;
		}
		
		public function gotoIdle():void
		{
			if (this.isWalking)
				this.isIdle = false;
			
			this.isWalking = true;
			this.isBlocking = false;
			this.isFighting = false;
			this.isAttacking = false;
			
			this.enemy = null;
			
			this._idleCounter = -45;
			
			this.destinationPoint.x = this.rallyPoint.x;
			this.destinationPoint.y = this.rallyPoint.y;
			
			if (this.isActive)
				this.findTarget();
			
			this.currentFrame == 1 || this.gotoAndStop(1);
		}
		
		public function gotoWalkingEnemy(enemy:Enemy):void
		{
			enemy.block(this);
			
			this.isIdle = false;
			this.isWalking = true;
			this.isBlocking = true;
			this.isFighting = true;
			
			this.fightingPosition != FightingPosition.FACE_TO_FACE && this.enemy && this.enemy.removeFighter(this.fightingPosition);
			this.enemy = enemy;
			
			this.fightingPosition = FightingPosition.FACE_TO_FACE;
			this._reloadCounter = this.soldierReload;
			this._idleCounter = -45;
			
			this.destinationPoint.x = int(enemy.x + (enemy.width * 0.66 + 10) * (enemy.enemyWalkingDirection > -90 && enemy.enemyWalkingDirection < 90 ? 1 : -1) + 0.5);
			this.destinationPoint.y = int(enemy.y + 0.5);
			
			this.currentFrame == 1 || this.gotoAndStop(1);
			
			this.flip(this.x > enemy.x ? -1 : 1);
		}
		
		public function gotoFightingEnemy(enemy:Enemy):void
		{
			this.isIdle = false;
			this.isWalking = true;
			this.isBlocking = false;
			this.isFighting = true;
			
			this.fightingPosition != FightingPosition.FACE_TO_FACE && this.enemy && this.enemy.removeFighter(this.fightingPosition);
			this.enemy = enemy;
			
			this.fightingPosition = enemy.addFighter();
			this._reloadCounter = this.soldierReload;
			this._idleCounter = -45;
			
			this.destinationPoint.x = int(enemy.enemyWalkingDirection > -90 && enemy.enemyWalkingDirection < 90 ? enemy.x + enemy.width * 0.58 + 7 + 0.5 : enemy.x - enemy.width * 0.58 - 7 + 0.5);
			this.destinationPoint.y = int(enemy.y + 12 * Math.pow(-1, this.fightingPosition) + 0.5);
			
			this.currentFrame == 1 || this.gotoAndStop(1);
			
			this.flip(this.x > enemy.x ? -1 : 1);
		}
		
		public function damage(damage:int):void
		{
			if (!this.isActive)
				return;
			
			damage *= 1 - this.soldierArmor;
			
			this.soldierHP = Math.max(this.soldierHP - damage, 0);
			this.hpBar.updateHP();
			this.selected && this.level.levelInfo.showSoldierInfo(this);
			
			if (this.soldierHP == 0)
				this.die();
		}
		
		public function dodgeAttack():Boolean
		{
			return this.soldierDodge && Math.random() < this.soldierDodge;
		}
		
		public function regen():void
		{
			if (this.soldierHP >= this.soldierMaxHP)
				return;
			
			this.soldierHP = Math.min(this.soldierHP + this.soldierRegen, this.soldierMaxHP);
			this.hpBar.updateHP();
			this.selected && this.level.levelInfo.showSoldierInfo(this);
		}
		
		public function stand():void
		{
			this.isBlocking && (this.isBlocking = false);
			this.isFighting && (this.isFighting = false);
			
			if (this._idleCounter < this._idleTime)
			{
				this._idleCounter++;
			}
			else
			{
				this._idleCounter = 0;
				this.flip();
				this._idleTime = (Math.random() * 6 + 5) * 30;
			}
			
			if (this.soldierHP < this.soldierMaxHP)
			{
				if (this._regenCounter < this._regenTime)
				{
					this._regenCounter++;
				}
				else
				{
					this._regenCounter = 0;
					this.regen();
				}
			}
		}
		
		public function walk():Boolean
		{
			if (this.isActive)
			{
				if (this.isFighting)
				{
					if (!(this.enemy && this.enemy.isActive))
					{
						this.stopFighting();
						
						if (!this.findTarget())
							this.gotoIdle();
					}
					else
					{
						if (!this.isBlocking)
							this.findTarget();
					}
				}
				else
				{
					this.findTarget();
				}
			}
			
			if (this.destinationReach())
				return true;
			
			var direction:Number = Node.direction(this, this.destinationPoint) / 180 * Math.PI;
			var speedX:Number = Math.cos(direction) * this.soldierSpeed;
			var speedY:Number = Math.sin(direction) * this.soldierSpeed;
			
			this.x += speedX;
			this.y += speedY;
			
			this.currentFrame == 1 || this.gotoAndStop(1);
			
			this.flip(this.x < destinationPoint.x ? 1 : -1);
			
			return false;
		}
		
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
		
		public function attack():void
		{
			if (!(this.enemy && this.enemy.isActive))
			{
				this.stopFighting();
				return;
			}
			
			if (this.isBlocking && this.enemy.dodgeAttack())
				return;
			
			if (Math.random() < 0.25)
			{
				if (Math.random() < 0.5)
					new Pop((this.enemy.x + this.enemy.enemyAdjustX + this.x + this.soldierAdjustX) * 0.5, (this.enemy.y + this.enemy.enemyAdjustY + this.y + this.soldierAdjustY) * 0.5, Pop.SOK, this.level);
				else
					new Pop((this.enemy.x + this.enemy.enemyAdjustX + this.x + this.soldierAdjustX) * 0.5, (this.enemy.y + this.enemy.enemyAdjustY + this.y + this.soldierAdjustY) * 0.5, Pop.POW, this.level);
			}
			
			this.enemy.damage(this.getDamage());
			
			if (!(this.enemy && this.enemy.isActive))
				this.stopFighting();
		}
		
		public function die():void
		{
			this.isDead = true;
			
			this.stopFighting();
			this.fadeout();
			
			this._dyingCounter = 0;
		}
		
		public function respawn():void
		{
			this.soldierName = this.getSoldierName();
			this._dyingCounter = 0;
			this.isDead = false;
			this.isActive = true;
			this.isAttacking = false;
			this.isBlocking = false;
			this.isFighting = false;
			this.visible = true;
			this.buttonMode = true;
			this.alpha = 1;
			this.x = this.tower.x;
			this.y = this.tower.y;
			this.hpBar.visible = true;
			this.soldierHP = this.soldierMaxHP;
			this.hpBar.updateHP();
			
			this.findTarget() || this.gotoIdle();
			
			this.addEventListener(MouseEvent.CLICK, this.onSoldierClick, false, 0, true);
		}
		
		public function getDamage():int
		{
			return int(this.soldierMinDamage + Math.random() * (this.soldierMaxDamage - this.soldierMinDamage + 1));
		}
		
		public function startFighting():void
		{
			this.y += Math.random() * 4 - 2;
			
			this.isActive = true;
			this.isIdle = false;
			this.isFighting = true;
			this.isAttacking = false;
			this._attackCounter = 0;
			this._reloadCounter = this.soldierReload;
			
			this.currentFrame == 1 || this.gotoAndStop(1);
		}
		
		public function stopFighting():void
		{
			this.isIdle = false;
			this.isBlocking = false;
			this.isFighting = false;
			this.isAttacking = false;
			this._reloadCounter = 0;
			this._attackCounter = 0;
			
			this.enemy && this.enemy.soldier == this && this.enemy.updateFrame();
			
			this.fightingPosition != FightingPosition.FACE_TO_FACE && this.enemy && this.enemy.removeFighter(this.fightingPosition);
			
			this.enemy = null;
			this.fightingPosition = -1;
		}
		
		public function destinationReach():Boolean
		{
			this.currentFrame == 1 || this.gotoAndStop(1);
			
			if (Node.distance(this, this.destinationPoint) <= this.soldierSpeed)
			{
				this.isWalking = false;
				this.isActive = true;
				
				this.x = int(this.destinationPoint.x + 0.5);
				this.y = int(this.destinationPoint.y + 0.5);
				
				if (this.isFighting && this.enemy)
				{
					this.startFighting();
					this.isBlocking && this.enemy.startFighting();
					
					this.x < this.enemy.x ? this.flip(1) : this.flip(-1);
				}
				else
				{
					this.isIdle = true;
				}
				
				return true;
			}
			
			return false;
		}
		
		public function readyToRespawn():Boolean
		{
			if (this._dyingCounter < this.soldierRespawn)
			{
				this._dyingCounter++;
				return false;
			}
			
			this.respawn();
			
			return true;
		}
		
		public function fadeout():void
		{
			this.level.selectedSoldier && this.level.selectedSoldier == this && this.level.levelInfo.showLevelInfo();
			this._selected && (this.selected = false);
			this.buttonMode = false;
			this.isActive = false;
			this.filters = [];
			this.hpBar.visible = false;
			this.hpBar.visible = false;
			
			this.fightingPosition != FightingPosition.FACE_TO_FACE && this.enemy && this.enemy.removeFighter(this.fightingPosition);
			
			this.gotoAndStop(1);
			
			this.removeEventListener(MouseEvent.CLICK, this.onSoldierClick);
			
			TweenMax.to(this, 0.5, {y: "-20", autoAlpha: 0, onComplete: this.onFadeoutComplete});
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	FRAME_UPDATER
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		override public function updateFrame():void
		{
			if (this.isDead && !this.readyToRespawn())
				return;
			
			if (this.isWalking && !this.walk())
				return;
			
			if (this.isActive)
			{
				if (this.isIdle)
				{
					this.currentFrame == 1 || this.gotoAndStop(1);
					
					if (!this.findTarget())
						this.stand();
				}
				else
				{
					if (this.isFighting)
					{
						if (!(this.enemy && this.enemy.isActive))
						{
							this.stopFighting();
							return;
						}
						
						if (!this.isBlocking && this.findTarget())
							return;
						
						if (this.isAttacking)
							this.fight();
						else
							this.updateFighting();
					}
					else
					{
						this.gotoIdle();
					}
				}
			}
		}
		
		public function updateFighting():void
		{
			if (this._reloadCounter < this.soldierReload)
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
		
		protected function onSoldierClick(event:MouseEvent):void
		{
			this.level.hideAllGUIs();
			
			if (this.level.selectedSoldier && this.level.selectedSoldier == this)
				return;
			
			this.selected = true;
			this.level.selectedSoldier = this;
		}
		
		protected function onFadeoutComplete():void
		{
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	DESTROYER
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		override public function destroy():void
		{
			this.removeEventListener(MouseEvent.CLICK, this.onSoldierClick);
			this.isActive = false;
			this.fightingPosition != FightingPosition.FACE_TO_FACE && this.enemy && this.enemy.removeFighter(this.fightingPosition);
			
			this.filters = [];
			this._glowing = null;
			
			if (this.hpBar)
			{
				this.hpBar.destroy();
				this.hpBar = null;
			}
			
			this.rallyPoint = null;
			this.destinationPoint = null;
			
			this.tower = null;
			this.enemy = null;
			
			this.level.removeSoldier(this);
			
			super.destroy();
		}
	
	}

}