package 
{
	
	public class LevelIronWaves 
	{
		
		static public const LEVEL_IRON_WAVES:Array =
		[
			
	// ==== LEVEL 1 =================================================================================
	//{
		
		[new Wave(
		[
		new WaveSpawn(EnemySmall, 8, 0, 15, 0),
		new WaveSpawn(EnemySmall, 12, 600, 13, 0),
		new WaveSpawn(EnemySmall, 18, 1200, 10, 0),
		new WaveSpawn(EnemyMedium, 8, 1800, 25, 0)
		], -1)
		],
			
	//}
	// ==== LEVEL 2 =================================================================================
	//{
			
		[new Wave(
		[
		new WaveSpawn(EnemySmall, 32, 30, 75, 1),
		new WaveSpawn(EnemySmall, 16, 1225, 75, 1),
		new WaveSpawn(EnemySmall, 8, 1850, 75, 1),
		new WaveSpawn(EnemyRunner, 4, 0, 45, 0),
		new WaveSpawn(EnemyRunner, 5, 360, 35, 0),
		new WaveSpawn(EnemyRunner, 6, 750, 25, 0),
		new WaveSpawn(EnemyRunner, 7, 1200, 15, 0),
		new WaveSpawn(EnemyRunner, 8, 1700, 5, 0),
		new WaveSpawn(EnemyRunner, 9, 2200, 5, 0)
		], -1)
		],
			
	//}
	// ==== LEVEL 3 =================================================================================
	//{
			
		[
			new Wave(
			[
				new WaveSpawn(EnemyMedium, 8, 0, 120, 0),
				new WaveSpawn(EnemyMedium, 8, 960, 90, 0),
				new WaveSpawn(EnemyLarge, 7, 1320, 160, 0, WaveSpawnPathSide.CENTER),
				
				new WaveSpawn(EnemySmall, 5, 60, 15, 1),
				new WaveSpawn(EnemySmall, 6, 600, 15, 1),
				new WaveSpawn(EnemySmall, 7, 1200, 15, 1),
				new WaveSpawn(EnemySmall, 8, 1800, 15, 1),
				new WaveSpawn(EnemySmall, 9, 2400, 15, 1),
				
				new WaveSpawn(EnemyRunner, 24, 0, 180, 2),
				new WaveSpawn(EnemyFlying, 24, 0, 180, 2)
			],
			-1)
		]
			
	//}
		];
		
	}

}