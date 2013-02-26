package skyline.ui{

	/**
	Constructs a 

	*/

	import flash.display.*;
	import flash.events.*;
	import flash.utils.*;
	//import gs.TweenLite;
	//import gs.easing.*;
	import com.greensock.TweenLite;
	import com.greensock.easing.*;

	public class Nav extends Sprite {
		
		private static const POS_X = 0;
		private static const POS_Y = 0;
		private var _colCount:uint = 8;  //number of columns in menu grid
		private var _array:Array;
		private var _nodeDictionary:Dictionary;
		private var _nodeArray:Array; // you could optionally store this data in the main _array object

		// ------------------------------------
		// CONSTRUCTOR
		// ------------------------------------

		public function Nav (array:Array) {
			trace("Nav");	
			_array = array;
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
			trace("Nav::create");
			
			_nodeDictionary = new Dictionary();
			_nodeArray = new Array();
			
			var count:int = _array.length;
			for ( var i:int=0; i<count; i++ ) {
				
				var node:NavNode = new NavNode();
				node.x = getPositionX(node, i);
				node.y = getPositionY(node, i);
				trace("\nplacing node "+i+"at position: ("+node.x+", "+node.y+")");
								
				_nodeDictionary[node] = i;
				_nodeArray.push(node);
				node.addEventListener(MouseEvent.MOUSE_OVER, nodeMouseOverHandler, false, 0, true);
				node.addEventListener(MouseEvent.MOUSE_OUT, nodeMouseOutHandler, false, 0, true);
				node.addEventListener(MouseEvent.CLICK, nodeClickHandler, false, 0, true);
				//var fileName:String = _array[i].path;
				//node.load("_assets/thumbnails/"+fileName);
				
				node.load(_array[i]);
				addChild(node);
			}
			
		}
		
		// ------------------------------------
		// METHODS
		// ------------------------------------
		
		public function getPositionX (sprite:Sprite, value:int):Number{
			trace("Nav::getPositionX");
			var r:uint = value%_colCount;
			//return (sprite.width + 2) * value;
			return (sprite.width + 2) * r;
		}
		
		public function getPositionY (sprite:Sprite, value:int):Number{
			trace("Nav::getPositionY");
			var n:uint = Math.floor(value/_colCount);
			return (sprite.height + 2) * n;
			//return 0;
		}
		
		public function select (id:int):void{
			trace("Nav::select for "+id);
			
			// update the look of the nav
			var count:int = _nodeArray.length;
			for ( var i:int=0; i<count; i++ ) {
				
				var node:NavNode = _nodeArray[i];
				
				if (i == id) {
					node.select();
				} else {
					node.deselect();
				}
	
			}
			
			// dispatch a call to our custom event
			var e:NavEvent = new NavEvent(NavEvent.SELECT, id);
			dispatchEvent(e);
		}
		
		// ------------------------------------
		// EVENT METHODS
		// ------------------------------------
		
		private function nodeMouseOverHandler (event:MouseEvent):void{
			trace("Nav::nodeMouseOverHandler");
			
			// THE TYPE OF THE event.currentTarget and event.target
			// is by default a DisplayObject
			//var s:Sprite = Sprite(event.currentTarget);
			var n:NavNode = NavNode(event.currentTarget);
			//addChild(n);
			
			//addChild(event.currentTarget as Sprite);
			TweenLite.to(n.border, 0.25, {scaleX:1, scaleY:1, ease:Quad.easeOut});
		}
		
		private function nodeMouseOutHandler (event:MouseEvent):void{
			trace("Nav::nodeMouseOutHandler");
			var n:NavNode = NavNode(event.currentTarget);
			TweenLite.to(n.border, 0.25, {scaleX:1, scaleY:1, ease:Quad.easeIn});
		}
		
		private function nodeClickHandler (event:MouseEvent):void{
			trace("Nav::nodeClickHandler");
			
			//trace("\tevent.currentTarget is: "+event.currentTarget);
			//trace("\t_nodeDictionary[event.currentTarget] is: "+_nodeDictionary[event.currentTarget]);
			select(_nodeDictionary[event.currentTarget])
		}
		
	}
}










