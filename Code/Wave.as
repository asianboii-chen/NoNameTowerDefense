/**
 * 2016/1/17 13:30
 *
 * 波
 */
package
{
	
	public class Wave
	{
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	CONSTRUCTOR
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
		
		/**
		 * 创建新的 Wave 对象。
		 *
		 * @param	spawns - 波中要出现的敌人。
		 * @param	level - 所属的关卡。
		 * @param	delay - 从本波图标出现到本波开始的时隔。
		 * @param	interval - 从本波结束到下一波图标出现的时隔。
		 */
		public function Wave(spawns:Array, delay:int = 0, interval:int = 0)
		{
			this.spawns = spawns;
			
			this.delay = delay;
			this.interval = interval;
			
			this.waveFlags = [];
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	PROPERTIES
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
		
		/**
		 * 波中要出现的敌人。
		 */
		public var spawns:Array;
		
		public var waveFlags:Array;
		/**
		 * 从本波图标出现到本波开始的时隔。
		 */
		public var delay:int;
		/**
		 * 从本波结束到下一波图标出现的时隔。
		 */
		public var interval:int;
		/**
		 * 波是否处于闲置状态。
		 */
		public var isIdle:Boolean;
		
		public var isStarted:Boolean;
		/**
		 * 所属的关卡。
		 */
		private var _level:Level;
		/**
		 * delay 属性的计时器。
		 */
		private var _delayCounter:int;
		
		/**
		 * interval 属性的计时器。
		 */
		private var _intervalCounter:int;
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	ACCESSORS
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
		
		/**
		 * [只读] 本波中的敌人数量。
		 */
		public function get numEnemies():int
		{
			var num:int;
			
			for each (var p:WaveSpawn in this.spawns)
			{
				num += p.numberTotal;
			}
			
			return num;
		}
		
		/**
		 * [只读] 本波将要出现的敌人的描述。
		 */
		public function get waveEnemies():Array
		{
			var enemies:Array = [];
			var classes:Array = [];
			var numbers:Array = [];
			var showEnemyNumber:Boolean = this.level.levelMode == LevelMode.CAMPAIGN;
			
			for each (var p:WaveSpawn in this.spawns)
			{
				var n:int;
				var index:int;
				
				if (classes[p.pathIndex] && classes[p.pathIndex].length > 0)
				{
					n = classes[p.pathIndex].length;
					index = classes[p.pathIndex].indexOf(p.enemy);
					
					if (index == -1)
					{
						classes[p.pathIndex][n] = p.enemy;
						numbers[p.pathIndex][n] = p.numberTotal;
					}
					else
					{
						numbers[p.pathIndex][index] += p.numberTotal;
					}
				}
				else
				{
					for (var i:int = 0; i < p.pathIndex; i++)
					{
						if (!classes[i])
						{
							classes[i] = [];
							numbers[i] = [];
						}
					}
					
					classes[p.pathIndex] = [p.enemy];
					numbers[p.pathIndex] = [p.numberTotal];
				}
			}
			
			for (i = 0, n = classes.length; i < n; i++)
			{
				enemies[i] = "";
				
				for (var j:int = 0, m:int = classes[i].length; j < m; j++)
				{
					if (showEnemyNumber)
						enemies[i] += this.level.game.gameSettings.getSettingsByClass(classes[i][j]).name + "*" + numbers[i][j] + "\n";
					else
						enemies[i] += this.level.game.gameSettings.getSettingsByClass(classes[i][j]).name + "\n";
				}
			}
			
			classes.length = 0;
			classes = null;
			numbers.length = 0;
			numbers = null;
			
			return enemies;
		}
		
		/**
		 * [只读] 本波中的敌人是否已经全部出现完毕。
		 */
		public function get isAllDone():Boolean
		{
			for each (var p:WaveSpawn in this.spawns)
			{
				if (!p.isDone)
					return false;
			}
			
			return true;
		}
		
		public function get level():Level
		{
			return this._level;
		}
		
		public function set level(value:Level):void
		{
			this._level = value;
			
			for each (var p:WaveSpawn in this.spawns)
			{
				p.level = value;
			}
			p = null;
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	INITIALIZATION
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	METHODS
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
		
		/**
		 * 显示本波的图标。
		 *
		 * @param	isIdle - 本波是否处于闲置状态。若设为 true ，将不会进行计时，而是等到用户单击下一波图标为止。
		 */
		public function showWaveFlags(isIdle:Boolean = false):void
		{
			var waveFlagPaths:Array = [];
			var waveEnemies:Array = this.waveEnemies;
			
			for each (var p:WaveSpawn in this.spawns)
			{
				if (waveFlagPaths.indexOf(p.pathIndex) == -1)
					waveFlagPaths[waveFlagPaths.length] = p.pathIndex;
			}
			
			for each (var q:int in waveFlagPaths)
			{
				this.waveFlags[this.waveFlags.length] = new WaveFlag(this.level, waveEnemies[q], q, isIdle ? -1 : this.delay);
			}
			
			waveFlagPaths.length = 0;
			waveFlagPaths = null;
			waveEnemies.length = 0;
			waveEnemies = null;
		}
		
		public function hideWaveFlags():void
		{
			while (this.waveFlags.length > 0)
			{
				this.waveFlags[this.waveFlags.length - 1].isCounting = false;
				this.waveFlags[this.waveFlags.length - 1].fadeout();
				this.waveFlags.length--;
			}
		}
		
		/**
		 * 立即开始本波。
		 */
		public function startWave(waveFlag:WaveFlag = null):void
		{
			if (this.isStarted)
				return;
			
			this.isStarted = true;
			
			if (waveFlag)
			{
				if (this.delay != -1)
				{
					var reward:int = int((this.delay - this._delayCounter) / 30 + 0.5)
					
					if (reward > 0)
					{
						this.level.updateCash(reward);
						new PopWaveReward(waveFlag, reward);
						
						this.level.spellReinforcement.reward(reward + 1);
						this.level.spellFireball.reward(reward + 1);
					}
				}
			}
			
			this.delay == -1 && (this.level.levelState = LevelState.BATTLE);
			this._delayCounter = this.delay;
			
			this.level.wave < this.level.totalWaves - 1 && this.level.wave++;
			this.level.enemyIdle += Wave(this.level.waves[this.level.wave]).numEnemies;
			this.level.updateEnemyOnStage();
			this.level.totalWaveEnemys = this.level.enemyIdle;
			
			this.level.onWaveStart();
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	FRAME_UPDATER
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
		
		public function updateFrame():void
		{
			if (this._delayCounter == 0)
			{
				this._delayCounter++;
				this.showWaveFlags(this.delay == -1);
			}
			
			if (this.delay == -1 && this.isIdle)
				return;
			
			if (this._delayCounter < this.delay)
			{
				this._delayCounter++;
				return;
			}
			
			if (!this.isStarted)
				return;
			
			for each (var p:WaveSpawn in this.spawns)
			{
				p.updateFrame();
			}
			p = null;
			
			for each (p in this.spawns)
			{
				if (!p.isDone)
				{
					p = null;
					return;
				}
			}
			
			if (this._intervalCounter < this.interval)
			{
				this._intervalCounter++;
				return;
			}
			
			this.level.currentWave++;
			this.destroy();
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	EVENT_HANDLERS
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	DESTROYER
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
		
		public function destroy():void
		{
			for each (var p:WaveSpawn in this.spawns)
			{
				p.destroy();
			}
			p = null;
			
			this.spawns = null;
			
			this.waveFlags = null;
			
			this.level = null;
		}
	
	}

}