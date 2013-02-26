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

	public class HorizontalProgressMeter extends Sprite {
		public static const BASE_LENGTH:int = 1;
		
		protected var _bg:Sprite;
		protected var _fullLength:int;  //measure of fill at 100% progress; s/b same as _fillMask.height
		protected var _fillMask:Sprite;
		protected var _fillOutline:Sprite;
		
		protected var _progFill:Sprite;
		protected var _soFar:int;  //number of items done
		protected var _total:int	//numbner of items to do 
		
		// ------------------------------------
		// CONSTRUCTOR
		// ------------------------------------

		public function HorizontalProgressMeter (length:int=100, prog:int = 0, total:int = 1) {
			trace("HorizontalProgressMeter");
			_fullLength = length;
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
			trace("HorizontalProgressMeter::create");
			_bg = Drawer.createFill(0,0,_fullLength,12, 0x776032, 1);

			_fillMask = Drawer.createFill(0,0,_fullLength,_bg.height, 0x00FF00, 0);
			_fillOutline = Drawer.createBorder(0,0,_fullLength,_bg.height,1,0x669900,1);
			var prog:Number = _soFar / _total;
			var initLength:Number = prog * _fullLength + BASE_LENGTH;
			var maskY = (_bg.height - _fillMask.height)/2;
			_progFill = Drawer.createFill(-initLength,0,initLength,_bg.height, 0x669900, 1);
			_progFill.y = 0;
			_progFill.x = _bg.width+BASE_LENGTH;
			//_progFill.x = -BASE_LENGTH;
			
			_fillMask.y = _fillOutline.y = maskY;
			
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
			trace("\tHorizontalProgressMeter::refresh\ninitial length: "+_progFill.width);
			_soFar = newScore;
			var newLength = newScore/_total * _fullLength + BASE_LENGTH;
			
			if (newLength >=_fullLength) {
				trace("\t\t\t>>>>>>>>>>>>>>>>>>>>>>>>MAXOUT:  meter is full!")
				// dispatch a call to our custom event
				var e:MeterEvent = new MeterEvent(MeterEvent.METER_FULL);
				dispatchEvent(e);
			}
			
			//finally, update appearance
			TweenLite.to(_progFill, 0.6, {width:newLength, ease:Cubic.easeOut});
			trace("\tHorizontalProgressMeter::refresh\nupdated length: "+newLength);
		}

		
		// ------------------------------------
		// EVENT METHODS
		// ------------------------------------
		
		
	}
}