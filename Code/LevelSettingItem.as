package
{
	
	public class LevelSettingItem
	{
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	CONSTRUCTOR
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		public function LevelSettingItem(location:Node, id:int, canUnlockIDs:Array, cash:int, archerLevel:int = 1, barrackLevel:int = 1, mageLevel:int = 1, artilleryLevel:int = 1)
		{
			this.mapLocation = location;
			this.id = id;
			this.cash = cash;
			this.canUnlockIDs = canUnlockIDs || [];
			this.archerLevel = archerLevel;
			this.barrackLevel = barrackLevel;
			this.mageLevel = mageLevel;
			this.artilleryLevel = artilleryLevel;
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	PROPERTIES
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		public var mapLocation:Node;
		public var canUnlockIDs:Array;
		public var id:int;
		public var cash:int;
		public var archerLevel:int;
		public var barrackLevel:int;
		public var mageLevel:int;
		public var artilleryLevel:int;
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	ACCESSORS
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	METHODS
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		public function toString():String
		{
			return "[id=" + this.id + ",mapLocation=" + this.mapLocation + "canUnlockIDs=(" + this.canUnlockIDs + "),cash=" + this.cash + ",archerLevel=" + this.archerLevel + ",barrackLevel=" + this.barrackLevel + ",mageLevel=" + this.mageLevel + ",artilleryLevel=" + this.artilleryLevel + "]";
		}
	
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	EVENT_HANDLERS
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
	
	}

}