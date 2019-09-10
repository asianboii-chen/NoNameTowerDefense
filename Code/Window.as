package
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Back;
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class Window extends Sprite
	{
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	CONSTRUCTOR
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		public function Window(parent:Sprite = null)
		{
			super();
			
			this.black = new Sprite();
			this.black.graphics.beginFill(0, 0.75);
			this.black.graphics.drawRect(-450, -300, 900, 600);
			this.black.graphics.endFill();
			this.addChildAt(this.black, 0);
			
			this.x = 450;
			this.y = 400;
			this.visible = false;
			this.alpha = 0;
			this.mouseChildren = false;
			this.mouseEnabled = false;
			
			if (parent)
			{
				parent.addChild(this);
				this.onAddedToStage();
			}
			else
			{
				this.addEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage, false, 0, true);
			}
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	PROPERTIES
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		public var game:Game;
		public var black:Sprite;
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	ACCESSORS
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	INITIALIZATION
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		protected function onAddedToStage(event:Event = null):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage);
			
			this.game || (this.game = this.parent.parent as Game) || (this.game = this.parent.parent.parent as Game);
			
			this is WindowLevelSettings || this.fadein();
		}
		
		public function init():void
		{
			this.mouseChildren = true;
			this.mouseEnabled = true;
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	METHODS
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		public function fadein():void
		{
			this.game.scene is Level && this.game.scene.levelState != LevelState.OVER && this.game.scene.pause();
			
			TweenMax.to(this, 0.7, {ease: Back.easeOut, y: "-100", onUpdate: this.onFadeUpdate, onComplete: this.init});
			TweenMax.to(this, 0.7, {autoAlpha: 1});
			TweenMax.to(this.black, 0.7, {autoAlpha: 1});
		}
		
		public function fadeout():void
		{
			this.game.scene is Level && this.game.scene.levelState != LevelState.OVER && this.game.scene.unpause();
			
			TweenMax.to(this, 0.7, {ease: Back.easeIn, y: "+100", onUpdate: this.onFadeUpdate, onComplete: this.onFadeoutComplete});
			TweenMax.to(this, 0.7, {autoAlpha: 0});
			TweenMax.to(this.black, 0.7, {autoAlpha: 0});
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	FRAME_UPDATER
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	EVENT_HANDLERS
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		protected function onFadeUpdate():void
		{
			this.black.y = 300 - this.y;
		}
		
		protected function onFadeoutComplete():void
		{
			this.destroy();
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	DESTROYER
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		public function destroy():void
		{
			this.black.graphics.clear();
			this.removeChild(this.black);
			this.black = null;
			
			this.game = null;
			
			this.parent.removeChild(this);
		}
	
	}

}