package com.stickgames
{
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.display.LineScaleMode;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	public class InfoPanel extends Sprite
	{
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	CONSTRUCTOR
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		public function InfoPanel(game:Game, range:Point = null, distanceMouse:int = 15, distanceRim:int = 15)
		{
			super();
			
			this.game = game;
			game.addChild(this);
			
			range || (range = new Point(900, 600));
			
			this.range = range;
			this.distanceMouse = distanceMouse;
			this.distanceRim = distanceRim;
			this.visible = false;
			
			this.background = new Shape();
			this.textFields = [];
			
			this.drawBackground(300, 225);
			
			this.addChild(this.background);
			
			this.addEventListener(Event.ENTER_FRAME, this.onFrameUpdate, false, 0, true);
			
			range = null;
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	PROPERTIES
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		public var game:Game;
		public var background:Shape;
		public var range:Point;
		public var textFields:Array;
		public var distanceMouse:int;
		public var distanceRim:int;
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	ACCESSORS
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	INITIALIZATION
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		public function drawBackground(width:int, height:int):void
		{
			var graphic:Graphics = this.background.graphics;
			var gradientBox:Matrix = new Matrix();
			
			gradientBox.createGradientBox(width, height, 1.57);
			
			graphic.clear();
			graphic.lineStyle(1, 0xCCCCCC, 1, true);
			graphic.beginGradientFill(GradientType.LINEAR, [0, 0, 0, 0], [0.95, 0.5, 0.5, 0.95], [0, 63, 191, 255], gradientBox);
			graphic.drawRect(0, 0, width, height);
			graphic.endFill();
			
			graphic = null;
			gradientBox = null;
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	METHODS
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		public function show(contents:Array, width:int = 250):void
		{
			this.visible && this.hide();
			this.visible = true;
			this.graphics.clear();
			
			var height:int;
			var currentY:int = 3;
			var p:*;
			
			for (var i:int = 0, n:int = contents.length; i < n; i++)
			{
				p = contents[i];
				
				if (p == "----")
				{
					var matrix:Matrix = new Matrix();
					
					matrix.createGradientBox(width - 30, 0, 0, 15);
					
					this.graphics.moveTo(15, currentY + 3);
					this.graphics.lineStyle(1.2);
					this.graphics.lineGradientStyle(GradientType.LINEAR, [0xEEEEEE, 0xEEEEEE, 0xEEEEEE, 0xEEEEEE], [0, 1, 1, 0], [0, 61, 191, 255], matrix);
					this.graphics.lineTo(width - 15, currentY + 3);
					
					currentY += 3;
					
					matrix = null;
				}
				else
				{
					var format:TextFormat = new TextFormat();
					
					format.align = TextFormatAlign.CENTER;
					format.font = Boolean(p[5]) ? "Open Sans Bold" : "Open Sans Regular";
					format.size = p[4] || 20;
					
					var txt:TextField = new TextField();
					
					txt.text = p[0];
					txt.multiline = true;
					txt.wordWrap = true;
					txt.setTextFormat(format);
					txt.embedFonts = true;
					txt.textColor = p[3];
					txt.width = width - 40;
					txt.autoSize = TextFieldAutoSize.CENTER;
					txt.x = 20;
					txt.y = currentY + p[1];
					txt.mouseEnabled = false;
					txt.mouseWheelEnabled = false;
					
					this.addChild(txt);
					this.textFields[this.textFields.length] = txt;
					
					currentY += txt.textHeight + p[2] * 2;
					
					txt = null;
					format = null;
				}
				
				p = null;
			}
			
			height = currentY + 6;
			
			this.drawBackground(width, height);
			this.move();
			
			contents = null;
		}
		
		public function hide():void
		{
			this.graphics.clear();
			
			for each (var p:TextField in this.textFields)
			{
				this.removeChild(p);
				p = null;
			}
			this.textFields.length = 0;
			
			this.visible = false;
		}
		
		public function move():void
		{
			if (this.game.mouseX + this.distanceMouse + this.width + this.distanceRim > this.range.x)
				this.x = Math.min(this.game.mouseX - this.width - this.distanceMouse, this.range.x - this.width - this.distanceRim);
			else
				this.x = Math.max(this.game.mouseX + this.distanceMouse, this.distanceRim);
			
			this.y = Math.max(Math.min(this.game.mouseY - this.height - this.distanceMouse, this.range.y - this.height - this.distanceRim), this.distanceRim);
		}
		
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	FRAME_UPDATER
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
		
		protected function onFrameUpdate(event:Event):void
		{
			if (!this.visible)
				return;
			
			this.move();
		}
	
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	EVENT_HANDLERS
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
	
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
//	DESTROYER
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
	
	}

}