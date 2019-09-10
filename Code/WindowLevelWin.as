/**
 * 2016/1/16 14:06
 *
 * 关卡胜利界面
 */
package
{
	import com.greensock.easing.Back;
	import com.greensock.easing.Strong;
	import com.greensock.TweenMax;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class WindowLevelWin extends Window
	{
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	CONSTRUCTOR
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
		
		/**
		 * 创建新的 LevelWin 对象。
		 *
		 * @param	level - 所属的关卡。
		 * @param	star - 获得的星星数量。
		 */
		public function WindowLevelWin(level:Level, star:int)
		{
			super(level.game.windows);
			
			this.level = level;
			this.star = star;
			
			this.buttonQuit.label = "Quit";
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	PROPERTIES
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
		
		public var level:Level;
		public var buttonQuit:ButtonBase;
		/**
		 * 获得的星星数量。
		 */
		public var star:int;
		/**
		 * 关卡胜利星星。
		 */
		private var _stars:Array;
		/**
		 * 当前正在淡入的星星索引。
		 */
		private var _currentStar:int;
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	ACCESSORS
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	INITIALIZATION
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
		
		override public function init():void
		{
			super.init();
			
			this.updateCookie();
			this.showStar();
			
			this.buttonQuit.addEventListener(MouseEvent.CLICK, this.onButtonQuitClick, false, 0, true);
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	METHODS
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
		
		public function updateCookie():void
		{
			this.game.gameCookie.writeLevelCookie(this.level.id, true, Math.max(this.star, this.game.gameCookie.levels[this.level.id].stars), this.game.gameCookie.levels[this.level.id].iron || this.level.levelMode == LevelMode.IRON);
		}
		
		public function showStar():void
		{
			this._stars || (this._stars = []);
			this._stars[this._currentStar] = new WindowLevelWinStar(this);
			this.starFadein();
		}
		
		/**
		 * 淡入星星。
		 */
		public function starFadein():void
		{
			TweenMax.from(this._stars[this._currentStar], 0.6, {delay: 0.25, ease: Back.easeOut, scaleX: 0, scaleY: 0, onStart: this.onStarFadeinStart, onComplete: this.onStarFadeinComplete});
		}
		
		override public function fadeout():void
		{
			super.fadeout();
			
			this.buttonQuit.removeEventListener(MouseEvent.CLICK, this.onButtonQuitClick);
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	FRAME_UPDATER
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	EVENT_HANDLERS
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
		
		protected function onButtonQuitClick(event:MouseEvent):void
		{
			this.fadeout();
			
			if (this.level.levelMode == LevelMode.CAMPAIGN)
				this.game.loadScene(Map, this.level.id, this.game.gameCookie.levels[this.level.id].stars);
			else
				this.game.loadScene(Map, this.level.id, -1, true);
		}
		
		/**
		 * 星星淡入开始。
		 */
		protected function onStarFadeinStart():void
		{
			if (this._currentStar == 1)
				TweenMax.to(WindowLevelWinStar(this._stars[this._currentStar - 1]), 0.6, {ease: Strong.easeOut, x: "-100", y: "20"});
			else if (this._currentStar == 2)
				TweenMax.to(WindowLevelWinStar(this._stars[this._currentStar - 1]), 0.6, {ease: Strong.easeOut, x: "100", y: "20"});
		}
		
		/**
		 * 星星淡入完成。
		 */
		protected function onStarFadeinComplete():void
		{
			if (this._currentStar < this.star - 1)
			{
				this._currentStar++;
				this.showStar();
			}
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	DESTROYER
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
		
		override public function destroy():void
		{
			while (this._stars.length > 0)
			{
				TweenMax.killTweensOf(this._stars[this._stars.length - 1]);
				WindowLevelWinStar(this._stars[this._stars.length - 1]).destroy();
				this._stars.length--;
			}
			this._stars = null;
			
			super.destroy();
		}
	
	}

}