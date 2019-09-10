package
{
	import com.greensock.easing.Strong;
	import com.greensock.TweenMax;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	
	public class MousePointer extends LevelEntity
	{
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	CONSTRUCTOR
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		public function MousePointer(level:Level, isActive:Boolean = false)
		{
			Mouse.cursor = MouseCursor.HAND;
			
			super(level.gui.mouseX, level.gui.mouseY, level.gui);
			
			level.pointer = this;
			level.deactivateAll();
			
			this.mouseChildren = false;
			this.mouseEnabled = false;
			this.isActive = isActive;
			
			this._errorTime = 15;
			this._errorCounter = -1;
			
			this.gotoAndStop(1);
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	PROPERTIES
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		public var isFadeingOut:Boolean;
		
		protected var _errorTime:int;
		protected var _errorCounter:int;
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	ACCESSORS
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	INITIALIZATION
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		override public function init():void
		{
			super.init();
			
			this.level.addEventListener(MouseEvent.CLICK, this.onPointerClick, false, 0, true);
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	METHODS
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		public function select():void
		{
			if (!this.isActive)
			{
				this.isActive = true;
				return;
			}
			
			var position:Node = new Node(this.level.gui.mouseX, this.level.gui.mouseY);
			
			if (this.checkPosition(position))
			{
				this.fadeout(position);
			}
			else
			{
				this._errorCounter = 0;
				this.gotoAndStop(2);
			}
			
			position = null;
		}
		
		public function checkPosition(position:Node):Boolean
		{
			for each (var p:Array in this.level.paths)
			{
				for each (var q:Node in p[0])
				{
					if (Node.distance(position, q) < 40)
						return true;
				}
			}
			
			return false;
		}
		
		override public function pause():void
		{
			this.isActive && (this.visible = false);
		}
		
		override public function unpause():void
		{
			this.visible = true;
		}
		
		public function fadeout(position:Node = null):void
		{
			Mouse.cursor = MouseCursor.AUTO;
			
			this.isFadeingOut = true;
			this.isActive = false;
			
			this.level.removeEventListener(MouseEvent.CLICK, this.onPointerClick);
			this.level.hideAllGUIs();
			this.level.unselectAllSpells();
			
			this.gotoAndStop(1);
			
			TweenMax.to(this, 0.5, {ease: Strong.easeOut, scaleX: 1.3, scaleY: 1.3, autoAlpha: 0, onComplete: this.onFadeoutComplete});
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	FRAME_UPDATER
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		override public function updateFrame():void
		{
			if (this.isActive)
			{
				this.x = this.level.gui.mouseX;
				this.y = this.level.gui.mouseY;
			}
			
			if (this._errorCounter >= 0 && this._errorCounter < this._errorTime)
			{
				this._errorCounter++;
				return;
			}
			
			this._errorCounter = -1;
			this.gotoAndStop(1);
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	EVENT_HANDLERS
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		protected function onPointerClick(event:MouseEvent):void
		{
			if (this.isFadeingOut)
				return;
			
			event.stopPropagation();
			event.stopImmediatePropagation();
			
			this.select();
		}
		
		protected function onFadeoutComplete():void
		{
			this.destroy();
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	DESTROYER
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		override public function destroy():void
		{
			Mouse.cursor = MouseCursor.AUTO;
			
			this.isFadeingOut = false;
			
			this.level && this.level.removeEventListener(MouseEvent.CLICK, this.onPointerClick);
			
			super.destroy();
		}
	
	}

}