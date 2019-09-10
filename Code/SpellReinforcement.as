package
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class SpellReinforcement extends Spell
	{
		
		/// /// /// /// ///
		///    STATIC   ///
		/// /// /// /// ///
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	STATIC_PROPERTIES_AND_ACCESSORS
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
		
		static public const FARMER:int = 1;
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	STATIC_METHODS
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
		
		/// /// /// /// ///
		///   INSTANCE	///
		/// /// /// /// ///
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	CONSTRUCTOR
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		public function SpellReinforcement(level:Level, x:int, y:int, spellLevel:int = 1)
		{
			var info:GameSettingItem = level.game.gameSettings["spellReinforcement" + spellLevel];
			var panel:Array = [];
			
			panel[0] = [GameStrings.SPELL_REINFORCEMENT_TITLE, 5, 2, 0x2693FF, 20, true];
			panel[1] = ["Spell", 2, 1, 0x3737FF, 13];
			panel[2] = ["Hotkey: [2]", 1, 1, 0x00F23D, 10];
			panel[3] = "----";
			panel[4] = [GameStrings.SPELL_REINFORCEMENT_DESCRIPTION, 5, 5, 0xCCCCCC, 15];
			panel[5] = "----";
			panel[6] = ["Health: " + level.game.gameSettings.spellReinforcement1.hp + "\nDamage: " + level.game.gameSettings.spellReinforcement1.minDamage + "~" + level.game.gameSettings.spellReinforcement1.maxDamage + "\nArmor Level: " + GameSettings.getArmorGrade(level.game.gameSettings.spellReinforcement1.armor) + "\nTime Limit: " + int(level.game.gameSettings.spellReinforcement1.loseLife * 3.4) / 100 + "s\nCooldown: " + int(level.game.gameSettings.spellReinforcement1.respawn * 3.4) / 100 + "s", 4, 4, 0x01AAB8, 12];
			
			super(level, x, y, info, panel, spellLevel);
			
			this.reinforcementArmor = info.armor;
			this.reinforcementHP = info.hp;
			this.reinforcementMinDamage = info.minDamage;
			this.reinforcementMaxDamage = info.maxDamage;
			
			panel = null;
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	PROPERTIES
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		public var iLight:Sprite;
		public var iProgressBar:Sprite;
		public var reinforcementArmor:Number;
		public var reinforcementHP:int;
		public var reinforcementMinDamage:int;
		public var reinforcementMaxDamage:int;
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	ACCESSORS
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	INITIALIZATION
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		override public function init():void
		{
			this.light = iLight;
			this.progressBar = iProgressBar;
			
			super.init();
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	METHODS
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		override public function select(useHotkey:Boolean = false):void
		{
			if (this.level.spellFireball.selected)
				this.level.spellFireball.unselect();
			
			super.select();
			
			this.selected && new MouseReinforcement(this, useHotkey);
		}
		
		override public function fire(position:Node):void
		{
			switch (this.spellLevel)
			{
				case SpellReinforcement.FARMER: 
					if (Math.random() < 0.5)
					{
						new ReinforcementFarmer(position.x + 15, position.y + 15, this.level, this.game.gameSettings.spellReinforcement1);
						new ReinforcementFarmer(position.x - 15, position.y - 15, this.level, this.game.gameSettings.spellReinforcement1);
					}
					else
					{
						new ReinforcementFarmer(position.x + 15, position.y - 15, this.level, this.game.gameSettings.spellReinforcement1);
						new ReinforcementFarmer(position.x - 15, position.y + 15, this.level, this.game.gameSettings.spellReinforcement1);
					}
					break;
				
				default: 
					throw new Error("不支持的值！");
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
			this.removeChild(this.iLight);
			this.iLight = null;
			this.removeChild(this.iProgressBar);
			this.iProgressBar = null;
			
			super.destroy();
		}
	
	}

}