package
{
	import flash.display.Sprite;
	
	public class WindowSettingList extends Sprite
	{
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	CONSTRUCTOR
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		public function WindowSettingList(window:WindowSettings, x:int = 0, y:int = 0, listWidth:int = 800, listHeight:int = 600, listItemHeight:int = 50)
		{
			super();
			
			window.addChild(this);
			
			this.x = x;
			this.y = y;
			
			this.window = window;
			
			this.items = {};
			this.listWidth = listWidth;
			this.listHeight = listHeight;
			this.listItemHeight = listItemHeight;
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	PROPERTIES
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		public var window:WindowSettings;
		public var items:Object;
		public var numItems:int;
		public var listWidth:int;
		public var listHeight:int;
		public var listItemHeight:int;
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	ACCESSORS
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	INITIALIZATION
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	METHODS
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		public function addSetting(title:String, mode:String, initial:* = false, setFunction:Function = null):void
		{
			var currentY:int = 10 + this.numItems * (this.listItemHeight + 5);
			
			switch (mode)
			{
				case WindowSettingMode.CHECKBOX: 
					this.items[title] = new WindowSettingListCheckbox(this, title, 20, currentY, this.listWidth, this.listItemHeight, initial, setFunction);
					break;
					
				case WindowSettingMode.SLIDER: 
					this.items[title] = new WindowSettingListSlider(this, title, 20, currentY, this.listWidth, this.listItemHeight, initial, setFunction);
					break;
				
				default: 
					throw new Error("不支持的值！");
			}
			
			this.numItems++;
		}
		
		public function getSetting(title:String):WindowSettingListItem
		{
			return this.items[title] as WindowSettingListItem;
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
			throw new Error("I can\'t be destroyed!!");
		}
	
	}

}