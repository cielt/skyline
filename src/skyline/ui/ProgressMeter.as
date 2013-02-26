package skyline.ui{

	/**
	Constructs a 

	*/

	import flash.display.*;
	import flash.net.*;
	import flash.events.*;
	import flash.geom.ColorTransform;

	import com.greensock.TweenLite;
	import com.greensock.easing.*;

	public class ProgressMeter extends Sprite {
		public static const BASE_HEIGHT:int = 1;
		
		protected var _bg:Sprite;
		protected var _fullHeight:int;  //measure of fill at 100% progress; s/b same as _fillMask.height
		protected var _fillMask:Sprite;
		protected var _fillOutline:Sprite;
		
		protected var _progFill:Sprite;
		protected var _soFar:int;  //number of items done
		protected var _total:int	//numbner of items to do 
		
		// ------------------------------------
		// CONSTRUCTOR
		// ------------------------------------

		public function ProgressMeter (height:int=100, prog:int = 0, total:int = 1) {
			trace("ProgressMeter");
			_fullHeight = height;
			_soFar = prog;
			_total = total;
			create();
		}

		// ------------------------------------
		// ACCESSORS
		// ------------------------------------
		public function get soFar():int { return _soFar; }
		public function get bg ():Sprite { return _bg; }
		public function get fillMask():Sprite { return _fillMask; }
		public function get progFill():Sprite { return _progFill;  }
		
		// ------------------------------------
		// INIT METHODS
		// ------------------------------------

		// ------------------------------------
		// CREATE / DESTROY
		// ------------------------------------	
		protected function create ():void{
			trace("ProgressMeter::create");
			_bg = Drawer.createFill(0,0,32,_fullHeight, 0x624037, 0.8);

			_fillMask = Drawer.createFill(0,0,_bg.width/2,_fullHeight, 0x00FF00, 0);
			_fillOutline = Drawer.createBorder(0,0,_bg.width/2,_fullHeight,1,0x333333,1);
			var prog:Number = _soFar / _total;
			var initHeight:Number = prog * _fullHeight + BASE_HEIGHT;
			var maskX = (_bg.width - _fillMask.width)/2;
			_progFill = Drawer.createFill(0,-initHeight,_bg.width,initHeight, 0x99CC33, 1);
			
			_progFill.x = 0;
			_progFill.y = _bg.height+BASE_HEIGHT;
			
			_fillMask.x = _fillOutline.x = maskX;
			
			//mask!!!
			_progFill.mask = _fillMask;
			_bg.addChildAt(_progFill, 0);
			_bg.addChild(_fillMask);
			_bg.addChild(_fillOutline);
			
			addChild(_bg);
		}
		
		// ------------------------------------
		// METHODS
		// ------------------------------------	
		//refresh
		public function refresh(newScore:Number):void {
			trace("\tProgressMeter::refresh\ninitial height: "+_progFill.height);
			_soFar = newScore;
			var newHeight = newScore/_total * _fullHeight + BASE_HEIGHT;
			
			if (newHeight >=_fullHeight) {
				trace("\t\t\t>>>>>>>>>>>>>>>>>>>>>>>>MAXOUT:  meter is full!")
				// dispatch a call to our custom event
				var e:MeterEvent = new MeterEvent(MeterEvent.METER_FULL);
				dispatchEvent(e);
			}
			
			//finally, update appearance
			TweenLite.to(_progFill, 0.6, {height:newHeight, ease:Cubic.easeOut});
			trace("\tProgressMeter::refresh\nupdated height: "+newHeight);
		}
		
		//reset
		public function reset():void {
			trace("\tProgressMeter::reset");
			
		}
		
		// ------------------------------------
		// EVENT METHODS
		// ------------------------------------
		
		
	}
}