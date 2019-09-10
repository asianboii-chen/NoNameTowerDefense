package 
{
	
	public class Levels 
	{
		
		static public const LEVELS:Array = [
			new LevelSettingItem(new Node(120, 482), 0, [1], 250, 1, 1, 1, 1),
			new LevelSettingItem(new Node(270, 335), 1, [2], 375, 2, 2, 2, 2),
			new LevelSettingItem(new Node(222, 155), 2, [], 520, 3, 3, 3, 3)
		];
		
		static public const LEVEL_IRONS:Array = [
			new LevelIronSettingItem(300, 0, 1, 0, 1),
			new LevelIronSettingItem(450, 2, 2, 0, 0),
			new LevelIronSettingItem(660, 3, 0, 3, 0)
		];
		
	}

}