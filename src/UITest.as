package {

	/**
	Document class for Skyline 
	
	**/
	import skyline.ui.*;
	import skyline.*;
	
	import flash.display.*;
	import flash.events.*;
	import com.greensock.TweenLite;
	import com.greensock.easing.*;
	
	public class UITest extends Sprite {  //rotate to mouse
		
		//bg
		private var _bg:Sprite;
		private var _arrow:Arrow;
		private var _skylinePlayable:SkylinePlayable;
		
		//button
		private var _button0:Sprite;


		// ------------------------------------
		// CONSTRUCTOR
		// ------------------------------------
		
		public function UITest () {
			trace("UITest");
			init();
		}

		
		// ------------------------------------
		// ACCESSORS
		// ------------------------------------

				
		// ------------------------------------
		// INIT METHODS
		// ------------------------------------
		private function init():void {
			trace("UITest::init");

			_skylinePlayable = new SkylinePlayable(); 
			_skylinePlayable.loadSkyline("_assets/images/skyline900_nyc.jpg");
			_skylinePlayable.addEventListener(MeterEvent.METER_START, onSkylinePlayableMeterStart, false, 0, true);
			addChild(_skylinePlayable);
		}
		
		


		// ------------------------------------
		// CREATE / DESTROY
		// ------------------------------------


			
		// ------------------------------------
		// METHODS
		// ------------------------------------


		
		// ------------------------------------
		// EVENT METHODS
		// ------------------------------------
		private function onSkylinePlayableMeterStart(event:MeterEvent):void {
			trace("UITest::onSkylinePlayableMeterStart");
		}
	}
}