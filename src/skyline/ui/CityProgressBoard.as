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
		
		//invisible, underneath all elts; space for everything
		private var _bg:Sprite;
		
		private var _holderBar:Sprite;
		private var _bgLabel:Sprite;
		private var _highlight:Sprite;  //show when greened!
		private var _sideBar:Sprite;  //expandable!
		
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
		public function get sideBar():Sprite { return _sideBar; }
		
		// ------------------------------------
		// INIT METHODS
		// ------------------------------------


		// ------------------------------------
		// CREATE / DESTROY
		// ------------------------------------		
		private function create ():void{
			trace("CityProgressBoard::create");
			_bg = Drawer.createFill(0, 0, 308, 215, 0x00FF00, 0);
			_holderBar = Drawer.createFill(0, 0, 68, 215, 0x000000, 0.8);
			_bgLabel = Drawer.createFill(0, 0, 68, 24, 0xFFFFFF, 0.2);
			
			//side bar
			_sideBar = Drawer.createFill(-8, 0, 8, 215, 0x000000, 0.8);  //register for expand to left 
			
			//LOADER for env image
			
			//GREEN meter!
			_treeMeter = new TreeMeter(72, _numFound, _total);
			
			_holderBar.addChild(_treeMeter);
			
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
			_treeMeter.x = (_holderBar.width - _treeMeter.width)/2;
			_bgLabel.x = 0;
			_bgLabel.y = _treeMeter.y + _treeMeter.height +8;
			_bgLabel.addChild(_highlight);
			_bgLabel.addChild(_scoreField);
			
			_holderBar.addChild(_treeMeter);
			_holderBar.addChild(_bgLabel);
			_holderBar.x = _bg.width - _holderBar.width;	
			
			
			_forestPane = new ForestPane();
			_forestPane.scaleX = _forestPane.scaleY = 0.25;
			_forestPane.x = _holderBar.x +(_holderBar.width - 60)/2;
			_forestPane.y = _bgLabel.y + _bgLabel.height + 8;
			
			//hide it for now
			//_forestPane.visible = false;
			_bg.addChild(_holderBar);
			
			_sideBar.x = _holderBar.x;
			_bg.addChild(_sideBar);
			addChild(_bg);
			addChild(_forestPane);
		}
		
		// ------------------------------------
		// METHODS
		// ------------------------------------	
		
		//set score
		public function refresh(found:int, total:int):void {
			trace("\tCityProgressBoard::refresh");
			_numFound = found;
			_total = total;
			
			var perCentRaw:Number = _numFound/_total;
			//trace("updating score field \n perCentRaw = "+perCentRaw);
			var perCent:int = Math.round((perCentRaw)*100);
			_scoreField.htmlText = "<span class='white'>"+ (perCent) +"%</span>";
			_treeMeter.refresh(_numFound);
	
		}

		public function green():void {
			trace("CityProgressBoard::green");
			_highlight.visible = true;
			var perCentRaw:Number = _numFound / _total;
			var perCent:int = Math.round(perCentRaw*100);
			_scoreField.htmlText = "<span class='white'>"+ (perCent) +"%</span>";
			TweenLite.to(_highlight, 0.8, {alpha:0.8, delay: 0.8, ease:Quad.easeOut});
		}
				
		
		//slide _forestPane
		public function expandForestPane(toX:Number, toY:Number):void {
			trace("NavSkyline::expandForestPane");
			
			TweenLite.to(_sideBar, 0.8, {width:240, delay: 0.4, ease:Quad.easeOut});
			TweenLite.to(_forestPane, 0.4, {x:4, y:0, scaleX: 1, scaleY:1, delay: 0.8, ease:Quad.easeOut});
			//_forestPane.reveal(_total);
			//_forestPane.messageOverlay.visible = true;
			var toY:Number = 159;		
			TweenLite.to(_forestPane.messageOverlay, 0.8, {x:0, y:toY, delay: 1.4, ease:Quad.easeOut});
		}
		
		public function collapseForestPane(toX:Number, toY:Number):void {
			trace("NavSkyline::collapseForestPane");
			//_forestPane.messageOverlay.visible = false;
			//var toY:Number = _forestPane.holder.height;
			var toY:Number = 207;
			TweenLite.to(_forestPane.messageOverlay, 0.4, {x:0, y:toY, delay: 0, ease:Quad.easeIn});
			TweenLite.to(_forestPane, 0.4, {x:244, y:154, scaleX: 0.25, scaleY:0.25, delay: 0.4, ease:Quad.easeIn});
			TweenLite.to(_sideBar, 0.48, {width:8, delay: 0.8, ease:Quad.easeIn});
		}
		
		// ------------------------------------
		// EVENT METHODS
		// ------------------------------------

		
	}
}