package skyline.ui{

	/**
	Constructs a 

	*/

	import flash.display.*;
	import flash.text.*;
	import flash.text.StyleSheet;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	import flash.net.*;
	import flash.events.*;

	import com.greensock.TweenLite;
	import com.greensock.easing.*;

	public class CityScoreBoard extends Sprite {

		private var _bg:Sprite;
		private var _highlight:Sprite;  //show when greened!
		private var _scoreField:TextField;	//for score (found / total)
		private var _labelField:TextField;  //for city name
		
		//values
		private var _numFound:int;
		private var _total:int;
		
		// ------------------------------------
		// CONSTRUCTOR
		// ------------------------------------

		public function CityScoreBoard () {
			trace("CityScoreBoard");
			create();
		}

		// ------------------------------------
		// ACCESSORS
		// ------------------------------------
		public function get bg ():Sprite { return _bg; }
		public function get highlight ():Sprite { return _highlight; }
		public function get scoreField():TextField { return _scoreField;  }
		public function get labelField():TextField { return _labelField;  }
		
		// ------------------------------------
		// INIT METHODS
		// ------------------------------------

		// ------------------------------------
		// CREATE / DESTROY
		// ------------------------------------
		
		private function create ():void{
			trace("CityScoreBoard::create");
			_bg = Drawer.createFill(0, 0, 64, 64, 0x000000, 0.8);
			_highlight = Drawer.createFill(0, 0, 64, 64, 0x99CC33, 1);
			//text fields
			var scoreStyles:StyleSheet = Texter.createScoreStylesheet();
			_scoreField = Texter.createOneLineField(60,36,32,0xFFFFFF, false);
			_scoreField.styleSheet = scoreStyles;
			_scoreField.htmlText = "score";

			//text field + stylesheet
			_labelField = Texter.createMultiLineField(48,13,0xFFFFFF);
			_labelField.text = "projects";
			
			_labelField.y = _scoreField.y + _scoreField.height + 4;
			_scoreField.x = _labelField.x = (_bg.width - _scoreField.width)/2;
			
			//add highlight, but hidden
			//remember _highlight.alpha = 0
			_highlight.alpha = 0;
			_highlight.visible = false;
			
			_bg.addChild(_highlight);
			_bg.addChild(_scoreField);
			_bg.addChild(_labelField);
			
			addChild(_bg);
			
		}
		
		// ------------------------------------
		// METHODS
		// ------------------------------------	
		//set score
		public function setScore(found:int, total:int):void {
			trace("\t>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>CityScoreBoard::setScore");
			_numFound = found;
			_total = total;
			trace("updating score field");
			_scoreField.htmlText = "<span class='white'>"+_numFound+"/"+_total+"</span>";
		}

		public function green():void {
			trace("CityScoreBoard::green");
			_highlight.visible = true;
			TweenLite.to(_highlight, 0.4, {alpha:0.6, ease:Back.easeOut });
			_scoreField.htmlText = "<span class='white'>"+_numFound+'/'+_total+"</span>";
		}
		
		//reset
		public function reset():void {
			trace("\t>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>CityScoreBoard::reset");
		
		}
		
		// ------------------------------------
		// EVENT METHODS
		// ------------------------------------
		
		
	}
}