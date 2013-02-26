package skyline.ui{

	/**
	Constructs a 

	*/

	import flash.display.*;
	import flash.net.*;
	import flash.events.*;

	import com.greensock.TweenLite;
	import com.greensock.easing.*;

	public class TreeMeter extends ProgressMeter {

		// ------------------------------------
		// CONSTRUCTOR
		// ------------------------------------

		public function TreeMeter (height:int=72, prog:int = 0, total:int = 1) {
			trace("TreeMeter");
			_fullHeight = height;
			_soFar = prog;
			_total = total;
			create();
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
		override protected function create ():void{
			trace("TreeMeter::create");
			_bg = Drawer.createFill(0,0,32,_fullHeight, 0x000000, 0);
			_fillMask = new TreeForm();
			_fillOutline = new TreeOutline();

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
		override public function refresh(newScore:Number):void {
			trace("\tProgressMeter::refresh\ninitial height: "+_progFill.height);
			_soFar = newScore;
			var newHeight = newScore/_total * _fullHeight + BASE_HEIGHT;
			
			if (newHeight >=_fullHeight) {
				trace("\t\t\t>>>>>>>>>>>>>>>>>>>>>>>>MAXOUT:  tree meter is full!")
				// dispatch a call to our custom event
				var e:MeterEvent = new MeterEvent(MeterEvent.METER_FULL);
				dispatchEvent(e);
			}
			 
			TweenLite.to(_progFill, 0.6, {height:newHeight, ease:Cubic.easeOut});
			trace("\tProgressMeter::refresh\nupdated height: "+newHeight);
		}
		
		
		// ------------------------------------
		// EVENT METHODS
		// ------------------------------------
		
		
	}
}