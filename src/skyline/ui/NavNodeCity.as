package skyline.ui{

	/**
	Constructs a 

	*/

	import flash.display.*;
	import flash.net.*;
	import flash.events.*;
	import flash.geom.ColorTransform;
	import flash.text.*;

	import com.greensock.TweenLite;
	import com.greensock.easing.*;

	public class NavNodeCity extends Sprite {
		private var _city:City;
		
		private var _bg:Sprite;
		
		//private var _mask:Sprite;
		//private var _border:Sprite;
		
		private var _highlight:Sprite;
		private var _labelField:TextField;
		private var _labelBg:Sprite;
		
		private var _base:Sprite;
		
		//state
		private var _isOn:Boolean;
		private var _flag:Flag;
		
		// ------------------------------------
		// CONSTRUCTOR
		// ------------------------------------

		public function NavNodeCity (pCity:City=null) {
			trace("NavNodeCity");
			_city = pCity;
			create();
		}

		// ------------------------------------
		// ACCESSORS
		// ------------------------------------
		public function get city():City { return _city; }
		public function get bg():Sprite { return _bg; }
		
		//public function get border ():Sprite { return _border; }
		public function get base ():Sprite { return _base; }
		//public function get highlight ():Sprite { return _highlight; }

		public function get labelBg():Sprite{ return _labelBg; }
		public function get labelField():TextField { return _labelField; }
		
		public function get isOn():Boolean { return _isOn; }
		// ------------------------------------
		// INIT METHODS
		// ------------------------------------

		// ------------------------------------
		// CREATE / DESTROY
		// ------------------------------------
		private function create ():void{
			trace("NavNodeCity::create");
			_bg = Drawer.createFill(-4, -4, 8, 8, 0x000000, 0);
			_labelBg = Drawer.createFill(0, 0, 96, 16, 0xFFFFFF, 0.8);
			_labelField = Texter.createMultiLineField(96, 11, 0x333333);
		
			_labelField.x = (_labelBg.width - _labelField.width)/2;
			_labelField.y = (_labelBg.height - _labelField.height)/2;
			
			_labelBg.addChild(_labelField);
			
			_base = Drawer.createFill(-4,-4,8,8,0x776032,1);
				
	
			//show label only on mouseover
			_labelField.text = _city.name;
			_labelBg.visible = false;
			_labelBg.x = 12;
			_labelBg.y = -6;
			
			_bg.addChild(_base);
			_bg.addChild(_labelBg);
			addChild(_bg);
		}
		
		// ------------------------------------
		// METHODS
		// ------------------------------------
		
		public function select ():void{
			trace("NavNodeCity::select");
			_isOn = true;
			_labelBg.visible = true;
			//_highlight.visible = true;
			var ct:ColorTransform = new ColorTransform();
			ct.color = 0x669900;
			_base.transform.colorTransform = ct;
		}
		
		public function deselect ():void{
			trace("NavNodeCity::deselect");
			_isOn = false;
			_labelBg.visible = false;
			if (!_city.isGreen){
				var ct:ColorTransform = new ColorTransform();
				ct.color = 0x776032;
				_base.transform.colorTransform = ct;
			}
		}
		

		
		//green it
		public function greenCity():void{
			trace("NavNodeCity::greenCity");
			_flag = new Flag();
			_flag.scaleX = _flag.scaleY = 0.33;
			_flag.x = _base.x;
			_flag.y = _base.y;
			_base.addChild(_flag);
			var ct:ColorTransform = new ColorTransform();
			ct.color = 0x669900;
			_base.transform.colorTransform = ct;
		}
		
		// ------------------------------------
		// EVENT METHODS
		// ------------------------------------
		

	}
}