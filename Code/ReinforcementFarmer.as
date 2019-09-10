package
{
	import com.greensock.TweenMax;
	import org.casalib.math.geom.Ellipse;
	
	public class ReinforcementFarmer extends Soldier
	{
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	CONSTRUCTOR
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		public function ReinforcementFarmer(x:int, y:int, level:Level, info:GameSettingItem)
		{
			super(x, y, null, info, null, level.entities);
			
			this.rallyPoint = new Node(this.x, this.y);
			this.lifeTime = info.loseLife;
			this.soldierRespawn = -1;
			this.isActive = false;
			
			this.fadein();
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	PROPERTIES
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		public var lifeTime:int;
		
		protected var _lifeCounter:int;
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	ACCESSORS
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	INITIALIZATION
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		public function initReinforcement():void
		{
			this.changeRallyPoint();
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	METHODS
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		public function fadein():void
		{
			TweenMax.from(this, 0.5, {autoAlpha: 0, onComplete: this.initReinforcement});
		}
		
		override public function findTarget():Boolean
		{
			if (this.isBlocking)
				return false;
			
			var walkingTarget:Enemy;
			var fightingTarget:Enemy;
			var range:Ellipse = new Ellipse(this.rallyPoint.x - this.soldierRange * 0.5, this.rallyPoint.y - this.soldierRange * 0.7 * 0.5, this.soldierRange, this.soldierRange * 0.7);
			var position:Node = new Node();
			
			for each (var p:Enemy in this.level.dEnemies)
			{
				if (!(p && p.isActive && p.enemyMaxDamage > 0))
					continue;
				
				position.x = p.x;
				position.y = p.y;
				
				if (!range.containsPoint(position))
					continue;
				
				if (!p.isBlocked)
				{
					if (!walkingTarget || p.totalNodes - p.currentNodeIndex < walkingTarget.totalNodes - walkingTarget.currentNodeIndex)
						walkingTarget = p;
				}
				else
				{
					if (!this.isFighting && (!fightingTarget || p.totalNodes - p.currentNodeIndex < fightingTarget.totalNodes - fightingTarget.currentNodeIndex))
						fightingTarget = p;
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
		
		override public function die():void
		{
			this.isDead = true;
			
			this.stopFighting();
			this.fadeout();
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	FRAME_UPDATER
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		override public function updateFrame():void
		{
			if (this.isDead)
				return;
			
			if (this._lifeCounter == this.lifeTime)
				this.die();
			
			if (this._lifeCounter >= this.lifeTime)
				return;
			
			this._lifeCounter++;
			
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
						if (!(this.enemy && this.enemy.isActive && this.enemy.isBlocked))
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
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	EVENT_HANDLERS
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		override protected function onFadeoutComplete():void
		{
			this.destroy();
		}
	
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	DESTROYER
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
	
	}

}