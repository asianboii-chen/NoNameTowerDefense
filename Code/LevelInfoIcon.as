package
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class LevelInfoIcon extends MovieClip
	{
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	CONSTRUCTOR
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		public function LevelInfoIcon()
		{
			super();
			
			this.buttonMode = true;
			
			this.stop();
			
			this.addEventListener(Event.ADDED_TO_STAGE, this.init, false, 0, true);
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	PROPERTIES
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		public var level:Level;
		public var levelInfo:LevelInfo;
		public var textTitle:String;
		public var textContent:String;
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	ACCESSORS
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	INITIALIZATION
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		protected function init(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, this.init);
			
			this.level = this.parent.parent.parent as Level;
			this.levelInfo = this.parent as LevelInfo;
			
			this.levelInfo.showingMode == LevelInfo.SHOW_LEVEL_INFO || this.levelInfo.showLevelInfo(this.level);
			
			this.addEventListener(MouseEvent.ROLL_OVER, this.onIconRollOver, false, 0, true);
			this.addEventListener(MouseEvent.ROLL_OUT, this.onIconRollOut, false, 0, true);
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	METHODS
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		override public function gotoAndStop(frame:Object, scene:String = null):void
		{
			super.gotoAndStop(frame, scene);
			
			var title:String;
			var content:String;
			
			this.levelInfo || (this.levelInfo = this.parent as LevelInfo);
			
			switch (this.levelInfo.showingMode)
			{
				case LevelInfo.SHOW_LEVEL_INFO: 
					switch (this.currentLabel)
					{
						case "cash": 
							title = GameStrings.LEVEL_INFO_CASH_TITLE;
							content = GameStrings.LEVEL_INFO_CASH_DESCRIPTION;
							break;
						
						case "life": 
							title = GameStrings.LEVEL_INFO_LIFE_TITLE;
							content = GameStrings.LEVEL_INFO_LIFE_DESCRIPTION;
							break;
						
						case "enemy": 
							title = GameStrings.LEVEL_INFO_ENEMYS_TITLE;
							content = GameStrings.LEVEL_INFO_ENEMYS_DESCRIPTION;
							break;
					}
					break;
				
				case LevelInfo.SHOW_TOWER_INFO: 
					switch (this.currentLabel)
					{
						case "damage": 
							title = GameStrings.TOWER_INFO_DAMAGE_TITLE;
							content = GameStrings.TOWER_INFO_DAMAGE_DESCRIPTION;
							break;
						
						case "magic damage": 
							title = GameStrings.TOWER_INFO_MAGIC_DAMAGE_TITLE;
							content = GameStrings.TOWER_INFO_MAGIC_DAMAGE_DESCRIPTION;
							break;
						
						case "range": 
							title = GameStrings.TOWER_INFO_RANGE_TITLE;
							content = GameStrings.TOWER_INFO_RANGE_DESCRIPTION;
							break;
						
						case "reload": 
							title = GameStrings.TOWER_INFO_RELOAD_TITLE;
							content = GameStrings.TOWER_INFO_RELOAD_DESCRIPTION;
							break;
						
						case "life": 
							title = GameStrings.TOWER_INFO_LIFE_TITLE;
							content = GameStrings.TOWER_INFO_LIFE_DESCRIPTION;
							break;
						
						case "armor": 
							title = GameStrings.SOLDIER_INFO_ARMOR_TITLE;
							content = GameStrings.SOLDIER_INFO_ARMOR_DESCRIPTION;
							break;
						
						case "respawn": 
							title = GameStrings.SOLDIER_INFO_RESPAWN_TITLE;
							content = GameStrings.SOLDIER_INFO_RESPAWN_DESCRIPTION;
							break;
					}
					break;
				
				default: 
					switch (this.currentLabel)
					{
						case "life": 
							if (this.levelInfo.showingMode != LevelInfo.SHOW_SPELL_INFO)
							{
								title = GameStrings.SOLDIER_INFO_LIFE_TITLE;
								content = GameStrings.SOLDIER_INFO_LIFE_DESCRIPTION;
							}
							else
							{
								title = GameStrings.TOWER_INFO_LIFE_TITLE;
								content = GameStrings.TOWER_INFO_LIFE_DESCRIPTION;
							}
							break;
						
						case "damage": 
							title = GameStrings.TOWER_INFO_DAMAGE_TITLE;
							content = GameStrings.TOWER_INFO_DAMAGE_DESCRIPTION;
							break;
						
						case "fire damage": 
							title = GameStrings.TRUE_DAMAGE_TITLE;
							content = GameStrings.TRUE_DAMAGE_DESCRIPTION;
							break;
						
						case "armor": 
							title = GameStrings.SOLDIER_INFO_ARMOR_TITLE;
							content = GameStrings.SOLDIER_INFO_ARMOR_DESCRIPTION;
							break;
						
						case "magic armor": 
							title = GameStrings.SOLDIER_INFO_MAGIC_ARMOR_TITLE;
							content = GameStrings.SOLDIER_INFO_MAGIC_ARMOR_DESCRIPTION;
							break;
						
						case "enemy": 
							title = GameStrings.ENEMY_INFO_LOSE_TITLE;
							content = GameStrings.ENEMY_INFO_LOSE_DESCRIPTION;
							break;
						
						case "respawn": 
							title = GameStrings.SOLDIER_INFO_RESPAWN_TITLE;
							content = GameStrings.SOLDIER_INFO_RESPAWN_DESCRIPTION;
							break;
					}
			}
			
			this.textTitle = title;
			this.textContent = content;
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	FRAME_UPDATER
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	EVENT_HANDLERS
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		protected function onIconRollOver(event:MouseEvent):void
		{
			var showing:String;
			
			switch (this.levelInfo.showingMode)
			{
				case LevelInfo.SHOW_LEVEL_INFO: 
					showing = "Stage Info";
					break;
				
				case LevelInfo.SHOW_TOWER_INFO: 
					showing = "Tower Info";
					break;
				
				case LevelInfo.SHOW_SOLDIER_INFO: 
					showing = "Soldier Info";
					break;
				
				case LevelInfo.SHOW_ENEMY_INFO: 
					showing = "Enemy Info";
					break;
				
				case LevelInfo.SHOW_SPELL_INFO: 
					showing = "Spell Info";
					break;
				
				default: 
					throw new Error("不支持的值！！");
			}
			
			this.level.showInfoPanel([[this.textTitle, 6, 2, 0xECA511, 20, true], [showing, 2, 3, 0xF2670B, 13], "----", [this.textContent, 5, 5, 0xCCCCCC, 15]]);
			
			showing = null;
		}
		
		protected function onIconRollOut(event:MouseEvent):void
		{
			this.level.hideInfoPanel();
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	DESTROYER
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		public function destroy():void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, this.init);
			this.removeEventListener(MouseEvent.ROLL_OVER, this.onIconRollOver);
			this.removeEventListener(MouseEvent.ROLL_OUT, this.onIconRollOut);
			
			this.stop();
			
			this.parent.removeChild(this);
		}
	
	}

}