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

	public class CityProgressBoard extends Sprite {
		public static const VEIL_ALPHA:Number = 0.72;
		public static const COLLAPSED_WIDTH:Number = 68;
		public static const EXPANDED_WIDTH:Number = 308;
		
		private var _holder:Sprite;
		private var _bgLabel:Sprite;
		private var _highlight:Sprite;  //show when greened!
		private var _sideBar:Sprite;
		
		//values
		private var _numFound:int;
		private var _total:int;
		
		//visualization
		private var _scoreField:TextField;	//for score (found / total)
		private var _treeMeter:TreeMeter;  //another way to visualize numFound / total
		
		//forest pane
		private var _forestPane:ForestPane;
		// ------------------------------------
		// CONSTRUCTOR
		// ------------------------------------

		public function CityProgressBoard (numFound:int, total:int) {
			trace("CityProgressBoard");
			_numFound = numFound;
			_total = total;
			create();
			trace("CityProgressBoard\n>>>>>>>>>>>>>>>>>>>>>>>>>_numFound = "+_numFound+"\n_total = "+_total);
		}

		// ------------------------------------
		// ACCESSORS
		// ------------------------------------
		public function get highlight ():Sprite { return _highlight; }
		public function get scoreField():TextField { return _scoreField;  }
		public function get forestPane():ForestPane { return _forestPane; }
		public function get treeMeter():TreeMeter { return _treeMeter; }
		
		// ------------------------------------
		// INIT METHODS
		// ------------------------------------


		// ------------------------------------
		// CREATE / DESTROY
		// ------------------------------------		
		private function create ():void{
			trace("CityProgressBoard::create");
			_holder = Drawer.createFill(0, 0, 68, 215, 0x000000, 0.8);
			_bgLabel = Drawer.createFill(0, 0, 68, 24, 0xFFFFFF, 0.4);
			
			//side bar
			_sideBar = Drawer.createFill(0, 0, 8, 215, 0x000000, 0.8);
			
			//LOADER for env image
			
			//GREEN meter!
			_treeMeter = new TreeMeter(72, _numFound, _total);
			
			_holder.addChild(_treeMeter);
			
			_highlight = Drawer.createFill(0, 0, 68, 24, 0x99CC33, 1);
			//text fields
			_scoreField = Texter.createNumericField(64,24,14,0xFFFFFF);
			var perCent:int = Math.round(_numFound/_total) * 100;
			_scoreField.htmlText = perCent.toString() + "%";

			//_scoreField.y = (_bgLabel.height - _scoreField.height)/2;	
			_scoreField.y =  (_bgLabel.height - _scoreField.height)/2;;
			_scoreField.x = (_bgLabel.width - _scoreField.width)/2;
	

			//add highlight, but hidden
			//remember _highlight.alpha = 0_bgLabel
			_highlight.alpha = 0;
			_highlight.visible = false;			
			
			_treeMeter.y = 12;
			_treeMeter.x = (_holder.width - _treeMeter.width)/2;
			_bgLabel.y = _treeMeter.y + _treeMeter.height +8;
			_bgLabel.addChild(_highlight);
			_bgLabel.addChild(_scoreField);

			addChild(_holder);
			addChild(_bgLabel);
			
			_forestPane = new ForestPane();
			_forestPane.x = _scoreField.x + _scoreField.width;
			//hide it for now
			_forestPane.visible = false;
			
			addChild(_sideBar);
			addChildAt(_forestPane, 0);
		}
		
		// ------------------------------------
		// METHODS
		// ------------------------------------	
		
		//set score
		public function refresh(found:int, total:int):void {
			trace("\t>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>CityProgressBoard::refresh");
			_numFound = found;
			_total = total;
			
			var perCentRaw:Number = _numFound/_total;
			//trace("updating score field \n perCentRaw = "+perCentRaw);
			var perCent:int = Math.round((perCentRaw)*100);
			_scoreField.htmlText = "<span class='white'>"+ (perCent) +"%</span>";
			
			_treeMeter.refresh(_numFound);
			_forestPane.reveal(_total);
		}

		public function green():void {
			trace("CityProgressBoard::green");
			_highlight.visible = true;
			var perCentRaw:Number = _numFound / _total;
			var perCent:int = Math.round(perCentRaw*100);
			_scoreField.htmlText = "<span class='white'>"+ (perCent) +"%</span>";
			TweenLite.to(_highlight, 0.8, {alpha:0.8, delay: 0.8, ease:Quad.easeOut});
		}
				
		//reset
		public function reset():void {
			trace("\t>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>CityProgressBoard::reset");
		
		}
		
		// ------------------------------------
		// EVENT METHODS
		// ------------------------------------

		
	}
}