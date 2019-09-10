/**
 * 2016/7/2 11:52
 * 
 * [抽象基类] 游戏场景
 */
package
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	public dynamic class GameScene extends Sprite
	{
		
		/**
		 * 表示游戏的主菜单。
		 */
		static public const MAIN_MENU:String = "main menu";
		/**
		 * 表示游戏的地图。
		 */
		static public const MAP:String = "map";
		/**
		 * 表示游戏的关卡。
		 */
		static public const LEVEL:String = "level";
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	CONSTRUCTOR
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		/**
		 * [抽象基类] GameScene 类是抽象基类，实例化该类可能会出现异常。
		 * 
		 * @param	game - 此游戏场景所属的游戏对象。
		 */
		public function GameScene(game:Game = null)
		{
			if (game)
			{
				this.game = game;
				this.main = Main(game.parent);
				game && game.addChild(this);
			}
			
			super();
			
			this.stage ? this.onAddedToStage() : this.addEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage, false, 0, true);
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	PROPERTIES
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		/**
		 * Main 主文档类。
		 */
		public var main:Main;
		/**
		 * 所属的游戏对象。
		 */
		public var game:Game;
		/**
		 * 指定此游戏场景是否处于活动状态。
		 */
		public var isActive:Boolean;
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	ACCESSORS
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	INITIALIZATION
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		protected function onAddedToStage(event:Event = null):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage);
			
			this.game || (this.game = Game(this.parent));
			this.main || (this.main = Main(this.game.parent));
			
			this.fadein();
		}
		
		/**
		 * 黑色背景淡出完毕。
		 */
		protected function onBlackFadeoutComplete(event:Event):void
		{
			event.currentTarget.removeEventListener(Event.COMPLETE, this.onBlackFadeoutComplete);
			
			if (!this.game)
				return;
			
			this.isActive = true;
			
			this.init();
		}
		
		public function init():void
		{
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	METHODS
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		/**
		 * 淡入此游戏场景。
		 */
		public function fadein():void
		{
			var blackBack:BlackBackgraound = new BlackBackgraound(this);
			
			blackBack.fadeout();
			blackBack.addEventListener(Event.COMPLETE, this.onBlackFadeoutComplete, false, 0, true);
			
			blackBack = null;
		}
		
		/**
		 * 淡出此游戏场景。
		 */
		public function fadeout():void
		{
			var blackBack:BlackBackgraound = new BlackBackgraound(this);
			
			blackBack.fadein();
			blackBack.addEventListener(Event.COMPLETE, this.onBlackFadeinComplete, false, 0, true);
			
			this.isActive = false;
			
			blackBack = null;
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	FRAME_UPDATER
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	EVENT_HANDLERS
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		/**
		 * 黑色背景淡入完毕（游戏场景淡出完毕）。
		 */
		protected function onBlackFadeinComplete(event:Event):void
		{
			event.currentTarget.removeEventListener(Event.COMPLETE, this.onBlackFadeinComplete);
			
			this.destroy();
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	DESTROYER
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		public function destroy():void
		{
			this.game = null;
			this.main = null;
			
			this.parent && this.parent.removeChild(this);
		}
	
	}

}