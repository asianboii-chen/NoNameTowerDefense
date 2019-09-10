package
{
	import flash.display.Sprite;
	
	public class SpellFireball extends Spell
	{
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	CONSTRUCTOR
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		public function SpellFireball(level:Level, x:int, y:int, spellLevel:int = 1)
		{
			var info:GameSettingItem = level.game.gameSettings["spellFireball" + spellLevel];
			var panel:Array = [];
			
			panel[0] = [GameStrings.SPELL_FIREBALL_TITLE, 5, 2, 0x2693FF, 20, true];
			panel[1] = ["Spell", 2, 1, 0x3737FF, 13];
			panel[2] = ["Hotkey: [1]", 1, 1, 0x00F23D, 10];
			panel[3] = "----";
			panel[4] = [GameStrings.SPELL_FIREBALL_DESCRIPTION, 5, 5, 0xCCCCCC, 15];
			panel[5] = "----";
			panel[6] = ["Number of Fireballs: " + level.game.gameSettings.spellFireball1.hp + "\nDamage: " + level.game.gameSettings.spellFireball1.minDamage + "~" + level.game.gameSettings.spellFireball1.maxDamage + "\nSplash Range: " + level.game.gameSettings.spellFireball1.range + "\nCooldown: " + int(level.game.gameSettings.spellFireball1.respawn * 3.4) / 100 + "s", 4, 4, 0x01AAB8, 12];
			
			super(level, x, y, info, panel, spellLevel);
			
			this.fireballNumber = info.hp;
			this.fireballRange = info.range;
			this.fireballReload = info.reload;
			this.fireballSpeed = info.speed;
			this.fireballMinDamage = info.minDamage;
			this.fireballMaxDamage = info.maxDamage;
			this.fireballRangeSplash = info.rangeSplash;
			this.fireballAdjustX = info.adjustX;
			this.fireballAdjustY = info.adjustY;
			
			panel = null;
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	PROPERTIES
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		public var iLight:Sprite;
		public var iProgressBar:Sprite;
		public var fireballSpeed:Number;
		public var fireballMinDamage:int;
		public var fireballMaxDamage:int;
		public var fireballNumber:int;
		public var fireballRange:int;
		public var fireballRangeSplash:int;
		public var fireballReload:int;
		public var fireballAdjustX:int;
		public var fireballAdjustY:int;
		
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
			if (this.level.spellReinforcement.selected)
				this.level.spellReinforcement.unselect();
			
			super.select();
			
			this.selected && new MouseFireball(this, useHotkey);
		}
		
		override public function fire(position:Node):void
		{
			new FireballControler(position, this);
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