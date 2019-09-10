/**
 * 2016/1/16 14:20
 *
 * 关卡信息面板
 */
package
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Strong;
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.utils.getQualifiedClassName;
	
	public class LevelInfo extends LevelEntity
	{
		
		/// /// /// /// ///
		///    STATIC   ///
		/// /// /// /// ///
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	STATIC_PROPERTIES_AND_ACCESSORS
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
		
		/**
		 * [静态] 指示面板正在显示关卡信息。
		 */
		static public const SHOW_LEVEL_INFO:String = "level";
		/**
		 * [静态] 指示面板正在显示塔信息。
		 */
		static public const SHOW_TOWER_INFO:String = "tower";
		static public const SHOW_SOLDIER_INFO:String = "soldier";
		/**
		 * [静态] 指示面板正在显示敌人信息。
		 */
		static public const SHOW_ENEMY_INFO:String = "enemy";
		static public const SHOW_SPELL_INFO:String = "spell";
		/**
		 * [静态] 指示面板正在显示用户定义的信息。
		 */
		static public const SHOW_PRINTING:String = "printing";
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	STATIC_METHODS
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
		
		/// /// /// /// ///
		///   INSTANCE	///
		/// /// /// /// ///
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	CONSTRUCTOR
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
		
		/**
		 * 创建新的 LevelInfo 对象。
		 *
		 * @param	level - 所属的关卡对象。
		 * @param	x - 该对象的 X 坐标位置。默认为水平居中。
		 * @param	y - 该对象的 Y 坐标位置。默认为靠下。
		 */
		public function LevelInfo(level:Level, x:int, y:int)
		{
			super(x, y, level.gui);
			
			this.y += 50;
			this.visible = false;
			this.alpha = 0;
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	PROPERTIES
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
		
		public var symbol0:MovieClip;
		public var symbol1:LevelInfoIcon;
		public var symbol2:LevelInfoIcon;
		public var symbol3:LevelInfoIcon;
		public var symbol4:LevelInfoIcon;
		public var symbol5:LevelInfoIcon;
		/**
		 * 最左侧的面板文本框。
		 */
		public var txt0:TextField;
		/**
		 * 主面板左侧文本框。
		 */
		public var txt1:TextField;
		public var txt2:TextField;
		/**
		 * 主面板中央文本框。
		 */
		public var txt3:TextField;
		public var txt4:TextField;
		/**
		 * 主面板右侧文本框。
		 */
		public var txt5:TextField;
		/**
		 * 获取或设置当前所显示的内容状态。
		 */
		public var showingMode:String;
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	ACCESSORS
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	INITIALIZATION
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
		
		override public function init():void
		{
			super.init();
			
			this.symbol0.stop();
			
			this.symbol1.visible = true;
			this.symbol2.visible = false;
			this.symbol3.visible = true;
			this.symbol4.visible = false;
			this.symbol5.visible = false;
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	METHODS
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
		
		public function fadein():void
		{
			TweenMax.to(this, 0.7, {ease: Strong.easeOut, y: "-50", autoAlpha: 1});
		}
		
		/**
		 * 显示自定义的信息文本。
		 *
		 * @param	string - 要显示的文本。
		 */
		public function print(string:String = ""):void
		{
			this.showingMode = LevelInfo.SHOW_PRINTING;
			this.txt1.text = string;
			this.txt2.text = "";
			this.txt3.text = "";
			this.symbol0.gotoAndStop("level");
		}
		
		/**
		 * 显示关卡信息。
		 *
		 * @param	level - 所属的关卡。
		 */
		public function showLevelInfo(level:Level = null):void
		{
			if (level)
				this.level = level;
			
			this.showingMode = LevelInfo.SHOW_LEVEL_INFO;
			
			this.txt0.text = "Wave " + (this.level.wave + 1) + " of " + this.level.totalWaves;
			this.txt1.text = "" + this.level.cash;
			this.txt2.text = "";
			this.txt3.text = "" + this.level.life;
			this.txt4.text = "";
			
			this.symbol1.visible = true;
			this.symbol2.visible = false;
			this.symbol3.visible = true;
			this.symbol4.visible = false;
			
			this.symbol0.gotoAndStop("level");
			this.symbol1.gotoAndStop("cash");
			this.symbol3.gotoAndStop("life");
			this.symbol5.gotoAndStop("enemy");
			
			this.showEnemies(this.level.enemyOnStage, this.level.enemyIdle);
		}
		
		/**
		 * 显示波次信息。仅当 showingMode 属性为 SHOW_LEVEL_INFO 时有效。
		 *
		 * @param	currentWave - 当前所处的波次。
		 * @param	totalWaves - 关卡的总波次。
		 */
		public function showWave(currentWave:int, totalWaves:int):void
		{
			if (this.showingMode == LevelInfo.SHOW_LEVEL_INFO)
				this.txt0.text = "Wave " + (currentWave + 1) + " of " + totalWaves;
		}
		
		/**
		 * 显示金钱数。仅当 showingMode 属性为 SHOW_LEVEL_INFO 时有效。
		 *
		 * @param	cash - 关卡金钱数。
		 */
		public function showCash(cash:int):void
		{
			if (this.showingMode == LevelInfo.SHOW_LEVEL_INFO)
				this.txt1.text = "" + cash;
		}
		
		/**
		 * 显示生命数。仅当 showingMode 属性为 SHOW_LEVEL_INFO 时有效。
		 *
		 * @param	life - 关卡生命数。
		 */
		public function showLife(life:int):void
		{
			if (this.showingMode == LevelInfo.SHOW_LEVEL_INFO)
				this.txt3.text = "" + life;
		}
		
		/**
		 * 显示当前正在活动的敌人数量及即将出现的敌人数量。
		 * 仅当 showingMode 属性为 SHOW_LEVEL_INFO 时有效。
		 *
		 * @param	enemyOnStage - 当前正在活动的敌人数量。
		 * @param	enemyIdle - 即将出现的敌人数量。
		 */
		public function showEnemies(enemyOnStage:int, enemyIdle:int):void
		{
			if (this.showingMode != LevelInfo.SHOW_LEVEL_INFO)
				return;
			
			if (enemyOnStage == 0 && enemyIdle == 0)
			{
				this.txt5.text = "";
				this.symbol5.visible && (this.symbol5.visible = false);
				
				return;
			}
			
			if (this.level.levelMode == LevelMode.IRON)
				this.txt5.text = "" + enemyOnStage + "+(?)";
			else
				this.txt5.text = "" + enemyOnStage + "+(" + enemyIdle + ")";
			
			this.symbol5.visible || (this.symbol5.visible = true);
		}
		
		/**
		 * 显示塔信息。
		 *
		 * @param	tower - 要显示信息的塔。
		 */
		public function showTowerInfo(tower:Tower):void
		{
			this.showingMode == LevelInfo.SHOW_TOWER_INFO || this.level.hideInfoPanel();
			
			this.showingMode = LevelInfo.SHOW_TOWER_INFO;
			
			if (tower.towerName.length > 10)
				this.txt0.text = tower.towerName.substr(0, tower.towerName.indexOf(" "));
			else
				this.txt0.text = tower.towerName;
			
			var soldierInfo:GameSettingItem;
			
			if (tower is TowerBarrack)
			{
				soldierInfo = TowerBarrack(tower).getSoldierInfo()
				
				this.txt1.text = "" + soldierInfo.hp;
				this.txt2.text = "" + soldierInfo.minDamage + "~" + soldierInfo.maxDamage;
				this.txt3.text = "";
				this.txt4.text = "" + GameSettings.getArmorGrade(soldierInfo.armor);
				this.txt5.text = "" + int(soldierInfo.respawn / 30 * 100 + 0.5) / 100 + " s";
				
				this.symbol1.visible = true;
				this.symbol2.visible = true;
				this.symbol3.visible = false;
				this.symbol4.visible = true;
				this.symbol5.visible = true;
				
				this.symbol0.gotoAndStop(getQualifiedClassName(tower));
				this.symbol1.gotoAndStop("life");
				this.symbol2.gotoAndStop("damage");
				this.symbol4.gotoAndStop("armor");
				this.symbol5.gotoAndStop("respawn");
			}
			else
			{
				this.txt1.text = "" + tower.towerMinDamage + "~" + tower.towerMaxDamage;
				this.txt2.text = "";
				this.txt3.text = "" + GameSettings.getRangeGrade(tower.towerRange);
				this.txt4.text = "";
				this.txt5.text = "" + GameSettings.getReloadGrade(tower.towerReload);
				
				this.symbol1.visible = true;
				this.symbol2.visible = false;
				this.symbol3.visible = true;
				this.symbol4.visible = false;
				this.symbol5.visible = true;
				
				this.symbol0.gotoAndStop(getQualifiedClassName(tower));
				this.symbol1.gotoAndStop(tower is TowerMage ? "magic damage" : "damage");
				this.symbol3.gotoAndStop("range");
				this.symbol5.gotoAndStop("reload");
			}
			
			soldierInfo = null;
		}
		
		public function showSoldierInfo(soldier:Soldier):void
		{
			this.showingMode == LevelInfo.SHOW_SOLDIER_INFO || this.level.hideInfoPanel();
			
			this.showingMode = LevelInfo.SHOW_SOLDIER_INFO;
			
			this.txt0.text = soldier.soldierName;
			this.txt1.text = soldier.soldierHP + "/" + soldier.soldierMaxHP;
			this.txt2.text = soldier.soldierMinDamage + "~" + soldier.soldierMaxDamage;
			this.txt3.text = "";
			this.txt4.text = GameSettings.getArmorGrade(soldier.soldierArmor);
			this.txt5.text = soldier.soldierRespawn > 0 ? int(soldier.soldierRespawn / 30 * 100 + 0.5) / 100 + "s" : "-";
			
			this.symbol1.visible = true;
			this.symbol2.visible = true;
			this.symbol3.visible = false;
			this.symbol4.visible = true;
			this.symbol5.visible = true;
			
			this.symbol0.gotoAndStop("Soldier");
			this.symbol1.gotoAndStop("life");
			this.symbol2.gotoAndStop("damage");
			this.symbol4.gotoAndStop("armor");
			this.symbol5.gotoAndStop("respawn");
		}
		
		/**
		 * 显示敌人信息。
		 *
		 * @param	enemy - 要显示信息的敌人。
		 */
		public function showEnemyInfo(enemy:Enemy):void
		{
			this.showingMode == LevelInfo.SHOW_ENEMY_INFO || this.level.hideInfoPanel();
			
			this.showingMode = LevelInfo.SHOW_ENEMY_INFO;
			
			this.txt0.text = enemy.enemyName;
			this.txt1.text = enemy.enemyHP + "/" + enemy.enemyMaxHP;
			this.txt2.text = enemy.enemyMaxDamage > 0 ? (enemy.enemyMinDamage + "~" + enemy.enemyMaxDamage) : "None";
			this.txt3.text = "";
			
			if (enemy.enemyArmor >= enemy.enemyMagicArmor)
			{
				this.txt4.text = GameSettings.getArmorGrade(enemy.enemyArmor);
				this.symbol4.gotoAndStop("armor");
			}
			else
			{
				this.txt4.text = GameSettings.getArmorGrade(enemy.enemyMagicArmor);
				this.symbol4.gotoAndStop("magic armor");
			}
			
			this.txt5.text = "" + enemy.enemyLoseLife;
			
			this.symbol1.visible = true;
			this.symbol2.visible = true;
			this.symbol3.visible = false;
			this.symbol4.visible = true;
			this.symbol5.visible = true;
			
			this.symbol0.gotoAndStop("level");
			this.symbol1.gotoAndStop("life");
			this.symbol2.gotoAndStop("damage");
			this.symbol5.gotoAndStop("enemy");
		}
		
		public function showSpellInfo(spell:Spell):void
		{
			this.showingMode = LevelInfo.SHOW_SPELL_INFO;
			
			switch (getQualifiedClassName(spell))
			{
				case "SpellFireball": 
					this.symbol1.visible = true;
					this.symbol2.visible = false;
					this.symbol3.visible = false;
					this.symbol4.visible = false;
					this.symbol5.visible = false;
					
					this.symbol0.gotoAndStop("Fireball");
					this.symbol1.gotoAndStop("fire damage");
					
					this.txt0.text = spell.spellName;
					this.txt1.text = spell.fireballMinDamage + "~" + spell.fireballMaxDamage;
					this.txt2.text = "";
					this.txt3.text = "";
					this.txt4.text = "";
					this.txt5.text = "";
					break;
				
				case "SpellReinforcement": 
					this.symbol1.visible = true;
					this.symbol2.visible = true;
					this.symbol3.visible = false;
					this.symbol4.visible = true;
					this.symbol5.visible = true;
					
					this.symbol0.gotoAndStop("Farmer");
					this.symbol1.gotoAndStop("life");
					this.symbol2.gotoAndStop("damage");
					this.symbol4.gotoAndStop("armor");
					this.symbol5.gotoAndStop("respawn");
					
					this.txt0.text = spell.spellName;
					this.txt1.text = "" + spell.reinforcementHP;
					this.txt2.text = spell.reinforcementMinDamage + "~" + spell.reinforcementMaxDamage;
					this.txt3.text = "";
					this.txt4.text = GameSettings.getArmorGrade(spell.reinforcementArmor);
					this.txt5.text = "-";
					break;
				
				default: 
					throw new Error("此技能无效！");
			}
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	FRAME_UPDATER
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	EVENT_HANDLERS
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	DESTROYER
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
		
		override public function destroy():void
		{
			TweenMax.killChildTweensOf(this);
			
			this.removeChild(this.txt0);
			this.txt0 = null;
			this.removeChild(this.txt1);
			this.txt1 = null;
			this.removeChild(this.txt2);
			this.txt2 = null;
			this.removeChild(this.txt3);
			this.txt3 = null;
			this.removeChild(this.txt4);
			this.txt4 = null;
			this.removeChild(this.txt5);
			this.txt5 = null;
			
			this.removeChild(this.symbol0);
			this.symbol0 = null;
			this.removeChild(this.symbol1);
			this.symbol1 = null;
			this.removeChild(this.symbol2);
			this.symbol2 = null;
			this.removeChild(this.symbol3);
			this.symbol3 = null;
			this.removeChild(this.symbol4);
			this.symbol4 = null;
			this.removeChild(this.symbol5);
			this.symbol5 = null;
			
			super.destroy();
		}
	
	}

}