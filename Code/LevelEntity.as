/**
 * 2016/1/16 14:12
 *
 * [动态] [抽象基类] 关卡实体
 * （塔、敌人、子弹、用户界面等的基类）
 */
package
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	
	public dynamic class LevelEntity extends MovieClip
	{
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	CONSTRUCTOR
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		/**
		 * [动态] [抽象基类] LevelEntity 类是抽象基类，实例化该类可能会出现异常。
		 *
		 * @param	x - 实体的 X 坐标。
		 * @param	y - 实体的 Y 坐标。
		 * @param	parent - 实体的父对象。该父对象必须为关卡中的某一图层对象，这样才能正确读取到关卡和游戏。
		 */
		public function LevelEntity(x:int = 0, y:int = 0, parent:Sprite = null)
		{
			super();
			
			this.x = x;
			this.y = y;
			this.isActive = true;
			
			parent && parent.addChild(this);
			
			this.stage ? this.onAddedToStage() : this.addEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage, false, 0, true);
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	PROPERTIES
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		/**
		 * 所属的游戏对象。
		 */
		public var game:Game;
		/**
		 * 所属的关卡对象。
		 */
		public var level:Level;
		/**
		 * 指示该实体是否处于活动状态。处于活动状态的实体才可以参与移动或鼠标等交互。
		 */
		public var isActive:Boolean;
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	ACCESSORS
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	INITIALIZATION
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		private function onAddedToStage(event:Event = null):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage);
			
			this.level = this.parent.parent as Level;
			this.game = this.parent.parent.parent as Game;
			
			this.init();
		}
		
		public function init():void
		{
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	METHODS
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		public function pause():void
		{
		}
		
		public function unpause():void
		{
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	FRAME_UPDATER
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		public function updateFrame():void
		{
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	EVENT_HANDLERS
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	DESTROYER
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		public function destroy():void
		{
			this.level = null;
			this.game = null;
			
			this.parent && this.parent.removeChild(this);
		}
	
	}

}