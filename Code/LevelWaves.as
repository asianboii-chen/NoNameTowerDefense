/**
 * 2016/1/16 14:40
 * 
 * 关卡波次
 */
package 
{

	public class LevelWaves 
	{
		
		static public const LEVEL_WAVES:Array =
		[
			
	//---- LEVEL 1 ----------------------------------------------------------------------------------
	//{	
			[
				
				new Wave(
				[
					new WaveSpawn(EnemySmall, 3, 60, 100, 0)
				], 
				-1, 200),
				
				new Wave(
				[
					new WaveSpawn(EnemySmall, 3, 0, 90, 0),
					new WaveSpawn(EnemySmall, 3, 450, 90, 0),
				], 
				550, 30),
				
				new Wave(
				[
					new WaveSpawn(EnemySmall, 6, 0, 90, 0),
					new WaveSpawn(EnemyMedium, 1, 610, 0)
				],
				720, 60),
				
				new Wave(
				[
					new WaveSpawn(EnemySmall, 9, 0, 12, 0),
					new WaveSpawn(EnemySmall, 9, 450, 12, 0),
					new WaveSpawn(EnemyMedium, 1, 800, 0, 0)
				], 
				780, 300),
				
				new Wave(
				[
					new WaveSpawn(EnemyMedium, 2, 100, 70, 0),
					new WaveSpawn(EnemyMedium, 2, 800, 70, 0),
				],
				860, 220),
				
				new Wave(
				[
					new WaveSpawn(EnemySmall, 4, 0, 35, 0, WaveSpawnPathSide.CENTER),
					new WaveSpawn(EnemySmall, 4, 0, 35, 0, WaveSpawnPathSide.LEFT_SIDE),
					new WaveSpawn(EnemySmall, 4, 0, 35, 0, WaveSpawnPathSide.RIGHT_SIDE),
					new WaveSpawn(EnemyMedium, 1, 380, 0, 0, WaveSpawnPathSide.CENTER),
					new WaveSpawn(EnemySmall, 4, 600, 35, 0, WaveSpawnPathSide.CENTER),
					new WaveSpawn(EnemySmall, 4, 600, 35, 0, WaveSpawnPathSide.LEFT_SIDE),
					new WaveSpawn(EnemySmall, 4, 600, 35, 0, WaveSpawnPathSide.RIGHT_SIDE),
				],
				1020)
				
			],
	//}
	//---- LEVEL 2 ----------------------------------------------------------------------------------
	//{	
			[
				
				new Wave(
				[
					new WaveSpawn(EnemySmall, 6, 30, 65, 0)
				], 
				-1, 80),
				
				new Wave(
				[
					new WaveSpawn(EnemySmall, 4, 0, 45, 0, WaveSpawnPathSide.LEFT_SIDE),
					new WaveSpawn(EnemyMedium, 1, 0, 0, 0, WaveSpawnPathSide.CENTER),
					new WaveSpawn(EnemySmall, 4, 0, 45, 0, WaveSpawnPathSide.RIGHT_SIDE)
				], 
				850, 150),
				
				new Wave(
				[
					new WaveSpawn(EnemyRunner, 6, 0, 20, 1)
				],
				970, 0),
				
				new Wave(
				[
					new WaveSpawn(EnemyRunner, 8, 0, 15, 1),
					new WaveSpawn(EnemySmall, 11, 30, 15, 0)
				], 
				850, 50),
				
				new Wave(
				[
					new WaveSpawn(EnemyMedium, 4, 100, 180, 0, WaveSpawnPathSide.LEFT_SIDE),
					new WaveSpawn(EnemyMedium, 4, 100, 180, 0, WaveSpawnPathSide.RIGHT_SIDE)
				],
				960, 90),
				
				new Wave(
				[
					new WaveSpawn(EnemyRunner, 3, 0, 45, 0),
					new WaveSpawn(EnemyRunner, 3, 30, 45, 1),
					new WaveSpawn(EnemyRunner, 3, 150, 45, 0),
					new WaveSpawn(EnemyRunner, 3, 180, 45, 1)
				],
				1300, 30),
				
				new Wave(
				[
					new WaveSpawn(EnemyMedium, 4, 0, 120, 0, WaveSpawnPathSide.CENTER),
					new WaveSpawn(EnemySmall, 13, 0, 45, 0, WaveSpawnPathSide.LEFT_SIDE),
					new WaveSpawn(EnemySmall, 13, 0, 45, 0, WaveSpawnPathSide.RIGHT_SIDE)
				],
				630, 120),
				
				new Wave(
				[
					new WaveSpawn(EnemyMedium, 8, 0, 60, 0),
					new WaveSpawn(EnemyRunner, 24, 0, 60, 1),
					new WaveSpawn(EnemySmall, 24, 1100, 12, 0)
				],
				2160)
				
			],
			
	//}
	//---- LEVEL 3 ----------------------------------------------------------------------------------
	//{
			[
				
				new Wave(
				[
					new WaveSpawn(EnemyMedium, 1, 270, 0, 0),
					new WaveSpawn(EnemySmall, 6, 0, 40, 1)
				],
				-1, 90),
				
				new Wave(
				[
					new WaveSpawn(EnemyMedium, 1, 30, 0, 0),
					new WaveSpawn(EnemyRunner, 3, 10, 15, 2),
					new WaveSpawn(EnemyRunner, 3, 120, 15, 2)
				],
				600, 90),
				
				new Wave(
				[
					new WaveSpawn(EnemyMedium, 2, 0, 300, 0),
					new WaveSpawn(EnemySmall, 10, 10, 15, 1),
					new WaveSpawn(EnemySmall, 10, 450, 15, 1)
				],
				760, 180),
				
				new Wave(
				[
					new WaveSpawn(EnemyRunner, 3, 0, 15, 0),
					new WaveSpawn(EnemyRunner, 3, 5, 15, 1),
					new WaveSpawn(EnemyRunner, 3, 10, 15, 2),
					new WaveSpawn(EnemyRunner, 6, 285, 15, 1),
					new WaveSpawn(EnemyRunner, 6, 290, 15, 2)
				],
				930),
				
				new Wave(
				[
					new WaveSpawn(EnemyLarge, 1, 30, 0, 0, WaveSpawnPathSide.CENTER),
					new WaveSpawn(EnemyLarge, 1, 60, 0, 1, WaveSpawnPathSide.CENTER)
				],
				600, 300),
				
				new Wave(
				[
					new WaveSpawn(EnemyLarge, 1, 45, 0, 0, WaveSpawnPathSide.CENTER),
					new WaveSpawn(EnemySmall, 4, 0, 60, 2, WaveSpawnPathSide.LEFT_SIDE),
					new WaveSpawn(EnemySmall, 4, 0, 60, 2, WaveSpawnPathSide.CENTER),
					new WaveSpawn(EnemySmall, 4, 0, 60, 2, WaveSpawnPathSide.RIGHT_SIDE),
					new WaveSpawn(EnemySmall, 4, 90, 60, 1, WaveSpawnPathSide.LEFT_SIDE),
					new WaveSpawn(EnemySmall, 4, 90, 60, 1, WaveSpawnPathSide.CENTER),
					new WaveSpawn(EnemySmall, 4, 90, 60, 1, WaveSpawnPathSide.RIGHT_SIDE)
				],
				850, 150),
				
				new Wave(
				[
					new WaveSpawn(EnemyFlying, 24, 0, 60, 0)
				],
				840, 30),
				
				new Wave(
				[
					new WaveSpawn(EnemyFlying, 8, 0, 30, 0),
					new WaveSpawn(EnemyMedium, 6, 15, 150, 0),
					new WaveSpawn(EnemyRunner, 12, 0, 15, 2),
					new WaveSpawn(EnemyRunner, 12, 290, 15, 2)
				],
				600, 220),
				
				new Wave(
				[
					new WaveSpawn(EnemyMedium, 10, 0, 50, 0),
					new WaveSpawn(EnemyLarge, 4, 600, 200, 0, WaveSpawnPathSide.CENTER),
					new WaveSpawn(EnemySmall, 20, 0, 30, 1, WaveSpawnPathSide.LEFT_SIDE),
					new WaveSpawn(EnemySmall, 20, 0, 30, 1, WaveSpawnPathSide.RIGHT_SIDE),
					new WaveSpawn(EnemyMedium, 8, 15, 65, 1, WaveSpawnPathSide.CENTER),
				],
				1200, 180),
				
				new Wave(
				[
					new WaveSpawn(EnemyMedium, 9, 0, 60, 0),
					new WaveSpawn(EnemyFlying, 16, 0, 90, 0),
					
					new WaveSpawn(EnemyMedium, 5, 90, 90, 1),
					new WaveSpawn(EnemyLarge, 6, 720, 270, 0, WaveSpawnPathSide.CENTER),
					
					new WaveSpawn(EnemySmall, 5, 855, 45, 1, WaveSpawnPathSide.LEFT_SIDE),
					new WaveSpawn(EnemySmall, 3, 855, 90, 1, WaveSpawnPathSide.CENTER),
					new WaveSpawn(EnemyMedium, 2, 900, 90, 1, WaveSpawnPathSide.CENTER),
					new WaveSpawn(EnemySmall, 5, 855, 45, 1, WaveSpawnPathSide.RIGHT_SIDE),
					
					new WaveSpawn(EnemySmall, 5, 1455, 45, 1, WaveSpawnPathSide.LEFT_SIDE),
					new WaveSpawn(EnemySmall, 3, 1455, 90, 1, WaveSpawnPathSide.CENTER),
					new WaveSpawn(EnemyMedium, 2, 1500, 90, 1, WaveSpawnPathSide.CENTER),
					new WaveSpawn(EnemySmall, 5, 1455, 45, 1, WaveSpawnPathSide.RIGHT_SIDE),
					
					new WaveSpawn(EnemyRunner, 6, 0, 400, 2),
					new WaveSpawn(EnemyRunner, 6, 15, 400, 2),
					new WaveSpawn(EnemyRunner, 6, 30, 400, 2),
					new WaveSpawn(EnemyRunner, 6, 45, 400, 2),
					new WaveSpawn(EnemyRunner, 6, 60, 400, 2),
					new WaveSpawn(EnemyRunner, 6, 75, 400, 2)
				],
				1400)
				
			]
	//}
			
		];
		
		
		/*static public const LEVEL_WAVES:Array = 
		[
			[new Wave([new WaveSpawn(EnemyRunner, 1)], -1)],
			[new Wave([new WaveSpawn(EnemyRunner, 1)], -1)],
			[new Wave([new WaveSpawn(EnemyRunner, 1)], -1)]
		];*/
		
	}

}