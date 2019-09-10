package com.stickgames.sganim
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Back;
	import com.greensock.easing.Elastic;
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class SGAnimAlphabets extends Sprite
	{
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	CONSTRUCTOR
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		public function SGAnimAlphabets()
		{
			super();
			
			this.addEventListener(Event.ADDED_TO_STAGE, this.init, false, 0, true);
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	PROPERTIES
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		public var alphabet1:Sprite;
		public var alphabet2:Sprite;
		public var alphabet3:Sprite;
		public var alphabet4:Sprite;
		public var alphabet5:Sprite;
		public var alphabet6:Sprite;
		public var alphabet7:Sprite;
		public var alphabet8:Sprite;
		public var alphabet9:Sprite;
		public var alphabet10:Sprite;
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	ACCESSORS
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	INITIALIZATION
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		protected function init(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, this.init);
			
			for (var i:int = 0; i++ < 10; )
			{
				this["alphabet" + i].visible = false;
			}
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	METHODS
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		public function dropAlphabets():void
		{
			var tween:Object = {ease: Elastic.easeOut, y: -700, scaleX: 2.6, scaleY: 2.6};
			
			for (var i:int = 0; i++ < 10; )
			{
				tween.x = 900 - i * 90 - 280;
				tween.delay = i * 0.15;
				this["alphabet" + i].visible = true;
				TweenMax.from(this["alphabet" + i], 1, tween);
			}
			
			tween = null;
		}
		
		public function shakeAlphabets():void
		{
			TweenMax.from(this, 1.2, {ease: Elastic.easeOut, y: 560});
		}
		
		public function fadeoutAlphabets():void
		{
			TweenMax.to(this, 0.6, {ease: Back.easeIn, y: 660});
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	FRAME_UPDATER
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	EVENT_HANDLERS
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	DESTROYER
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		public function destroy():void
		{
			for (var i:int = 0; i++ < 10; )
			{
				this.removeChild(this["alphabet" + i]);
				this["alphabet" + i] = null;
			}
			
			this.parent.removeChild(this);
		}
	
	}

}