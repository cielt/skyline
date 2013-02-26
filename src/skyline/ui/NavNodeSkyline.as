package skyline.ui{

	/**
	Constructs a 

	*/

	import flash.display.*;
	import flash.net.*;
	import flash.events.*;
	import flash.text.*;
	import flash.geom.ColorTransform;

	import com.greensock.TweenLite;
	import com.greensock.easing.*;

	public class NavNodeSkyline extends Sprite {

		private var _project:Project;
		
		//private var _loader:Loader;
		private var _bg:Sprite;
		private var _border:Sprite;
		private var _highlight:Sprite;
		
		//label
		private var _labelField:TextField;
		private var _labelBg:Sprite;
		//private var _flourish:Sprite;
		
		//state, tracking
		private var _isOn:Boolean = false;
		private var _selectCount:int = 0;
		
		// ------------------------------------
		// CONSTRUCTOR
		// ------------------------------------
		public function NavNodeSkyline (pProject:Project) {
			trace("NavNodeSkyline");
			_project = pProject;
			create();
		}

		// ------------------------------------
		// ACCESSORS
		// ------------------------------------
		public function get project():Project { return _project; }
		
		public function get border():Sprite { return _border; }
		public function get highlight():Sprite { return _highlight; }
		
		public function get labelField():TextField {return _labelField;}
		public function get labelBg():Sprite { return _labelBg; }
		public function get isOn():Boolean { return _isOn; }
		public function get selectCount():int { return _selectCount; }
		
		// ------------------------------------
		// INIT METHODS
		// ------------------------------------

		
		// ------------------------------------
		// CREATE / DESTROY
		// ------------------------------------
		
		private function create ():void{
			trace("NavNodeSkyline::create");
			//bg
			_bg = Drawer.createFill(0, 0, this.project.nodeW, this.project.nodeH, 0x00FF00, 0);	
			
			// highlight
			_highlight = Drawer.createFill(0, 0, this.project.nodeW, this.project.nodeH, 0x99FF33, 1);
			_highlight.alpha = 0;
			_bg.addChild(_highlight);
			
			// border
			_border = Drawer.createBorder(0, 0, this.project.nodeW, this.project.nodeH, 1, 0x99FF33, 1);
			_border.alpha = 0;
			_bg.addChild(_border);
				
			//label
			_labelBg = Drawer.createFill(0, 0, 128, 48, 0x333333, 1);
			_labelField = Texter.createMultiLineField(128, 11, 0xFFFFFF);
			_labelField.text = this.project.title;
			_labelField.x = (_labelBg.width - _labelField.width)/2;
			_labelField.y = (_labelBg.height - _labelField.height)/2;
			_labelBg.addChild(_labelField);
			_labelBg.x = _border.x + _border.width + 8;
			_labelBg.y = -12;
			_labelBg.alpha = 0;
			_labelBg.visible = false;
			_bg.addChild(_labelBg);
			
			addChild(_bg);
		}
		
		// ------------------------------------
		// METHODS
		// ------------------------------------
		
		public function select ():void{
			trace("NavNodeSkyline::select");
			_isOn = true;
			_selectCount++;
			//var ct:ColorTransform = new ColorTransform();
			//ct.color = 0x99FF33;
			//_border.transform.colorTransform = ct;
			_labelBg.visible = true;
			TweenLite.to(_labelBg, 0.4, {alpha:0.8, ease:Back.easeIn });
			TweenLite.to(_highlight, 0.4, {alpha:0.2, ease:Back.easeIn });
			TweenLite.to(_border, 0.4, {alpha:0.8, ease:Back.easeIn });
			trace("my selectCount = "+_selectCount);
		}
		
		public function deselect ():void{
			_isOn = false;
			trace("NavNodeSkyline::deselect");
			TweenLite.to(_labelBg, 0.2, {alpha:0, ease:Back.easeIn });
			_labelBg.visible = false;
			TweenLite.to(_highlight, 0.2, {alpha:0, ease:Back.easeIn });
			TweenLite.to(_border, 0.2, {alpha:0, ease:Back.easeOut });
		}
		
		
		// ------------------------------------
		// EVENT METHODS
		// ------------------------------------
		
		
		
	}
}