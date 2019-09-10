/**
 * 2016/6/27 19:25
 *
 * 游戏核心类
 */
package
{
	import com.stickgames.InfoPanel;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedSuperclassName;
	
	public class Game extends Sprite
	{
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	CONSTRUCTOR
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
		
		/**
		 * 创建新的 Game 对象。
		 */
		public function Game()
		{
			this.windows = new Sprite();
			
			super();
			
			this.gameSettings = new GameSettings();
			this.gameSettings.loadLocal();
			
			this.gameCookie = new GameCookie();
			this.gameCookie.loadLocal();
			//this.gameCookie.deleteCookie(2, 3, false);
			//this.gameCookie.createCustomCookie();
			//this.gameCookie.deleteCookie();
			
			this.gamePrefs = new GamePrefs(this);
			this.gamePrefs.loadLocal();
			
			this.buttonSettings = new ButtonSettings(this);
			
			this.windowSettings = new WindowSettings(this);
			
			this.infoPanel = new InfoPanel(this);
			
			this._nextSceneArgs = [];
			
			this.addChildAt(this.windowSettings, 0);
			this.addChildAt(this.buttonSettings, 0);
			this.addChildAt(this.windows, 0);
			
			this.addEventListener(Event.ADDED_TO_STAGE, this.init, false, 0, true);
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	PROPERTIES
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
		
		/**
		 * 游戏的主文档类。
		 */
		public var main:Main;
		/**
		 * 游戏当前正在播放的场景。
		 */
		public var scene:GameScene;
		/**
		 * 游戏中出现的文本信息面板。
		 */
		public var infoPanel:InfoPanel;
		/**
		 * 窗口右上角的设置按钮。
		 */
		public var buttonSettings:ButtonSettings;
		/**
		 * “窗口”图层。
		 */
		public var windows:Sprite;
		/**
		 * 设置菜单窗口。
		 */
		public var windowSettings:WindowSettings;
		/**
		 * 游戏配置。
		 */
		public var gameSettings:GameSettings;
		/**
		 * 游戏存档。
		 */
		public var gameCookie:GameCookie;
		/**
		 * 游戏首选项设置。
		 */
		public var gamePrefs:GamePrefs;
		/**
		 * 游戏当前所处的场景名称。
		 */
		public var sceneName:String;
		
		/**
		 * 游戏下一个要加载的场景。
		 */
		protected var _nextScene:Class;
		/**
		 * 游戏下一个要加载场景的构造函数的参数列表。
		 */
		protected var _nextSceneArgs:Array;
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	ACCESSORS
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	INITIALIZATION
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
		
		protected function init(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, this.init);
			
			this.main = Main(this.parent);
			
			this.activateLevelClasses();
			
			this.loadScene(MainMenu);
			//this.loadScene(Map);
			//this.loadScene(Level3);
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	METHODS
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
		
		/**
		 * 激活关卡类。
		 */
		public function activateLevelClasses():void
		{
			Level;
			Level1;
			Level2;
			Level3;
		}
		
		/**
		 * 加载下一个场景。
		 *
		 * @param	scene - 下一个场景的类名。
		 */
		public function loadScene(scene:Class, ... args):void
		{
			if (!this.scene)
			{
				this.onSceneRemoved(null, scene);
				return;
			}
			
			this._nextScene = scene;
			
			this._nextSceneArgs.length = 0;
			for (var i:int = 0, n:int = args.length; i < n; i++)
			{
				this._nextSceneArgs[i] = args[i];
			}
			
			this.scene.fadeout();
			this.scene.addEventListener(Event.REMOVED_FROM_STAGE, this.onSceneRemoved, false, 0, true);
			
			this.scene = null;
		}
		
		/**
		 * 显示文本信息面板。
		 *
		 * @param	contents - 文本内容。
		 * @param	width - 文本信息面板的宽度。
		 */
		public function showInfoPanel(contents:Array, width:int = 250):void
		{
			this.infoPanel.show(contents, width);
		}
		
		/**
		 * 隐藏文本信息面板。
		 */
		public function hideInfoPanel():void
		{
			this.infoPanel.visible && this.infoPanel.hide();
		}
		
		/**
		 * 加载下一个场景。
		 *
		 * @param	scene - 下一个场景的类名。
		 */
		private function loadNextScene(scene:Class):void
		{
			if (scene == Map)
				this.sceneName = GameScene.MAP;
			else if (scene == MainMenu)
				this.sceneName = GameScene.MAIN_MENU;
			else if (getDefinitionByName(getQualifiedSuperclassName(scene)) == Level)
				this.sceneName = GameScene.LEVEL;
			
			switch (this.sceneName)
			{
				case GameScene.LEVEL: 
					this.scene = new scene(this, this._nextSceneArgs[0] || LevelMode.CAMPAIGN);
					break;
				
				case GameScene.MAP: 
					this.scene = new Map(this, isNaN(this._nextSceneArgs[0]) ? -1 : this._nextSceneArgs[0], isNaN(this._nextSceneArgs[1]) ? -1 : this._nextSceneArgs[1], this._nextSceneArgs[2]);
					break;
				
				default: 
					this.scene = new scene(this);
					break;
			}
			
			this._nextScene = null;
			
			this.addChildAt(this.scene, 0);
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	EVENT_HANDLERS
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
		
		/**
		 * 上一个场景从舞台上移除。
		 *
		 * @param	event - 事件对象 event。
		 * @param	nextScene - 下一个场景名称。
		 */
		protected function onSceneRemoved(event:Event, nextScene:Class = null):void
		{
			event && event.currentTarget.removeEventListener(Event.REMOVED_FROM_STAGE, this.onSceneRemoved);
			
			this.loadNextScene(this._nextScene || nextScene);
		}
	
	}

}