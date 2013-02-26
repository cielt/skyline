package skyline.ui{

	/**
	Constructs a 

	*/

	import flash.display.*;
	import flash.events.*;
	import flash.utils.*;
	import flash.text.*;
	import flash.geom.ColorTransform;
	import flash.filters.BitmapFilter;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.GlowFilter;
	

	import com.greensock.TweenLite;
	import com.greensock.easing.*;

	public class NavWorld extends Sprite {
		private var _bg:Sprite;
		private var _nodeLayer:Sprite;
		private var _world:World;

		private var _citiesArray:Array;  //for constructor - to create nav nodes
		private var _nodeDictionary:Dictionary;
		private var _nodeArray:Array; 
		
		//keep track of how many have been selected
		private var _explorationBegun:Boolean = false;  //true on first city selection
		private var _greenCityCount:int = 0;  //num greened cities (all projects explored)

		// ------------------------------------
		// CONSTRUCTOR
		// ------------------------------------

		public function NavWorld (cities:Array) {
			trace("NavWorld");	
			_citiesArray = cities;
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
		
		public function create ():void{
			trace("NavWorld::create");
			_bg = Drawer.createFill(0, 0, 360, 192, 0x99CC33, 0);
			_nodeLayer = Drawer.createFill(0, 0, 360, 192, 0x00FF00, 0);
			
			
			_world = new World();
			_world.green_mc.alpha = 0;
			_world.black_mc.alpha = 0.3;
			//glow!
			var filter:BitmapFilter = Drawer.createBitmapFilter();
			var myFilters:Array = new Array();
			myFilters.push(filter);
			_world.filters = myFilters;
			
			_nodeDictionary = new Dictionary();
			_nodeArray = new Array();
			
			var count:int = _citiesArray.length;
			for ( var i:int=0; i<count; i++ ) {
				
				var node:NavNodeCity = new NavNodeCity(_citiesArray[i]);
		
				node.x = getCityPosX(node);
				node.y = getCityPosY(node);
				
				trace("\nplacing node "+i+"at position: ("+node.x+", "+node.y+")");
								
				_nodeDictionary[node] = i;
				_nodeArray.push(node);
				node.buttonMode = true;
				node.mouseChildren = false;
				node.useHandCursor = true;
				node.addEventListener(MouseEvent.MOUSE_OVER, nodeMouseOverHandler, false, 0, true);
				node.addEventListener(MouseEvent.MOUSE_OUT, nodeMouseOutHandler, false, 0, true);
				node.addEventListener(MouseEvent.CLICK, nodeClickHandler, false, 0, true);
				
				_nodeLayer.addChild(node);
			}
			
			_bg.addChild(_world);
			_bg.addChild(_nodeLayer);
			addChild(_bg);
		}
		
		// ------------------------------------
		// METHODS
		// ------------------------------------
		
		public function getCityPosX (n:NavNodeCity):Number{
			trace("NavWorld::getCityPositionX");
			return n.city.cityPosX;
		}			
		
		public function getCityPosY (n:NavNodeCity):Number{
			trace("NavWorld::getCityPositionY");
			return n.city.cityPosY;
		}

		
		public function select (id:int):void{
			trace("NavWorld::select for "+id);
			if (!_explorationBegun){
				//now it's true
				_explorationBegun = true;
				var ef:NavEvent = new NavEvent(NavEvent.SELECT_FIRST, id);
				dispatchEvent(ef);	
			}
			
			// update the look of the nav
			var count:int = _nodeArray.length;
			for ( var i:int=0; i<count; i++ ) {
				
				var node:NavNodeCity = _nodeArray[i];
				
				if (i == id) {
					node.select();
				} else {
					node.deselect();
				}
	
			}
			
			// dispatch a call to our custom event
			var e:NavEvent = new NavEvent(NavEvent.SELECT_CITY, id);
			dispatchEvent(e);
		}
		
		//check green city count; refresh appearance
		public function refreshMap():void {
			trace("NavWorld::refreshMap");
			
			var count:int = _citiesArray.length;
			var greenCount:int = 0;
			for ( var i:int=0; i<count; i++ ) {
				
				var c:City = _citiesArray[i];
				
				if (c.isGreen) {
					var greenNode:NavNodeCity = _nodeArray[i];
					trace("\t\t*****GREEN ME!*****\n");
					greenNode.greenCity();
					greenCount++;
					
				} else {
					//trace("\t\tgreen me soon!\n");
				}
	
			}

			
		}
		
		//green the world
		public function greenWorld():void {
			trace("NavWorld::greenWorld");

			TweenLite.to(_world.black_mc, 0.6, {alpha:0, ease:Linear.easeOut});
			TweenLite.to(_world.green_mc, 2, {alpha:1, delay: 1.2, ease:Linear.easeIn});
		}
		
		// ------------------------------------
		// EVENT METHODS
		// ------------------------------------
		
		private function nodeMouseOverHandler (event:MouseEvent):void{
			trace("NavWorld::nodeMouseOverHandler");
			
			// THE TYPE OF THE event.currentTarget and event.target
			// is by default a DisplayObject
			//var s:Sprite = Sprite(event.currentTarget);
			var n:NavNodeCity = NavNodeCity(event.currentTarget);
			//bring current node to the front
			addChild(n);
			
			//addChild(event.currentTarget as Sprite);
			n.labelBg.visible = true;
			TweenLite.to(n.base, 0.2, {scaleX:1.4, scaleY:1.4, ease:Quad.easeOut});
		}
		
		private function nodeMouseOutHandler (event:MouseEvent):void{
			trace("NavWorld::nodeMouseOutHandler");
			var n:NavNodeCity = NavNodeCity(event.currentTarget);
			if (!n.isOn){
				n.labelBg.visible = false;
			}
			TweenLite.to(n.base, 0.2, {scaleX:1, scaleY:1, ease:Quad.easeIn});
		}
		
		private function nodeClickHandler (event:MouseEvent):void{
			trace("NavWorld::nodeClickHandler");
			
			//trace("\tevent.currentTarget is: "+event.currentTarget);
			//trace("\t_nodeDictionary[event.currentTarget] is: "+_nodeDictionary[event.currentTarget]);
			select(_nodeDictionary[event.currentTarget])
		}
		
	}
}
