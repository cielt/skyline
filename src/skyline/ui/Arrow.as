package skyline.ui{

	/**
	Constructs a 

	*/
	import flash.display.*;
	import flash.events.*;
	import flash.filters.*;
	import flash.geom.ColorTransform;

	import com.greensock.TweenLite;
	import com.greensock.easing.*;
	
	public class Arrow extends Sprite {

		
		// ------------------------------------
		// CONSTRUCTOR
		// ------------------------------------

		public function Arrow() {
			trace("Arrow");
			init();
		}

		// ------------------------------------
		// ACCESSORS
		// ------------------------------------
	
		// ------------------------------------
		// INIT METHODS
		// ------------------------------------
		private function init():void {
			trace("Arrow::init");
			graphics.lineStyle(2,0xFFFFFF,1.0);
			graphics.beginFill(0x000000, 0.8);
			graphics.moveTo(-60,-10);
			graphics.lineTo(0,-10);
			graphics.lineTo(-15,-40);
			graphics.lineTo(60,0);
			graphics.lineTo(-15, 40);
			graphics.lineTo(0,10);
			graphics.lineTo(-60,10);
			graphics.lineTo(-60,-10);
			graphics.endFill();
		
			//create, add shadow filter
			var filter:BitmapFilter = Drawer.createDropShadowFilter();
			var myFilters:Array = new Array();
			myFilters.push(filter);
			this.filters = myFilters;
		}
		
		

		// ------------------------------------
		// CREATE / DESTROY
		// ------------------------------------
		
		public function create ():void{
			trace("Arrow::create");
		}
		
		// ------------------------------------
		// METHODS
		// ------------------------------------

		
		// ------------------------------------
		// EVENT METHODS
		// ------------------------------------

		
		
	}
}
