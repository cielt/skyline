package skyline.ui{

	/**
	Constructs a 
	*/

	import flash.net.*;
	import flash.events.*;

	public class City extends EventDispatcher {

		private var _cityName:String;
		//private var _cityInfo:String;
		//private var _pathImage:String;
		
		//nav related
		private var _cityPosX:Number;
		private var _cityPosY:Number;
		
		//path to skyline, dir
		private var _pathSkyline:String;
		private var _pathEnv:String;
		private var _nameImageDir:String;
		
		//projects data
		private var _projects:Array;
		
		//state
		private var _isGreen:Boolean = false;
		
		// ------------------------------------
		// CONSTRUCTOR
		// ------------------------------------

		public function City(pos_x:int=0, pos_y:int=0, name:String="", pathSky:String="", projects:Array=null) {
			trace("City");
			_cityPosX = pos_x;
			_cityPosY = pos_y;
			_cityName = name;
			_pathSkyline = pathSky;
			_projects = projects;			
		}

		
		
		// ------------------------------------
		// ACCESSORS
		// ------------------------------------
		public function get name():String { return _cityName };
		public function set name(value:String) { _cityName = value };
		
		/* nav related */
		public function get cityPosX():Number { return _cityPosX; }
		public function set cityPosX(value:Number) { _cityPosX = value; }
		
		public function get cityPosY():Number { return _cityPosY; }
		public function set cityPosY(value:Number) { _cityPosY = value; }
		
		//PROJECTS
		public function get projects():Array { return _projects; }
		public function set projects(value:Array){ _projects = value; } 
		
		public function get pathSkyline():String { return _pathSkyline; }
		public function set pathSkyline(value:String){ _pathSkyline = value; }
		
		public function get pathEnv():String { return _pathEnv; }
		public function set pathEnv(value:String){ _pathEnv = value; }
		
		public function get nameImageDir():String { return _nameImageDir; }
		public function set nameImageDir(value:String){ _nameImageDir = value; }
		
		public function get isGreen():Boolean { return _isGreen; }
		public function set isGreen(value:Boolean):void { _isGreen = value; }
		
		// ------------------------------------
		// INIT METHODS
		// ------------------------------------

		
		// ------------------------------------
		// CREATE / DESTROY
		// ------------------------------------
		
		
		// ------------------------------------
		// METHODS
		// ------------------------------------
		public override function toString():String {
			trace("City::toString");
			var result:String = ("city name: "+this._cityName+"\ncity posX: "+this._cityPosX+"\ncity posY: "+this._cityPosY+"\ncity projects: "+this._projects+"\n");
			return result;
		}
		
		
		// ------------------------------------
		// EVENT METHODS
		// ------------------------------------

	}
}