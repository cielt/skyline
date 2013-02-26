package skyline.ui{

	/**
	Constructs a 

	*/
	import flash.display.*;
	import flash.events.*;
	import flash.utils.*;
	import flash.utils.Timer;
	import flash.net.*;
	import flash.text.*;
	import flash.geom.ColorTransform;

	import com.greensock.TweenLite;
	import com.greensock.easing.*;
	
	public class NavSkyline extends Sprite {

		private static const HAZE_FACTOR = 0.72;
		
		private var _pathSkyline:String;  //path to actual image of skyline
		private var _pathEnv:String; //path to image of environment
		private var _city:City;
		//private var _cityName:String;
				
		private var _bg:Sprite;
		private var _haze:Sprite;
		private var _nodeLayer:Sprite;  //add nodes as children of this; place over rest of the nav / skyline
		private var _border:Sprite;
		private var _loaderSkyline:Loader;
		
		
		private var _mask:Sprite;  //for skyline loader 
	
		private var _projectArray:Array;  //for constructor - to create nav nodes
		private var _nodeDictionary:Dictionary;
		private var _nodeArray:Array; 
		
		//label; progress
		private var _cityNameField:SideLabel;  //name of city
		
		//forest image; fading-out layer
		private var _loaderEnv:Loader;  //environment loader
		private var _coverEnv:Sprite;
		
		//keep track of how many have been selected
		private var _selectedNodeCount:int = 0;
		private var _cityProgressBoard:CityProgressBoard;
		private var _cityProgressMask:Sprite;

		//TIMER for slide pane
		private var _paneTimer:Timer;

		// ------------------------------------
		// CONSTRUCTOR
		// ------------------------------------

		public function NavSkyline (pCity) {
			trace("NavSkyline");
			_city = pCity;	
			_pathSkyline = _city.pathSkyline;
			_projectArray = _city.projects;	
			create();
		}

		// ------------------------------------
		// ACCESSORS
		// ------------------------------------
		public function get haze():Sprite{ return _haze; }
		public function get border():Sprite { return _border; }
		public function get projectArray():Array { return _projectArray; }
		//return selectedNodeCount, i.e., num of projects that have been located
		public function get selectedNodeCount():int { return _selectedNodeCount; }
		

		// ------------------------------------
		// INIT METHODS
		// ------------------------------------
		
		

		// ------------------------------------
		// CREATE / DESTROY
		// ------------------------------------
		
		public function create ():void{
			trace("NavSkyline::create");
			//time
			_paneTimer = new Timer(5000, 0);
			_paneTimer.addEventListener(TimerEvent.TIMER, onPaneTimer);
			//_paneTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onPaneTimerComplete);
			
			//set up bg stuff
			_bg = Drawer.createFill(0, 0, 900, 215, 0xFFFFFF, 0.2);
			
			// loader for skyline
			_loaderSkyline = new Loader();
			_loaderSkyline.contentLoaderInfo.addEventListener(Event.COMPLETE, completeHandler);
			_loaderSkyline.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			_loaderSkyline.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			
			// masks!!!!
			_mask = Drawer.createFill(0,0,900,215,0x00FF00,1);
			_loaderSkyline.mask = _mask;
			
			_bg.addChildAt(_loaderSkyline, 0);
			_bg.addChild(_mask);
			
			// haze
			_haze = Drawer.createFill(0,0,900,215,0xFFFFFF,1);
			_haze.alpha = HAZE_FACTOR;
			_bg.addChild(_haze);
			
			// nodeLayer
			_nodeLayer = Drawer.createFill(0,0,900,215,0x000000, 0);
			_bg.addChild(_nodeLayer);
			
			// border
			_border = Drawer.createBorder(0,0,900,215,1,0x333333,1);

			_bg.addChild(_border);
			addChild(_bg);
			
			//label
			_cityNameField = new SideLabel();
			_cityNameField.highlight_mc.alpha = 0;
			_cityNameField.highlight_mc.visible = false;
			_cityNameField.CityName_text.text = _city.name;
			
			_bg.addChild(_cityNameField);			
			
			//content
			_nodeDictionary = new Dictionary();
			_nodeArray = new Array();
			
			var count:int = _projectArray.length;
			for ( var i:int=0; i<count; i++ ) {
				
				var node:NavNodeSkyline = new NavNodeSkyline(_projectArray[i]);
				node.x = getNodePosX(node);
				node.y = getNodePosY(node);
				trace("\nplacing node "+i+"at position: ("+node.x+", "+node.y+")");
								
				_nodeDictionary[node] = i;
				_nodeArray.push(node);
				node.buttonMode = true;
				node.mouseChildren = false;
				node.useHandCursor = true;
				node.addEventListener(MouseEvent.MOUSE_OVER, nodeMouseOverHandler, false, 0, true);
				node.addEventListener(MouseEvent.MOUSE_OUT, nodeMouseOutHandler, false, 0, true);
				node.addEventListener(MouseEvent.CLICK, nodeClickHandler, false, 0, true);
				
				//hide it for now
				_nodeLayer.addChild(node);
			}
			
			//ProgressBoard
			_cityProgressBoard = new CityProgressBoard(_selectedNodeCount, _projectArray.length);
			_cityProgressMask = Drawer.createFill(0,0,308, 215, 0x00FF00, 1);
			_cityProgressBoard.mask = _cityProgressMask; 
			
			//tree meter listener
			_cityProgressBoard.treeMeter.addEventListener(MeterEvent.METER_FULL, onCityTreeMeterFull, false, 0, true);
			
			
			//load the env image
			_cityProgressBoard.forestPane.loadEnv("_assets/images/trees_swamp.jpg");

			_cityProgressBoard.x = 900 - CityProgressBoard.COLLAPSED_WIDTH;
			_cityProgressBoard.y = 215 - _cityProgressBoard.height;
			addChild(_cityProgressBoard);
			_cityProgressMask.x = 900 - CityProgressBoard.EXPANDED_WIDTH;
			addChild(_cityProgressMask);
		}
		
		// ------------------------------------
		// METHODS
		// ------------------------------------
		public function loadSkyline (path:String):void{
			trace("NavSkyline::loadSkyline");
			
			var request:URLRequest = new URLRequest(path);
			_loaderSkyline.load(request);
		}
		
		public function getNodePosX (n:NavNodeSkyline):Number{
			trace("NavSkyline::getPositionX");
			return n.project.nodePosX;
		}
		
		public function getNodePosY (n:NavNodeSkyline):Number{
			trace("NavSkyline::getPositionY");
			return n.project.nodePosY;
		}
		
		public function nodeCount():int { 
			trace("NavSkyline::nodeCount");
			return _nodeArray.length;
		}
		
		//check this
		public function brighten(increment:Number) {
			var diff:Number = HAZE_FACTOR/increment;
			trace("NavSkyline::brighten\n about to brighten skyline by a change of "+diff);
			//_haze.alpha -= diff;
			var toAlpha:Number = _haze.alpha - diff;
			if (toAlpha >= -1){
				TweenLite.to(_haze, 1.2, {alpha:toAlpha, ease:Quad.easeOut});
			}else{
				_haze.alpha = 0;
			}
			trace("haze alpha is now: "+_haze.alpha);
		}
		
		public function select (id:int):void{
			trace("NavSkyline::select for "+id);
			_selectedNodeCount = 0;  //start counting from 0
			
			// update the look of the nav
			var count:int = _nodeArray.length;
			for ( var i:int=0; i<count; i++ ) {
					
				var node:NavNodeSkyline = _nodeArray[i];
				
				if (i == id) {
					node.select();
				} else {
					if (!node.isOn){  //leave nodes that have been clicked, on; else deselect
						node.deselect();
					}
				}
				
				//check how many nodes out of total have been selected
				if (node.isOn) {
					_selectedNodeCount++;
				}
				
	
			}
			//then update the ProgressBoard
			trace("\t>>>>>>>>>>>>>>>>>>>>>>>>>>_selectedNodeCount = "+_selectedNodeCount);
			_cityProgressBoard.refresh(_selectedNodeCount, _nodeArray.length);
			var toX:Number = _bg.width - CityProgressBoard.EXPANDED_WIDTH;
			expandForestPane(toX, 0);
			
			// dispatch a call to our custom event
			var e:NavEvent = new NavEvent(NavEvent.SELECT_PROJECT, id);
			dispatchEvent(e);
		}
		
		//slide _forestPane
		private function expandForestPane(toX:Number, toY:Number):void {
			trace("NavSkyline::expandForestPane");
			TweenLite.to(_cityProgressBoard, 0.8, {x:toX, y:toY, delay: 0.4, ease:Quad.easeOut});
			_paneTimer.start();
			_cityProgressBoard.forestPane.visible = true;
		}
		
		private function collapseForestPane(toX:Number, toY:Number):void {
			trace("NavSkyline::collapseForestPane");
			TweenLite.to(_cityProgressBoard, 0.4, {x:toX, y:toY, delay: 0, ease:Quad.easeOut});
		}
		
		// ------------------------------------
		// EVENT METHODS
		// ------------------------------------
		private function completeHandler(event:Event):void {
		    trace("completeHandler: " + event);
		
			trace("\tevent.target.width is: "+event.target.width);
			trace("\tevent.currentTarget.width is: "+event.currentTarget.width);
			trace("\tevent.currentTarget.type is: "+event.currentTarget.toString());
 		
			_loaderSkyline.x = (_bg.width - event.currentTarget.width)/2;
			_loaderSkyline.y = (_bg.height - event.currentTarget.height)/2;
		}
        
		private function ioErrorHandler(event:IOErrorEvent):void {
		    trace("ioErrorHandler: " + event);
		}
        
		private function progressHandler(event:ProgressEvent):void {
		    trace("progressHandler: bytesLoaded=" + event.bytesLoaded + " bytesTotal=" + event.bytesTotal);
		}
		
		/* EVENT */
		private function nodeMouseOverHandler (event:MouseEvent):void{
			trace("NavSkyline::nodeMouseOverHandler");
			
			// THE TYPE OF THE event.currentTarget and event.target
			// is by default a DisplayObject
			//var s:Sprite = Sprite(event.currentTarget);
			var n:NavNodeSkyline = NavNodeSkyline(event.currentTarget);
			
			//bring current node to the front
			addChild(n);
			//addChild(event.currentTarget as Sprite);
			
			if (!n.isOn) {
				TweenLite.to(n.border, 0.25, {scaleX:1, scaleY:1, alpha:0.8, ease:Quad.easeOut});
			}else {
				//do something
			}
		}
		
		private function nodeMouseOutHandler (event:MouseEvent):void{
			trace("NavSkyline::nodeMouseOutHandler");
			var n:NavNodeSkyline = NavNodeSkyline(event.currentTarget);
			if (!n.isOn) {
				TweenLite.to(n.border, 0.25, {scaleX:1, scaleY:1, alpha:0, ease:Quad.easeOut});
			}
		}
		
		private function nodeClickHandler (event:MouseEvent):void{
			trace("NavSkyline::nodeClickHandler");
			
			//trace("\tevent.currentTarget is: "+event.currentTarget);
			trace("\t_nodeDictionary[event.currentTarget] is: "+_nodeDictionary[event.currentTarget]);
			select(_nodeDictionary[event.currentTarget])
		}
		
		
		//TIMER
		private function onPaneTimer(event:TimerEvent):void {
			trace("NavSkyline::onPaneTimerComplete");
			_paneTimer.stop();
			var toX:Number = _bg.width - CityProgressBoard.COLLAPSED_WIDTH;
			collapseForestPane(toX, 0);
		}
		
		//TREE METER
		private function onCityTreeMeterFull(event:MeterEvent):void {
			trace("NavSkyline::onCityTreeMeterFull");
			_city.isGreen = true;
			
			//green it
			_cityProgressBoard.green();
			_cityNameField.black_mc.visible = false;
			_cityNameField.highlight_mc.visible = true;
			TweenLite.to(_cityNameField.highlight_mc, 1.2, {alpha:0.8, ease:Quad.easeOut});
				
			var ctBorder:ColorTransform = new ColorTransform();
			ctBorder.color = 0xA4AA4C;
			_border.transform.colorTransform = ctBorder;
			
		}
		
		
	}
}
