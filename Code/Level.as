/**
 * 2016/1/16 12:53
 *
 * [抽象基类] 关卡
 */
package
{
	import com.greensock.easing.Quad;
	import com.greensock.TweenMax;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	import org.casalib.math.geom.Ellipse;
	
	public class Level extends GameScene
	{
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	CONSTRUCTOR
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		/**
		 * [抽象基类] Level 类是抽象基类，实例化该类可能会出现异常。
		 *
		 * @param	background - 关卡的背景图像。
		 * @param	towers - 关卡的塔位。
		 * @param	paths - 关卡的路径。
		 * @param	waves - 关卡的敌人波次。
		 * @param	cash - 关卡的初始金币。
		 * @param	life - 关卡的生命上限。
		 * @param	towerArcherLevelEnabled - 箭塔在该关卡所开放的等级。
		 * @param	towerArtilleryLevelEnabled - 炮塔在该关卡所开放的等级。
		 */
		public function Level(game:Game, id:int, mode:String, background:Sprite, paths:Array)
		{
			var towers:Array;
			var towerPositions:Array;
			var waves:Array;
			
			this.towerHolders = new Sprite();
			this.entities = new Sprite();
			this.bullets = new Sprite();
			this.gui = new Sprite();
			this.spells = new Sprite();
			this.notifications = new Sprite();
			
			this.dTowers = new Dictionary(true);
			this.dSoldiers = new Dictionary(true);
			this.dEnemies = new Dictionary(true);
			this.dBullets = new Dictionary(true);
			
			this.visible = false;
			
			super(game);
			
			this.pauseTip = new LevelPauseTip(this);
			this.towerRange = new TowerRange(this, TowerRange.CURRENT_RANGE);
			this.towerRangeNew = new TowerRange(this, TowerRange.NEW_RANGE);
			this.levelInfo = new LevelInfo(this, 205, 545);
			this.spellFireball = new SpellFireball(this, 55, 545, 1);
			this.spellReinforcement = new SpellReinforcement(this, 150, 545, 1);
			
			this.id = id;
			this.levelMode = mode;
			this.background = background;
			this.paths = paths;
			this.levelState = LevelState.PRE_BATTLE;
			
			if (mode == LevelMode.CAMPAIGN)
			{
				this.cash = Levels.LEVELS[id].cash;
				this.life = 10;
				this.towerArcherLevelEnabled = Levels.LEVELS[id].archerLevel;
				this.towerArtilleryLevelEnabled = Levels.LEVELS[id].artilleryLevel;
				this.towerMageLevelEnabled = Levels.LEVELS[id].mageLevel;
				this.towerBarrackLevelEnabled = Levels.LEVELS[id].barrackLevel;
			}
			else
			{
				this.cash = Levels.LEVEL_IRONS[id].cash;
				this.life = 1;
				this.towerArcherLevelEnabled = Levels.LEVEL_IRONS[id].archerLevel;
				this.towerArtilleryLevelEnabled = Levels.LEVEL_IRONS[id].artilleryLevel;
				this.towerMageLevelEnabled = Levels.LEVEL_IRONS[id].mageLevel;
				this.towerBarrackLevelEnabled = Levels.LEVEL_IRONS[id].barrackLevel;
			}
			
			this._preWinTime = 90;
			
			towers = LevelTowers.LEVEL_TOWERS[id];
			towerPositions = [];
			for each (var p:Array in towers)
			{
				towerPositions[towerPositions.length] = new TowerHolder(p[0], p[1], new Node(p[2], p[3]));
			}
			this.initTowers(towerPositions);
			p = null;
			towerPositions.length = 0;
			towerPositions = null;
			
			waves = (mode == LevelMode.CAMPAIGN ? LevelWaves.LEVEL_WAVES : LevelIronWaves.LEVEL_IRON_WAVES)[id];
			this.waves = [];
			for each (var q:Wave in waves)
			{
				this.waves[this.waves.length] = new Wave([], q.delay, q.interval);
				for each (var r:WaveSpawn in q.spawns)
				{
					var spawns:Array = this.waves[this.waves.length - 1].spawns;
					
					spawns[spawns.length] = new WaveSpawn(r.enemy, r.numberTotal, r.delay, r.interval, r.pathIndex, r.pathSideIndex);
					
					spawns = null;
				}
				this.waves[this.waves.length - 1].level = this;
				
				r = null;
			}
			q = null;
			waves = null;
			
			this.waves[0].isIdle = true;
			this.wave = -1;
			this.totalWaves = this.waves.length;
			
			this.addChild(this.background);
			this.addChild(this.towerHolders);
			this.addChild(this.entities);
			this.addChild(this.bullets);
			this.addChild(this.gui);
			this.addChild(this.spells);
			this.addChild(this.notifications);
			this.addChild(this.pauseTip);
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	PROPERTIES
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		public var spellFireball:SpellFireball;
		
		public var spellReinforcement:SpellReinforcement;
		
		public var pauseTip:LevelPauseTip;
		/**
		 * 关卡中出现的塔建造选项菜单。
		 */
		public var towerMenu:TowerMenu;
		/**
		 * 关卡中出现的塔的范围。
		 */
		public var towerRange:TowerRange;
		/**
		 * 关卡中出现的塔的额外范围。
		 */
		public var towerRangeNew:TowerRange;
		
		public var pointer:MousePointer;
		/**
		 * 关卡信息显示对象。
		 */
		public var levelInfo:LevelInfo;
		/**
		 * 当前被选中的敌人。
		 */
		public var selectedEnemy:Enemy;
		
		public var selectedSoldier:Soldier;
		/**
		 * “图层 1”，关卡背景层。
		 */
		public var background:Sprite;
		/**
		 * “图层 2”，关卡塔位层。
		 */
		public var towerHolders:Sprite;
		/**
		 * “图层 3”，关卡实体层，包括塔、士兵和敌人。
		 */
		public var entities:Sprite;
		/**
		 * “图层 4”，关卡子弹层。
		 */
		public var bullets:Sprite;
		/**
		 * “图层 5”，用户界面层。
		 */
		public var gui:Sprite;
		
		public var spells:Sprite;
		
		public var notifications:Sprite;
		
		public var dEnemies:Dictionary;
		
		public var dTowers:Dictionary;
		
		public var dSoldiers:Dictionary;
		
		public var dBullets:Dictionary;
		/**
		 * 关卡路径。
		 */
		public var paths:Array;
		/**
		 * 关卡敌人波次。
		 */
		public var waves:Array;
		
		public var levelMode:String;
		/**
		 * 当前关卡所处的状态。
		 */
		public var levelState:String;
		
		public var id:int;
		/**
		 * 关卡波次的数量。
		 */
		public var totalWaves:int;
		/**
		 * 当前所处的波次。
		 */
		public var currentWave:int;
		/**
		 * 当前正在活动的波次。
		 */
		public var wave:int;
		/**
		 * 关卡当前金钱。
		 */
		public var cash:int;
		/**
		 * 关卡当前生命数。
		 */
		public var life:int;
		/**
		 * 关卡箭塔开放等级。
		 */
		public var towerArcherLevelEnabled:int;
		/**
		 * 关卡炮塔开放等级。
		 */
		public var towerArtilleryLevelEnabled:int;
		
		public var towerMageLevelEnabled:int;
		
		public var towerBarrackLevelEnabled:int;
		/**
		 * 关卡中出现并正在舞台上活动的敌人数量。
		 */
		public var enemyOnStage:int;
		/**
		 * 关卡中即将出现的敌人数量。
		 */
		public var enemyIdle:int;
		/**
		 * 当前所处波次的敌人数量。
		 */
		public var totalWaveEnemys:int;
		
		public var isPaused:Boolean;
		
		/**
		 * 即将胜利的时间计时器。
		 */
		protected var _preWinCounter:int;
		/**
		 * 即将胜利的总时间。
		 */
		protected var _preWinTime:int;
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	ACCESSORS
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	INITIALIZATIONS
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		override public function init():void
		{
			this.stage.addEventListener(Event.DEACTIVATE, this.onStageDeactivate, false, 1, true);
			this.stage.addEventListener(Event.ACTIVATE, this.onStageActivate, false, 1, true);
			
			this.addEventListener(Event.ENTER_FRAME, this.onFrameUpdate, false, 0, true);
			this.stage.addEventListener(KeyboardEvent.KEY_UP, this.onStageKeyUp, false, 0, true);
			this.background.addEventListener(MouseEvent.CLICK, this.onBackgroundClick, false, 0, true);
		}
		
		override protected function onBlackFadeoutComplete(event:Event):void
		{
			super.onBlackFadeoutComplete(event);
			
			this.levelInfo.fadein();
			this.spellFireball.fadein();
			this.spellReinforcement.fadein();
		}
		
		/**
		 * 初始化塔位。将所有塔位显示到地图上。
		 *
		 * @param	towers - 所有塔位。
		 */
		public function initTowers(towers:Array):void
		{
			for each (var p:TowerHolder in towers)
			{
				this.towerHolders.addChild(p);
			}
			
			p = null;
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	METHODS
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		public function addSoldier(soldier:Soldier):void
		{
			this.dSoldiers[soldier] = soldier;
		}
		
		public function addEnemy(enemy:Enemy):void
		{
			this.dEnemies[enemy] = enemy;
		}
		
		public function addTower(tower:LevelEntity):void
		{
			this.dTowers[tower] = tower;
		}
		
		public function addBullet(bullet:LevelEntity):void
		{
			this.dBullets[bullet] = bullet;
		}
		
		public function removeSoldier(soldier:Soldier):void
		{
			this.dSoldiers[soldier] = null;
			delete this.dSoldiers[soldier];
		}
		
		public function removeEnemy(enemy:Enemy):void
		{
			this.dEnemies[enemy] = null;
			delete this.dEnemies[enemy];
		}
		
		public function removeTower(tower:LevelEntity):void
		{
			this.dTowers[tower] = null;
			delete this.dTowers[tower];
		}
		
		public function removeBullet(bullet:LevelEntity):void
		{
			this.dBullets[bullet] = null;
			delete this.dBullets[bullet];
		}
		
		/**
		 * 显示塔的范围。
		 *
		 * @param	x - 塔的 X 坐标。
		 * @param	y - 塔的 Y 坐标。
		 * @param	range - 塔的范围。
		 */
		public function showTowerRange(x:int, y:int, range:int):void
		{
			this.towerRange.visible = true;
			this.towerRange.x = x;
			this.towerRange.y = y;
			this.towerRange.width = range;
		}
		
		/**
		 * 显示塔升级后的范围。
		 *
		 * @param	x - 塔的 X 坐标。
		 * @param	y - 塔的 Y 坐标。
		 * @param	range - 塔的范围。
		 */
		public function showTowerRangeNew(x:int, y:int, range:int):void
		{
			this.towerRangeNew.visible = true;
			this.towerRangeNew.x = x;
			this.towerRangeNew.y = y;
			this.towerRangeNew.width = range;
		}
		
		/**
		 * 显示文本信息面板。
		 *
		 * @param	title - 要显示的标题。
		 * @param	content - 要显示的描述。
		 */
		public function showInfoPanel(arg0:*, arg1:* = 300):void
		{
			if (!this.game.gamePrefs.showPanel)
				return;
			
			if (arg0 is Array)
				this.game.showInfoPanel(arg0, arg1);
			else
				this.game.showInfoPanel([[arg0, 5, 5, 0xEEEEEE, 20, true], "----", [arg1, 5, 5, 0xBBBBBB, 15]]);
		}
		
		/**
		 * 隐藏塔的范围。
		 */
		public function hideTowerRange():void
		{
			this.towerRange.visible && (this.towerRange.visible = false);
		}
		
		/**
		 * 隐藏塔升级后的范围。
		 */
		public function hideTowerRangeNew():void
		{
			this.towerRangeNew.visible && (this.towerRangeNew.visible = false);
		}
		
		/**
		 * 隐藏文本信息面板。
		 */
		public function hideInfoPanel():void
		{
			this.game.hideInfoPanel();
		}
		
		public function hidePointers():void
		{
			this.pointer && !this.pointer.isFadeingOut && this.pointer.destroy();
			this.pointer = null;
			
			this.activateAll();
		}
		
		public function unselectAllSpells():void
		{
			this.spellReinforcement.selected && this.spellReinforcement.unselect();
			this.spellFireball.selected && this.spellFireball.unselect();
		}
		
		/**
		 * 隐藏所有用户界面，包括文本信息面板、塔范围、被选中的敌人或塔等。
		 */
		public function hideAllGUIs():void
		{
			this.towerMenu && this.towerMenu.fadeout();
			this.selectedEnemy && this.selectedEnemy.level && (this.selectedEnemy.selected = false);
			this.selectedSoldier && this.selectedSoldier.level && (this.selectedSoldier.selected = false);
			this.levelInfo.showingMode != LevelInfo.SHOW_LEVEL_INFO && this.levelInfo.showLevelInfo();
			
			this.hideTowerRange();
			this.hideTowerRangeNew();
			this.activateAll();
			
			this.selectedEnemy = null;
			this.selectedSoldier = null;
		}
		
		public function activateAll():void
		{
			this.towerHolders.mouseChildren = true;
			this.entities.mouseChildren = true;
			this.bullets.mouseChildren = true;
		}
		
		public function deactivateAll():void
		{
			this.towerHolders.mouseChildren = false;
			this.entities.mouseChildren = false;
			this.bullets.mouseChildren = false;
		}
		
		public function pause(showPauseTip:Boolean = false):void
		{
			if (showPauseTip && !this.game.gamePrefs.autoPause)
				return;
			
			if (this.levelState != LevelState.OVER)
				TweenMax.pauseAll();
			
			this.isPaused = true;
			this.pauseTip.visible = showPauseTip;
			
			for (var i:int = 0, n:int = this.entities.numChildren; i < n; i++)
			{
				LevelEntity(this.entities.getChildAt(i)).pause();
			}
			
			for (i = 0, n = this.towerHolders.numChildren; i < n; i++)
			{
				LevelEntity(this.towerHolders.getChildAt(i)).pause();
			}
			
			for (i = 0, n = this.bullets.numChildren; i < n; i++)
			{
				LevelEntity(this.bullets.getChildAt(i)).pause();
			}
			
			for (i = 0, n = this.gui.numChildren; i < n; i++)
			{
				LevelEntity(this.gui.getChildAt(i)).pause();
			}
			
			for (i = 0, n = this.spells.numChildren; i < n; i++)
			{
				LevelEntity(this.spells.getChildAt(i)).pause();
			}
			
			for (i = 0, n = this.notifications.numChildren; i < n; i++)
			{
				LevelEntity(this.notifications.getChildAt(i)).pause();
			}
			
			if (!showPauseTip)
			{
				this.stage.removeEventListener(Event.DEACTIVATE, this.onStageDeactivate);
				this.stage.removeEventListener(Event.ACTIVATE, this.onStageActivate);
			}
		}
		
		public function unpause():void
		{
			if (this.pauseTip.visible && !this.game.gamePrefs.autoPause)
				return;
			
			if (this.levelState == LevelState.OVER)
				return;
			
			TweenMax.resumeAll();
			
			this.isPaused = false;
			this.pauseTip.visible = false;
			
			for (var i:int = 0, n:int = this.entities.numChildren; i < n; i++)
			{
				LevelEntity(this.entities.getChildAt(i)).unpause();
			}
			
			for (i = 0, n = this.towerHolders.numChildren; i < n; i++)
			{
				LevelEntity(this.towerHolders.getChildAt(i)).unpause();
			}
			
			for (i = 0, n = this.bullets.numChildren; i < n; i++)
			{
				LevelEntity(this.bullets.getChildAt(i)).unpause();
			}
			
			for (i = 0, n = this.gui.numChildren; i < n; i++)
			{
				LevelEntity(this.gui.getChildAt(i)).unpause();
			}
			
			for (i = 0, n = this.spells.numChildren; i < n; i++)
			{
				LevelEntity(this.spells.getChildAt(i)).unpause();
			}
			
			for (i = 0, n = this.notifications.numChildren; i < n; i++)
			{
				LevelEntity(this.notifications.getChildAt(i)).unpause();
			}
			
			this.stage.addEventListener(Event.DEACTIVATE, this.onStageDeactivate, false, 0, true);
			this.stage.addEventListener(Event.ACTIVATE, this.onStageActivate, false, 0, true);
		}
		
		/**
		 * 更新当前的关卡金钱数，并将其显示在信息面板当中。
		 *
		 * @param	cash - 要增加（正数）或减少（负数）的金钱数。
		 */
		public function updateCash(cash:int = 0):void
		{
			var tween:TweenMax = TweenMax.getTweensOf(this, true)[0];
			
			TweenMax.to(this, Math.abs(cash) * 0.001 + 0.4949, {ease: Quad.easeOut, cash: cash + (tween ? tween.vars.cash : this.cash), onUpdate: this.onCashUpdate});
			
			tween = null;
		}
		
		/**
		 * 更新当前的关卡生命数，并将其显示在信息面板当中。
		 *
		 * @param	life - 要增加（正数）或减少（负数）的生命数。
		 */
		public function updateLife(life:int = 0):void
		{
			this.life = Math.max(this.life + life, 0);
			this.levelInfo.showLife(this.life);
			
			if (this.life == 0)
				this.defeat();
		}
		
		/**
		 * 更新当前正在舞台上活动的敌人数量，并将其显示在信息面板当中。
		 *
		 * @param	enemy - 要增加（正数）或减少（负数）的敌人数量。
		 */
		public function updateEnemyOnStage(enemy:int = 0):void
		{
			if (this.levelState == LevelState.OVER)
				return;
			
			this.enemyOnStage += enemy;
			enemy > 0 && (this.enemyIdle--);
			
			this.levelInfo.showEnemies(this.enemyOnStage, this.enemyIdle);
			
			if (this.enemyOnStage == 0 && this.enemyIdle == 0 && Wave(this.waves[this.waves.length - 1]).isAllDone)
				this.levelState = LevelState.PRE_WIN;
		}
		
		public function restart():void
		{
			this.hideAllGUIs();
			
			this.levelState = LevelState.OVER;
			
			this.game.loadScene(Object(this).constructor, this.levelMode);
		}
		
		/**
		 * 以胜利结束这场战斗。
		 */
		public function win():WindowLevelWin
		{
			this.levelState = LevelState.OVER;
			
			this.pause();
			this.hideAllGUIs();
			this.hideInfoPanel();
			this.hidePointers();
			this.unselectAllSpells();
			
			this.removeEventListener(Event.ENTER_FRAME, this.onFrameUpdate);
			
			if (this.life >= 10)
				return new WindowLevelWin(this, 3);
			
			if (this.life >= 4)
				return new WindowLevelWin(this, 2);
			
			return new WindowLevelWin(this, 1);
		}
		
		/**
		 * 以失败结束这场战斗。
		 */
		public function defeat():WindowLevelDefeat
		{
			this.levelState = LevelState.OVER;
			
			this.pause();
			this.hideAllGUIs();
			this.hideInfoPanel();
			this.hidePointers();
			this.unselectAllSpells();
			
			this.removeEventListener(Event.ENTER_FRAME, this.onFrameUpdate);
			
			return new WindowLevelDefeat(this);
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	FRAME_UPDATERS
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		public function updateFrameEnemies():void
		{
			for each (var p:Enemy in this.dEnemies)
			{
				p && p.updateFrame();
			}
			p = null;
		}
		
		/**
		 * 更新所有实体。
		 */
		public function updateFrameEntities():void
		{
			var entity:LevelEntity;
			
			for (var i:int = 0; i < this.entities.numChildren; i++)
			{
				entity = this.entities.getChildAt(i) as LevelEntity;
				
				for (var j:int = 0; j < i; j++)
				{
					if (this.entities.getChildAt(j).y > entity.y)
						this.entities.swapChildrenAt(i, j);
				}
			}
			
			entity = null;
		}
		
		public function updateFrameSoldiers():void
		{
			for each (var p:Soldier in this.dSoldiers)
			{
				p && p.updateFrame();
			}
			p = null;
		}
		
		public function updateFrameTowers():void
		{
			for each (var p:LevelEntity in this.dTowers)
			{
				p && p.updateFrame();
			}
			p = null;
		}
		
		/**
		 * 更新所有子弹。
		 */
		public function updateFrameBullets():void
		{
			for each (var p:LevelEntity in this.dBullets)
			{
				p && p.updateFrame();
			}
			p = null;
		}
		
		/**
		 * 更新所有用户界面。
		 */
		public function updateFrameGUIs():void
		{
			for (var i:int = 0; i < this.gui.numChildren; i++)
			{
				LevelEntity(this.gui.getChildAt(i)).updateFrame();
			}
			
			for (i = 0; i < this.spells.numChildren; i++)
			{
				LevelEntity(this.spells.getChildAt(i)).updateFrame();
			}
			
			for (i = 0; i < this.notifications.numChildren; i++)
			{
				LevelEntity(this.notifications.getChildAt(i)).updateFrame();
			}
		}
		
		/**
		 * 更新所有波次。
		 */
		public function updateFrameWaves():void
		{
			if (this.levelState == LevelState.PRE_BATTLE || this.levelState == LevelState.BATTLE)
			{
				Wave(this.waves[this.currentWave]).updateFrame();
				
				this.levelInfo.showWave(this.wave, this.totalWaves);
				this.currentWave == this.totalWaves && (this.levelState = LevelState.WAVE_DONE);
			}
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	EVENT_HANDLERS
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		public function onWaveStart():void
		{
			if (this.currentWave == 0)
			{
				this.spellFireball.enable();
				this.spellReinforcement.enable();
			}
		}
		
		/**
		 * 重复执行。
		 */
		protected function onFrameUpdate(event:Event):void
		{
			if (this.levelState == LevelState.OVER)
				return;
			
			if (this.isPaused)
				return;
			
			this.updateFrameEnemies();
			this.updateFrameSoldiers();
			this.updateFrameTowers();
			this.updateFrameBullets();
			this.updateFrameEntities();
			this.updateFrameGUIs();
			this.updateFrameWaves();
			
			this.stage.focus == this.stage || (this.stage.focus = this.stage);
			
			if (this.levelState != LevelState.PRE_WIN)
				return;
			
			if (this._preWinCounter < this._preWinTime)
			{
				this._preWinCounter++;
				return;
			}
			this.win();
		}
		
		protected function onStageDeactivate(event:Event):void
		{
			if (this.levelState == LevelState.OVER)
				return;
			
			this.pause(true);
		}
		
		protected function onStageActivate(event:Event):void
		{
			if (this.levelState == LevelState.OVER)
				return;
			
			this.unpause();
		}
		
		/**
		 * 鼠标单击背景。
		 */
		protected function onBackgroundClick(event:MouseEvent):void
		{
			if (this.pointer)
			{
				this.pointer.select();
			}
			else
			{
				this.hideAllGUIs();
				this.hidePointers();
				this.hideInfoPanel();
			}
		}
		
		protected function onStageKeyUp(event:KeyboardEvent):void
		{
			if (this.levelState == LevelState.OVER)
				return;
			
			switch (event.keyCode)
			{
				case Keyboard.SPACE: 
					this.hideAllGUIs();
					this.hidePointers();
					this.hideInfoPanel();
					this.unselectAllSpells();
					break;
				
				case Keyboard.NUMBER_1: 
				case Keyboard.NUMPAD_1: 
					if (this.pointer is MouseRallyPoint)
					{
						this.hideTowerRange();
						this.hidePointers();
						this.levelInfo.showLevelInfo();
					}
					
					this.spellFireball.select(true);
					break;
				
				case Keyboard.NUMBER_2: 
				case Keyboard.NUMPAD_2: 
					if (this.pointer is MouseRallyPoint)
					{
						this.hideTowerRange();
						this.hidePointers();
						this.levelInfo.showLevelInfo();
					}
					
					this.spellReinforcement.select(true);
					break;
			}
		}
		
		protected function onCashUpdate():void
		{
			this.levelInfo.showCash(this.cash);
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	DESTROYER
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		override public function destroy():void
		{
			TweenMax.killChildTweensOf(this);
			
			if (this.stage)
			{
				this.stage.removeEventListener(Event.DEACTIVATE, this.onStageDeactivate);
				this.stage.removeEventListener(Event.ACTIVATE, this.onStageActivate);
				this.stage.removeEventListener(KeyboardEvent.KEY_UP, this.onStageKeyUp);
			}
			this.background.removeEventListener(MouseEvent.CLICK, this.onBackgroundClick);
			this.removeEventListener(Event.ENTER_FRAME, this.onFrameUpdate);
			
			this.hideAllGUIs();
			this.hideInfoPanel();
			this.hidePointers();
			this.unselectAllSpells();
			
			while (this.gui.numChildren > 0)
			{
				LevelEntity(this.gui.getChildAt(0)).destroy();
			}
			while (this.notifications.numChildren > 0)
			{
				LevelEntity(this.gui.getChildAt(0)).destroy();
			}
			while (this.spells.numChildren > 0)
			{
				LevelEntity(this.spells.getChildAt(0)).destroy();
			}
			while (this.bullets.numChildren > 0)
			{
				LevelEntity(this.bullets.getChildAt(0)).destroy();
			}
			while (this.entities.numChildren > 0)
			{
				LevelEntity(this.entities.getChildAt(0)).destroy();
			}
			while (this.towerHolders.numChildren > 0)
			{
				LevelEntity(this.towerHolders.getChildAt(0)).destroy();
			}
			
			this.towerRange = null;
			this.towerRangeNew = null;
			this.removeChild(this.background);
			this.background = null;
			this.removeChild(this.bullets);
			this.bullets = null;
			this.removeChild(this.entities);
			this.entities = null;
			this.removeChild(this.gui);
			this.gui = null;
			this.removeChild(this.towerHolders);
			this.towerHolders = null;
			this.removeChild(this.notifications);
			this.notifications = null;
			this.removeChild(this.spells);
			this.spells = null;
			this.removeChild(pauseTip);
			this.pauseTip = null;
			
			this.paths = null;
			
			this.waves.length = 0;
			this.waves = null;
			
			super.destroy();
		}
	
	}

}