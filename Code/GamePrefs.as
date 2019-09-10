/**
 * 2016/7/2 11:45
 *
 * 游戏的首选项设置
 */
package
{
	import flash.display.StageQuality;
	
	public class GamePrefs
	{
		
		/**
		 * 所涉及到的选项名的集合。
		 */
		static public const PROPERTIES:Array = ["quality", "autoPause", "showPanel"];
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	CONSTRUCTOR
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		/**
		 * 创建新的 GamePrefs 对象。
		 *
		 * @param	game - 对象所属的 Game 对象（如果有）。
		 */
		public function GamePrefs(game:Game = null)
		{
			this.game = game;
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	PROPERTIES
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		/**
		 * 该游戏首选项所属的游戏对象。
		 */
		public var game:Game;
		/**
		 * 舞台的品质。
		 */
		public var quality:String;
		/**
		 * 游戏关卡中是否自动保存。
		 */
		public var autoPause:Boolean;
		/**
		 * 游戏关卡中是否显示文本信息面板。
		 */
		public var showPanel:Boolean;
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	ACCESSORS
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	METHODS
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		/**
		 * 从本地游戏存档中加载游戏首选项。
		 */
		public function loadLocal():void
		{
			var localPrefs:GamePrefs = this.game.gameCookie.readPrefs();
			
			for each (var p:String in GamePrefs.PROPERTIES)
			{
				this[p] = localPrefs[p];
			}
		}
		
		/**
		 * 从游戏存档中更新指定选项的值。
		 *
		 * @param	prefs - 指定选项的名字。希望更新整个游戏首选项，请设置为 null。
		 */
		public function readPrefsCookie(prefs:String = null):void
		{
			if (prefs)
			{
				this[prefs] = this.game.gameCookie.readPrefs()[prefs];
			}
			else
			{
				this.loadLocal();
			}
		}
		
		/**
		 * 向游戏存档中写入游戏的首选项设置。
		 *
		 * @param	prefs - 要设置的选项名。
		 * @param	value - 要为该选项赋予的值。
		 */
		public function writePrefsCookie(prefs:String, value:*):void
		{
			this[prefs] = value;
			
			this.game.gameCookie.writePrefs(prefs, value);
		}
		
		/**
		 * 向游戏存档中写入多个游戏的首选项设置（形如“{选项名: 值, 选项名: 值}”）。
		 */
		public function writePrefsCookies(prefs:*):void
		{
			for (var p:* in prefs)
			{
				this[p] = prefs[p];
			}
			
			this.game.gameCookie.writePrefses(prefs);
		}
	
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	EVENT_HANDLERS
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
	
	}

}