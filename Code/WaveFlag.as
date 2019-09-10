/**
 * 2016/1/17 13:41
 *
 * 下一波图标
 */
package
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Strong;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	
	public class WaveFlag extends LevelEntity
	{
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	CONSTRUCTOR
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
		
		/**
		 * 创建新的 WaveFlag 对象。
		 *
		 * @param	level - 所属的关卡。
		 * @param	enemies - 下一波的敌人描述。
		 * @param	pathIndex - 下一波敌人的路径。
		 * @param	timeout - 持续的时间。
		 * @param	direction - 图标所指的方向。
		 * @param	flagPathIndex - 图标显示在下一波路径上的节点索引。
		 */
		public function WaveFlag(level:Level, enemies:String, pathIndex:int, timeout:int, direction:Number = NaN, flagPathIndex:int = -1)
		{
			var path:Array = level.paths[pathIndex][0];
			var directionDistance:Point;
			
			if (flagPathIndex == -1)
			{
				for (var i:int = 0, n:int = path.length; i < n; i++)
				{
					if (Node(path[i]).isBegining)
					{
						flagPathIndex = i;
						break;
					}
				}
				i == n && (flagPathIndex = 0);
			}
			
			isNaN(direction) && (direction = Node.direction(path[flagPathIndex], path[flagPathIndex + 5]) / 180 * Math.PI);
			
			this._distanceToMouse = this.height * 0.5;
			this._direction = direction;
			this._timeout = timeout;
			
			directionDistance = Point.polar(50, this._direction);
			
			super(path[flagPathIndex].x + directionDistance.x, path[flagPathIndex].y + directionDistance.y, level.gui);
			
			this.scaleX = this.scaleY = 0;
			
			this.currentWave = level.waves[level.currentWave];
			this.isActive = false;
			this.isCounting = true;
			this.enemies = enemies;
			
			this._max = 1;
			this._min = 0.85;
			this._speed = 0.1;
			this._angle = 1.8;
			
			this._glowing = new GlowFilter();
			this._glowing.color = 0xFF0000;
			this._glowing.quality = 15;
			this._glowing.blurX = this._glowing.blurY = 6;
			
			directionDistance = null;
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	PROPERTIES
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
		
		public var currentWave:Wave;
		/**
		 * 箭头对象。
		 */
		public var arrow:Sprite;
		/**
		 * 进度条对象。
		 */
		public var progressBar:Sprite;
		/**
		 * 敌人的描述。
		 */
		public var enemies:String;
		
		public var isCounting:Boolean;
		
		public var isClicked:Boolean;
		
		/**
		 * 发光滤镜。
		 */
		private var _glowing:GlowFilter;
		/**
		 * 持续的时间。
		 */
		private var _timeout:int;
		/**
		 * 持续的时间计时器。
		 */
		private var _time:int;
		/**
		 * 所指的方向。
		 */
		private var _direction:Number;
		/**
		 * 和鼠标的默认距离。
		 */
		private var _distanceToMouse:Number;
		/**
		 * 最大时放大到和原来的相对倍数。
		 */
		private var _max:Number;
		/**
		 * 最小时缩小到和原来的相对倍数。
		 */
		private var _min:Number;
		/**
		 * 变动的速度。
		 */
		private var _speed:Number;
		/**
		 * 变动计时器。
		 */
		private var _angle:Number;
		/**
		 * 是否正在发光。
		 */
		private var _isGlowing:Boolean;
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	ACCESSORS
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
		
		/**
		 * 获取或设置箭头旋转的方向。
		 */
		public function get direction():Number
		{
			return this.arrow.rotation;
		}
		
		public function set direction(value:Number):void
		{
			this.arrow.rotation = value;
		}
		
		/**
		 * 获取或设置当前的进度。
		 */
		public function get progress():Number
		{
			return this._timeout == -1 ? NaN : (this._time / this._timeout);
		}
		
		public function set progress(value:Number):void
		{
			this.progressBar.scaleY = value;
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	INITIALIZATION
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
		
		override public function init():void
		{
			super.init();
			
			this.direction = this._direction * 180 / Math.PI;
			this.fadein();
			
			this.addEventListener(MouseEvent.CLICK, this.onFlagClick, false, 0, true);
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	METHODS
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
		
		public function addGlow():void
		{
			if (!this.isActive)
				return;
			
			this.filters = [this._glowing];
		}
		
		public function removeGlow():void
		{
			if (!this.isActive)
				return;
			
			this.filters = [];
		}
		
		public function fadein():void
		{
			TweenMax.to(this, 0.75, {ease: Strong.easeOut, scaleX: 1, scaleY: 1, onComplete: this.onFadeinComplete});
		}
		
		public function fadeout():void
		{
			this.isActive = false;
			
			this.removeEventListener(MouseEvent.CLICK, this.onFlagClick);
			
			TweenMax.to(this, 0.5, {ease: Strong.easeOut, scaleX: 0, scaleY: 0, onComplete: this.onFadeoutComplete});
		}
		
		public function move():void
		{
			this._angle += this._speed;
			
			var scale:Number = Math.sin(this._angle);
			
			scale < 0 && (scale *= -1);
			
			this.scaleX = this.scaleY = scale * (this._max - this._min) + this._min;
		}
		
		public function reach():void
		{
			this.onFlagRollOut();
			
			this.currentWave.isIdle = false;
			this.currentWave.hideWaveFlags();
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	FRAME_UPDATER
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
		
		override public function updateFrame():void
		{
			if (!this.isCounting)
				return;
			
			if (this._time == this._timeout)
			{
				this.reach();
				this.currentWave.startWave();
			}
			
			this._time++;
			
			if (this._timeout != -1 && this._time > this._timeout)
				return;
			
			if (Node.distance(this.level.mouseX, this.level.mouseY, this.x, this.y) < this._distanceToMouse)
				this._isGlowing || this.onFlagRollOver();
			else
				this._isGlowing && this.onFlagRollOut();
			
			var progress:Number = this.progress;
			
			isNaN(progress) && (progress = 1);
			
			this.progress = progress;
			
			this.isActive && this.move();
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	EVENT_HANDLERS
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
		
		/**
		 * 鼠标移入。
		 */
		protected function onFlagRollOver():void
		{
			if (!this.isActive)
				return;
			
			Mouse.cursor = MouseCursor.BUTTON;
			
			this._isGlowing = true;
			this.addGlow();
			
			if (this.level.levelMode == LevelMode.CAMPAIGN)
			{
				if (this.level.wave == -1)
					this.level.showInfoPanel([[GameStrings.FIRST_WAVE_TITLE, 6, 7, 0xEF0000, 20, true], "----", [this.enemies, 5, 5, 0xCCCCCC, 15], "----", [GameStrings.FIRST_WAVE_DESCRIPTION, 4, 4, 0xD70000, 12]]);
				else
					this.level.showInfoPanel([[GameStrings.NEXT_WAVE_TITLE, 6, 7, 0xEF0000, 20, true], "----", [this.enemies, 5, 5, 0xCCCCCC, 15], "----", [GameStrings.NEXT_WAVE_DESCRIPTION, 4, 3, 0xD70000, 12], [GameStrings.NEXT_WAVE_REWARD_DESCRIPTION, 3, 3, 0xAA0000, 11]]);
			}
			else
			{
				this.level.showInfoPanel([[GameStrings.SUPER_WAVE_TITLE, 6, 7, 0xEF0000, 20, true], "----", [this.enemies, 5, 2, 0xCCCCCC, 15], [GameStrings.SUPER_WAVE_WARNING_DESCRIPTION, 1, 3, 0x999999, 11], "----", [GameStrings.FIRST_WAVE_DESCRIPTION, 4, 4, 0xD70000, 12]]);
			}
		}
		
		/**
		 * 鼠标移出。
		 */
		protected function onFlagRollOut():void
		{
			Mouse.cursor = MouseCursor.AUTO;
			
			this._isGlowing && this.level.hideInfoPanel();
			
			this.removeGlow();
			this._isGlowing = false;
		}
		
		/**
		 * 鼠标单击。
		 */
		protected function onFlagClick(event:MouseEvent):void
		{
			this.isClicked = true;
			
			this.reach();
			this.fadeout();
		}
		
		/**
		 * 淡入完成。
		 */
		protected function onFadeinComplete():void
		{
			this.isActive = true;
		}
		
		/**
		 * 淡出完成。
		 */
		protected function onFadeoutComplete():void
		{
			this.isClicked && (this.currentWave.startWave(this));
			
			this.destroy();
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	DESTROYER
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
		
		override public function destroy():void
		{
			this.removeEventListener(MouseEvent.CLICK, this.onFlagClick);
			
			this.removeChild(this.progressBar);
			this.progressBar = null;
			this.removeChild(this.arrow);
			this.arrow = null;
			
			this.currentWave = null;
			
			this.filters = [];
			this._glowing = null;
			
			super.destroy();
		}
	
	}

}