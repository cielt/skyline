package {
	
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.text.*;
	import flash.geom.Matrix;
	import flash.filters.BitmapFilter;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.GlowFilter;
	import flash.filters.DropShadowFilter;
		
	public class Drawer extends Sprite {
		// ------------------------------------
		// CONSTRUCTOR
		// ------------------------------------
		public function Drawer() {
			//trace("Drawer");

		}
		
		
		// ------------------------------------
		// ACCESSORS
		// ------------------------------------

		
		// ------------------------------------
		// INIT METHODS
		// ------------------------------------
		
		
		// ------------------------------------
		// CREATE / DESTROY
		// ------------------------------------		
		public static function createLine(w:uint,lineThickness:uint, color:Number, alpha:uint):Sprite {
			//trace("createLine");
			var sprite:Sprite = new Sprite();
			sprite.graphics.lineStyle(lineThickness, color, alpha, true, LineScaleMode.NORMAL, CapsStyle.NONE, JointStyle.MITER, 10);
			sprite.graphics.moveTo(0,0);
			
            sprite.graphics.lineTo(w, 0);
			sprite.graphics.endFill();
			
			return sprite;
		}
		
		
		public static function createBorder(x:int,y:int,w:uint,h:uint,lineThickness:uint, color:Number,alpha:Number):Sprite {
			//trace("Drawer::createBorder");

			var sprite:Sprite=new Sprite;
			sprite.graphics.lineStyle(lineThickness,color,alpha,true,LineScaleMode.NONE);
			sprite.graphics.drawRect(x,y,w,h);
			sprite.graphics.endFill();

			return sprite;
		}
		
		public static function createFill(x:int,y:int,w:uint,h:uint,color:Number,alpha:Number):Sprite {
			//trace("Drawer::createHighlight");

			var sprite:Sprite=new Sprite;
			sprite.graphics.beginFill(color,alpha);
			sprite.graphics.drawRect(x,y,w,h);
			sprite.graphics.endFill();

			return sprite;
		}
		
		//ROUND RECT FILL
		public static function createRoundRectBorderFill(x:int,y:int,w:uint,h:uint, cornerRad:uint, borderCol:Number, fillColor:Number,alpha:Number):Sprite {
			//trace("Drawer::createRoundRectBorderFill");
			var sprite:Sprite=new Sprite;
			sprite.graphics.lineStyle(1,borderCol,1.0, true);
			sprite.graphics.beginFill(fillColor,alpha);
			sprite.graphics.drawRoundRect(x,y,w,h, cornerRad, cornerRad);
			sprite.graphics.endFill();
			
			return sprite;
		}
		
		public static function createBitmapFilter():BitmapFilter {
		    var color:Number = 0x99CC33;
		    var alpha:Number = 0.6;
		    var blurX:Number = 12;
		    var blurY:Number = 12;
		    var strength:Number = 1;
			var inner:Boolean = false;
		    var knockout:Boolean = false;
		    var quality:Number = BitmapFilterQuality.HIGH;
		    return new GlowFilter(color, alpha, blurX, blurY, strength, quality, inner, knockout);
		}
		
		public static function createDropShadowFilter():BitmapFilter {
			var color:Number = 0x000000;
			var angle:Number = 60;
			var alpha:Number = 0.8;
			var blurX:Number = 4;
			var blurY:Number = 4;
			var distance:Number = 4;
			var strength:Number = 0.28;
			var inner:Boolean = false;
			var knockout:Boolean = false;
			var quality:Number = BitmapFilterQuality.HIGH;
			return new DropShadowFilter(distance,angle,color,alpha,blurX,blurY,strength,quality,inner,knockout);
		}

		public static function createGradFill(w:int, h:int, c0:Number, c1:Number, alpha0:Number, alpha1:Number):Sprite {
			var s:Sprite = new Sprite();
			var fillType:String = GradientType.LINEAR;
  			var colors:Array = [c0, c1];
			var alphas:Array = [alpha0, alpha1];
  			var ratios:Array = [0x00, 0xFF];
  			var matr:Matrix = new Matrix();
  			matr.createGradientBox(w, h, 90, 0, 0);
  			var spreadMethod:String = SpreadMethod.PAD;
  			s.graphics.beginGradientFill(fillType, colors, alphas, ratios, matr, spreadMethod);  
  			s.graphics.drawRect(0,0,w,h);
			return s;
		}
		
		//node
		public static function createNode(pX:Number, pY:Number, w:int, h:int):Sprite{
				var s:Sprite = new Sprite();
				s.graphics.lineStyle(1,0x99CC33,1.0);
				s.graphics.beginFill(0x99CC33, 0.2);
				s.graphics.moveTo(pX,pY);
				s.graphics.lineTo(pX+w,pY);
				s.graphics.lineTo(pX+w,pY+h);
				s.graphics.lineTo(pX,pY+h);
				s.graphics.lineTo(pX,pY);
				s.graphics.endFill();
				return s;
		}
		
		// ------------------------------------
		// METHODS
		// ------------------------------------

		// ------------------------------------
		// EVENT METHODS
		// ------------------------------------

	
	}
}