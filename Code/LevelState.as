/**
 * 2016/1/16 14:36
 *
 * 关卡状态
 */
package
{
	
	public class LevelState
	{
		/**
		 * [静态] 指示关卡处于第一波开始之前。
		 */
		static public const PRE_BATTLE:String = "pre battle";
		/**
		 * [静态] 指示关卡正在战斗。
		 */
		static public const BATTLE:String = "battle";
		/**
		 * [静态] 指示关卡波次已经全部出完。
		 */
		static public const WAVE_DONE:String = "wave done";
		/**
		 * [静态] 指示关卡波次已经全部出完，敌人全部消灭，即将胜利。
		 */
		static public const PRE_WIN:String = "pre win";
		/**
		 * [静态] 指示关卡已经结束。
		 */
		static public const OVER:String = "over";
	
	}

}