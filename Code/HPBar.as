/**
 * 2016/1/16 12:49
 *
 * 敌人或士兵的生命条
 */
package
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	public class HPBar extends Sprite
	{
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	CONSTRUCTOR
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		/**
		 * 创建新的 HPBar 对象。
		 *
		 * @param	target - 该对象所属的敌人或士兵。
		 */
		public function HPBar(target:LevelEntity)
		{
			super();
			
			this.mouseChildren = false;
			this.mouseEnabled = false;
			
			this.target = target;
			
			this.width = target.width * 1.1;
			
			this.y = -target.height - 20;
			
			if (target is Soldier)
			{
				this.hp = target.soldierHP;
				this.maxHP = target.soldierMaxHP;
			}
			else
			{
				this.hp = target.enemyHP;
				this.maxHP = target.enemyMaxHP;
			}
			
			target.addChild(this);
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	PROPERTIES
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		public var bar:MovieClip;
		/**
		 * 所属的敌人或士兵。
		 */
		public var target:LevelEntity;
		/**
		 * 敌人或士兵目前的生命。
		 */
		public var hp:int;
		/**
		 * 敌人或士兵的最大生命。
		 */
		public var maxHP:int;
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	ACCESSORS
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	METHODS
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		public function flip(scaleX:int = 0):void
		{
			if (scaleX == 0)
				this.bar.scaleX *= -1;
			else
				this.bar.scaleX = scaleX;
		}
		
		/**
		 * 刷新当前生命。
		 *
		 * @param	hp - 当前的生命。
		 */
		public function updateHP(hp:int = -1):void
		{
			hp > 0 ? (this.hp = hp) : (this.hp = this.target is Soldier ? this.target.soldierHP : this.target.enemyHP);
			
			this.bar.progress.scaleX = this.hp / this.maxHP;
		}
		
		/**
		 * 刷新最大生命。
		 *
		 * @param	hp - 最大生命。
		 */
		public function updateMaxHP(hp:int = -1):void
		{
			hp > 0 ? (this.hp = hp) : (this.hp = this.target is Soldier ? this.target.soldierMaxHP : this.target.enemyMaxHP);
			
			this.bar.progress.scaleX = this.hp / this.maxHP;
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	FRAME_UPDATER
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	EVENT_HANDLERS
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	DESTROTER
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		public function destroy():void
		{
			this.target = null;
			
			this.parent.removeChild(this);
		}
	
	}

}