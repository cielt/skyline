package skyline.ui{

	/**
	Constructs a 

	*/

	import flash.net.*;
	import flash.events.*;

	public class Project extends EventDispatcher {

		private var _title:String;
		private var _description:String;
		private var _pathImage:String;
		
		//nav related
		private var _nodePosX:Number;
		private var _nodePosY:Number;
		private var _nodeW:Number;
		private var _nodeH:Number;

		//calls to action
		private var _actions:Array;
		
		// ------------------------------------
		// CONSTRUCTOR
		// ------------------------------------

		public function Project(pos_x:int=0, pos_y:int=0, w:Number=0, h:Number=0, title:String="") {
			trace("Project");
			_title = title;
			_nodePosX = pos_x;
			_nodePosY = pos_y;
			_nodeW = w;
			_nodeH = h;
		}

		
		
		// ------------------------------------
		// ACCESSORS
		// ------------------------------------
		public function get title():String { return _title };
		public function set title(value:String) { _title = value };
		
		public function get description():String { return _description };
		public function set description(value:String) { _description = value };
		
		public function get pathImage():String { return _pathImage; }
		public function set pathImage(value:String) { _pathImage = value; }
		
		/* nav related */
		public function get nodePosX():Number { return _nodePosX; }
		public function set nodePosX(value:Number) { _nodePosX = value; }
		
		public function get nodePosY():Number { return _nodePosY; }
		public function set nodePosY(value:Number) { _nodePosY = value; }
		
		public function get nodeW():Number { return _nodeW; }
		public function set nodeW(value:Number) { _nodeW = value; }
		
		public function get nodeH():Number { return _nodeH; }
		public function set nodeH(value:Number) { _nodeH = value; }

		//actions
		public function get actions():Array { return _actions; }
		public function set actions(value: Array):void { _actions = value; }
		// ------------------------------------
		// INIT METHODS
		// ------------------------------------

		
		// ------------------------------------
		// CREATE / DESTROY
		// ------------------------------------
		
		
		// ------------------------------------
		// METHODS
		// ------------------------------------
		
		
		// ------------------------------------
		// EVENT METHODS
		// ------------------------------------

	}
}