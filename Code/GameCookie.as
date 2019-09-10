/**
 * 2016/7/2 11:19
 *
 * 游戏存档管理
 */
package
{
	import flash.display.StageQuality;
	import flash.net.SharedObject;
	
	public class GameCookie
	{
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	CONSTRUCTOR
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		/**
		 * 创建新的 GameCookie 对象。
		 */
		public function GameCookie()
		{
			this.levels = [];
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	PROPERTIES
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		/**
		 * 游戏关卡存档。
		 */
		public var levels:Array;
		
		/**
		 * 系统中读取到的 SharedObject 对象。
		 */
		protected var _cookie:SharedObject;
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	ACCESSORS
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		/**
		 * [只读] 全局游戏存档 SharedObject 对象。
		 */
		public function get cookie():SharedObject
		{
			if (!this._cookie)
				this.loadLocal();
			
			return this._cookie;
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	METHODS
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		/**
		 * 尝试从本地读取一个该游戏的存档。
		 * 如果没有存档对象，则会使用所有默认值自动创建一个新的存档。
		 */
		public function loadLocal():void
		{
			this._cookie = SharedObject.getLocal(GameVersions.GAME_FULLNAME, "/");
			
			if (this._cookie.size == 0)
				this.createCookie();
			
			this.readLevelCookies();
		}
		
		/**
		 * 在本地创建一个新的游戏存档。
		 *
		 * @param	customLevel - 自定义新游戏存档的已完成关卡。
		 * @param	customStars - 自定义新游戏存档的已完成关卡的星星数。
		 * @param	unlockNewLevel - 是否解锁新的关卡。
		 */
		public function createCookie(customLevel:int = 0, customStars:int = 0, unlockNewLevel:Boolean = false):void
		{
			var data:* = this.cookie.data;
			
			data.levels = [];
			
			for (var i:int = 0, n:int = Levels.LEVELS.length; i < n; i++)
			{
				data.levels[i] = new LevelCookie(i <= customLevel, (unlockNewLevel || i < customLevel) ? customStars : 0);
			}
			
			this.createCookiePrefs();
			
			data = null;
		}
		
		/**
		 * 根据自定义的星星数量和铁拳模式完成度来创建新的游戏存档。
		 *
		 * @param	levelStars - 指定新存档中每一个关卡的星星数。如果希望以 3 星通过所有关卡，请设置为 null。
		 * @param	levelIrons - 指定新存档中每一个关卡是否已完成铁拳模式。如果希望已通过所有铁拳模式，请设置为 null。
		 */
		public function createCustomCookie(levelStars:Array = null, levelIrons:Array = null):void
		{
			this.deleteCookie();
			
			var data:* = this.cookie.data;
			
			data.levels = [];
			
			for (var i:int = 0, n:int = Levels.LEVELS.length; i < n; i++)
			{
				data.levels[i] = new LevelCookie(levelStars ? levelStars[i - 1] > 0 : true, levelStars ? levelStars[i] : 3, levelIrons ? levelIrons[i] : true);
			}
			
			this.createCookiePrefs();
			
			this.readLevelCookies();
		}
		
		/**
		 * 在当前游戏存档中生成游戏的默认首选项设置。
		 */
		public function createCookiePrefs():void
		{
			var data:* = this.cookie.data;
			
			data.prefs = {};
			
			data.prefs.quality = StageQuality.HIGH;
			data.prefs.autoPause = true;
			data.prefs.showPanel = true;
			
			data = null;
		}
		
		/**
		 * 从本地文件中删除现有的游戏存档。
		 *
		 * @param	args - 如果希望删除完成后创建新的存档，请在此为 createCookie() 函数转参。
		 */
		public function deleteCookie(... args):void
		{
			this.cookie.clear();
			this.levels = [];
			
			if (args.length > 0)
			{
				this.createCookie(args[0], args[1], args[2]);
				this.readLevelCookies();
			}
		}
		
		/**
		 * 从游戏存档中读取游戏关卡讯息（更新关卡讯息）。
		 */
		public function readLevelCookies():Array
		{
			if (this.levels.length == 0)
			{
				for (var i:int = 0, n:int = Levels.LEVELS.length; i < n; i++)
				{
					this.levels[i] = new LevelCookie();
				}
			}
			
			var data:* = this.cookie.data;
			
			for (i = 0, n = data.levels.length; i < n; i++)
			{
				for each (var p:String in LevelCookie.PROPERTIES)
				{
					//trace("levels[" + i + "]." + p + " = " + data.levels[i][p])
					if (data.levels[i].hasOwnProperty(p))
						this.levels[i][p] = data.levels[i][p];
				}
			}
			p = null;
			
			data = null;
			
			return this.levels;
		}
		
		/**
		 * 向游戏存档中写入指定关卡的讯息。
		 *
		 * @param	id - 要写入的关卡的 ID。
		 * @param	enabled - 关卡是否已解锁。
		 * @param	stars - 关卡的星星数。
		 * @param	iron - 关卡是否已完成铁拳模式。
		 */
		public function writeLevelCookie(id:int, enabled:* = null, stars:* = null, iron:* = null):void
		{
			if (!this.cookie.data.levels[id])
			{
				for (var i:int = this.cookie.data.levels.length, n = this.levels.length; i < n; i++)
				{
					this.cookie.data.levels[i] = new LevelCookie(i == 0);
				}
			}
			
			var cookie:* = this.cookie.data.levels[id];
			
			enabled is Boolean && (this.levels[id].enabled = enabled);
			stars is int && (this.levels[id].stars = stars);
			iron is Boolean && (this.levels[id].iron = iron);
			
			enabled is Boolean && (cookie.enabled = enabled);
			stars is int && (cookie.stars = stars);
			iron is Boolean && (cookie.iron = iron);
			//trace(new Error().getStackTrace())
			cookie = null;
		}
		
		/**
		 * 从游戏存档中读取游戏的首选项设置。
		 */
		public function readPrefs():GamePrefs
		{
			var prefs:GamePrefs = new GamePrefs();
			
			for each (var p:String in GamePrefs.PROPERTIES)
			{
				if (!this.cookie.data.prefs || !this.cookie.data.prefs.hasOwnProperty(p))
					this.createCookiePrefs();
				
				prefs[p] = this.cookie.data.prefs[p];
			}
			
			return prefs;
		}
		
		/**
		 * 向游戏存档中写入游戏的首选项设置。
		 *
		 * @param	prefs - 要设置的选项名。
		 * @param	value - 要为该选项赋予的值。
		 */
		public function writePrefs(prefs:String, value:*):void
		{
			if (!this.cookie.data.prefs.hasOwnProperty(prefs))
				this.createCookiePrefs();
			
			this.cookie.data.prefs[prefs] = value;
		}
		
		/**
		 * 向游戏存档中写入多个游戏的首选项设置（形如“{选项名: 值, 选项名: 值}”）。
		 */
		public function writePrefses(prefs:*):void
		{
			for (var p:* in prefs)
			{
				if (!this.cookie.data.hasOwnProperty(p))
					this.createCookiePrefs();
				
				this.cookie.data.prefs[p] = prefs[p];
			}
			
			p = null;
			prefs = null;
		}
	
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	EVENT_HANDLERS
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
	
	}

}