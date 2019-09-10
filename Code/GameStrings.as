/**
 * 2016/1/16 12:45
 *
 * 游戏中出现的字符串
 */
package
{
	
	public class GameStrings
	{
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	STATIC_PROPERTIES_AND_ACCESSORS
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
		
		static public const MODE_CAMPAIGN_TITLE:String = "Campaign";
		static public const MODE_CAMPAIGN_DESCRIPTION:String = "Normal battle settings.";
		
		static public const MODE_IRON_TITLE:String = "Ironic";
		static public const MODE_IRON_DESCRIPTION:String = "A test for the ultimate defender, the ironic challenge will take your tactical skills to the limit.";
		
		static public const LEVEL_INFO_CASH_TITLE:String = "Gold";
		static public const LEVEL_INFO_CASH_DESCRIPTION:String = "Use gold to buy and build defensive towers. You can earn gold by killing enemies.";
		
		static public const LEVEL_INFO_LIFE_TITLE:String = "Life";
		static public const LEVEL_INFO_LIFE_DESCRIPTION:String = "Don't let enemies escape, or they will cost lives.";
		
		static public const LEVEL_INFO_ENEMYS_TITLE:String = "Enemies";
		static public const LEVEL_INFO_ENEMYS_DESCRIPTION:String = "The number of enemies appearing/ready to appear.";
		
		static public const TOWER_INFO_DAMAGE_TITLE:String = "Physical Damage";
		static public const TOWER_INFO_DAMAGE_DESCRIPTION:String = "The range of damage per attack. The damage is affected by targets' armor level.";
		
		static public const TOWER_INFO_MAGIC_DAMAGE_TITLE:String = "Magic Damage";
		static public const TOWER_INFO_MAGIC_DAMAGE_DESCRIPTION:String = "The range of magic damage per attack. The damage is affected by targets' magic resistance level.";
		
		static public const TOWER_INFO_LIFE_TITLE:String = "Health";
		static public const TOWER_INFO_LIFE_DESCRIPTION:String = "The maximum total damage a unit can suffer.";
		
		static public const TOWER_INFO_RANGE_TITLE:String = "Range";
		static public const TOWER_INFO_RANGE_DESCRIPTION:String = "The range of firing.";
		
		static public const TOWER_INFO_RELOAD_TITLE:String = "Cooldown";
		static public const TOWER_INFO_RELOAD_DESCRIPTION:String = "The interval of firing.";
		
		static public const SOLDIER_INFO_LIFE_TITLE:String = "Health";
		static public const SOLDIER_INFO_LIFE_DESCRIPTION:String = "The total damage this unit can suffer.";
		
		static public const SOLDIER_INFO_ARMOR_TITLE:String = "Armor";
		static public const SOLDIER_INFO_ARMOR_DESCRIPTION:String = "Armored units take less physical damage.";
		
		static public const SOLDIER_INFO_MAGIC_ARMOR_TITLE:String = "Magic Resistance";
		static public const SOLDIER_INFO_MAGIC_ARMOR_DESCRIPTION:String = "Units have magic resistance take less magic damage.";
		
		static public const SOLDIER_INFO_RESPAWN_TITLE:String = "Respawn";
		static public const SOLDIER_INFO_RESPAWN_DESCRIPTION:String = "The interval between death and new soldier to appear.";
		
		static public const ENEMY_INFO_LOSE_TITLE:String = "Cost";
		static public const ENEMY_INFO_LOSE_DESCRIPTION:String = "The number of lives the enemy will cost when escaping.";
		/**
		 * [静态] 箭塔描述。
		 */
		static public const TOWER_ARCHER_DESCRIPTION:String = "Archers ready to strike at one enemy from a long distance.";
		/**
		 * [静态] 箭塔升级描述。
		 */
		static public const TOWER_ARCHER_UPGRADE_DESCRIPTION:String = "Archers can deal more damage, and their longbows have a longer attack range.";
		
		/**
		 * [静态] 炮塔描述。
		 */
		static public const TOWER_ARTILLERY_DESCRIPTION:String = "Bombards ground enemies dealing high area damage.";
		/**
		 * [静态] 炮塔升级描述。
		 */
		static public const TOWER_ARTILLERY_UPGRADE_DESCRIPTION:String = "Enhenced artillery blasts an even larger area and causes a higher damage.";
		
		static public const TOWER_MAGE_DESCRIPTION:String = "Mages cast armor piercing bolts at one enemy, ignoring any physical protection."
		
		static public const TOWER_MAGE_UPGRADE_DESCRIPTION:String = "Wizards cast enhenced bolts, which can tear through armor, flesh and bone.";
		
		static public const TOWER_BARRACK_DESCRIPTION:String = "Trains militia, tough soldiers that block and damage your enemies.";
		
		static public const TOWER_BARRACK_UPGRADE_DESCRIPTION:String = "Soldiers are better trained and equipped than basic militia. They can become the backbone of a good army.";
		/**
		 * [静态] 塔升级标题。
		 */
		static public const TOWER_UPGRADE_TITLE:String = "Upgrade";
		
		/**
		 * [静态] 塔拆除标题。
		 */
		static public const TOWER_SELL_TITLE:String = "Demolish";
		/**
		 * [静态] 塔拆除描述。
		 */
		static public const TOWER_SELL_DESCRIPTION:String = "Sell this tower and get a refund.";
		
		static public const TOWER_RALLY_POINT_TITLE:String = "Command the Troops";
		
		static public const TOWER_RALLY_POINT_DESCRIPTION:String = "Adjust the soldiers' rally point to make them defend a different area."
		
		/**
		 * [静态] 塔锁定标题。
		 */
		static public const TOWER_LOCKED_TITLE:String = "Locked!";
		/**
		 * [静态] 塔锁定描述。
		 */
		static public const TOWER_LOCKED_DESCRIPTION:String = "This item is currently not available.";
		
		static public const FIRST_WAVE_TITLE:String = "First Wave";
		static public const FIRST_WAVE_DESCRIPTION:String = "Click to start the battle!";
		
		/**
		 * [静态] 下一波标题。
		 */
		static public const NEXT_WAVE_TITLE:String = "Next Wave";
		/**
		 * [静态] 下一波描述。
		 */
		static public const NEXT_WAVE_DESCRIPTION:String = "Click to start the next wave instantly.";
		static public const NEXT_WAVE_REWARD_DESCRIPTION:String = "You can get some rewards of gold and spell cooldown by starting next wave earlier.";
		
		static public const SUPER_WAVE_TITLE:String = "Super Wave";
		static public const SUPER_WAVE_WARNING_DESCRIPTION:String = "Unknown number of enemies";
		
		static public const SPELL_REINFORCEMENT_TITLE:String = "Call Reinforcements";
		static public const SPELL_REINFORCEMENT_DESCRIPTION:String = "You can summon troops to help you in the battlefield.\nReinforcements are free and you can call them every 15 seconds.";
		
		static public const SPELL_FIREBALL_TITLE:String = "Rain of Fire";
		static public const SPELL_FIREBALL_DESCRIPTION:String = "Blast your enemies with fire from the skies!\nRain of fire is best saved for an emergency or a great opportunity since it has a very long cooldown.";
		
		static public const SPELL_CANCEL_DESCRIPTION:String = "Click here or press space-bar to cancel.";
		
		static public const TRUE_DAMAGE_TITLE:String = "Fire Damage";
		static public const TRUE_DAMAGE_DESCRIPTION:String = "The fire damage ignore all resistance of targets.";
		
		static public const SETTING_RESET_PROGRESS_DESCRIPTION:String = "Reset game progress.";
		
		static public const SETTING_QUALITY_TITLE:String = "Display Quality";
		
		static public const SETTING_FULL_SCREEN_TITLE:String = "Full-Screen Display";
		
		static public const SETTING_AUTO_PAUSE_TITLE:String = "Auto-Pause When Clicked Outside";
		
		static public const SETTING_SHOW_PANEL_TITLE:String = "Show Ingame Information Panel";
	
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	STATIC_METHODS
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
	
	}

}