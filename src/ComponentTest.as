package {

	/**
	Document class for Skyline 
	
	**/

	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.text.*;
	import flash.display.SimpleButton;
	
	import skyline.ui.*;
	import skyline.*;

	import com.greensock.TweenLite;
	import com.greensock.easing.*;
	
	public class ComponentTest extends Sprite {
		
		public static var POS_X:Number = 0;
		public static var POS_Y:Number = 0;

		
		//bg
		private var _bg:Sprite;
		private var _forestPane:ForestPane;
		private var _progressMeter:ProgressMeter;
		private var _treeMeter:TreeMeter;
		//private var _cityProgressBoard:CityProgressBoard;
		
		//button
		private var _testButton:Sprite;
		private var _test1:Sprite;


		// ------------------------------------
		// CONSTRUCTOR
		// ------------------------------------
		
		public function ComponentTest () {
			trace("ComponentTest");
			_bg = Drawer.createFill(0,0, 240, 320, 0x000000, 0);
			
			addChild(_bg);
		
			//ProgressMeter test
			_progressMeter = new ProgressMeter(120, 0, 5);
			
			
			_treeMeter = new TreeMeter(72, 0, 3);
			_treeMeter.y = _progressMeter.y + _progressMeter.height + 12;
			
			//add a button
			_testButton = Drawer.createRoundRectFill(0,0,96, 24, 8, 0x99CC33, 0.6);
			var buttonLabel = Texter.createOneLineField(90, 20, 12, 0xFFFFFF, false);
			buttonLabel.text = "try it!";
			_testButton.addChild(buttonLabel);
			_testButton.buttonMode = true;
			_testButton.mouseChildren = false;
			_testButton.useHandCursor = true;
			
			_testButton.addEventListener(MouseEvent.CLICK, onNewButtonClick, false, 0, true);
			
			
			_test1 = Drawer.createRoundRectFill(0,0,96, 24, 8, 0xCC3399, 0.6);
			var test1Label = Texter.createOneLineField(90, 20, 12, 0xFFFFFF, false);
			test1Label.text = "try it!";
			_test1.addChild(test1Label);
			_test1.buttonMode = true;
			_test1.mouseChildren = false;
			_test1.useHandCursor = true;
			
			_test1.addEventListener(MouseEvent.CLICK, onTest1Click, false, 0, true);
			
			_test1.x = _testButton.x + _testButton.width + 18;
			
			_bg.addChild(_testButton);
			_bg.addChild(_test1);
			
			_bg.addChild(_progressMeter);
			_bg.addChild(_treeMeter);
		}

		
		// ------------------------------------
		// ACCESSORS
		// ------------------------------------

				
		// ------------------------------------
		// INIT METHODS
		// ------------------------------------
		private function init ():void{
			trace("ComponentTest::init");
			create();
		}


		// ------------------------------------
		// CREATE / DESTROY
		// ------------------------------------
		private function create ():void{
			trace("ComponentTest::create");
		
		}	
			
		// ------------------------------------
		// METHODS
		// ------------------------------------

		
		// ------------------------------------
		// EVENT METHODS
		// ------------------------------------
		public function onNewButtonClick(event:MouseEvent){
			trace("ComponentTest::onNewButtonClick\n\told score = "+_progressMeter.soFar);
			//_forestPane.reveal(3);
			var currScore:int = _progressMeter.soFar;
			var toScore = currScore+1;
			_progressMeter.refresh(toScore);
			trace("currScore = "+toScore);
		}

		public function onTest1Click(event:MouseEvent){
			trace("ComponentTest::onTest1Click\n\told score = "+_treeMeter.soFar);
			//_forestPane.reveal(3);
			var currScore:int = _treeMeter.soFar;
			var toScore = currScore+1;
			_treeMeter.refresh(toScore);
			trace("currScore = "+toScore);
		}		
 
		
	}
}