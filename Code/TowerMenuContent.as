/**
 * 2016/1/17 13:09
 *
 * 建筑菜单内容控制器
 */
package
{
	
	public class TowerMenuContent
	{
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	CONSTRUCTOR
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
		
		/**
		 * 创建新的 TowerMenuContent 对象。
		 *
		 * @param	content - 建筑菜单布局样式。
		 * @param	towers - 建筑菜单项的塔。
		 * @param	prices - 建筑菜单项的价格。
		 * @param	fadeoutAfterSelect - 是否在选择任何一个项目之后自动隐藏建筑菜单。
		 */
		public function TowerMenuContent(content:String = null, towers:Array = null, prices:Array = null, fadeoutAfterSelect:Boolean = true)
		{
			this.content = content;
			this.towers = towers;
			this.prices = prices;
			this.fadeoutAfterSelect = fadeoutAfterSelect;
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	PROPERTIES
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
		
		/**
		 * 建筑菜单布局样式。
		 */
		public var content:String;
		/**
		 * 建筑菜单项的塔。
		 */
		public var towers:Array;
		/**
		 * 建筑菜单项的价格。
		 */
		public var prices:Array;
		/**
		 * 是否在选择任何一个项目之后自动隐藏建筑菜单。
		 */
		public var fadeoutAfterSelect:Boolean;
	
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	ACCESSORS
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
	
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	METHODS
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
	
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	EVENT_HANDLERS
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
	
	}

}