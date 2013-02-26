package skyline.ui{

	/**
	Constructs a 

	*/

	import flash.display.*;
	import flash.net.*;
	import flash.events.*;
	import flash.geom.ColorTransform;
	//import gs.TweenLite;
	//import gs.easing.*;
	import com.greensock.TweenLite;
	import com.greensock.easing.*;

	public class NavNode extends Sprite {

		private var _loader:Loader;
		private var _bg:Sprite;
		private var _mask:Sprite;
		private var _border:Sprite;
		private var _cover:Sprite;
		private var _flower:Flower;

		// ------------------------------------
		// CONSTRUCTOR
		// ------------------------------------

		public function NavNode () {
			trace("NavNode");
			
			create();
		}

		// ------------------------------------
		// ACCESSORS
		// ------------------------------------
		public function get border ():Sprite { return _border; }
		public function get cover ():Sprite { return _cover; }

		// ------------------------------------
		// INIT METHODS
		// ------------------------------------

		// ------------------------------------
		// CREATE / DESTROY
		// ------------------------------------
		
		private function create ():void{
			trace("NavNode::create");
			_bg = Drawer.createFill(0, 0, 72, 72, 0xFFFFFF, 1);
			
			// loader container
			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeHandler);
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			_loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			
			// mask
			_mask = Drawer.createFill(0,0,72,72,0x00FF00,1);
			// masks!!!!
			_loader.mask = _mask;
			
			_bg.addChildAt(_loader, 0);
			_bg.addChild(_mask);
			
			// highlight
			_cover = Drawer.createFill(0,0,72,72,0x000000,0.6);
			_cover.visible = false;
			_bg.addChild(_cover);
			
			// border
			_border = Drawer.createBorder(0,0,72,72,1,0x99FF33,1);
			_bg.addChild(_border);
			addChild(_bg);
			_flower = new Flower();
			_flower.visible = false;
			_flower.scaleX = _flower.scaleY = 0.4;
			_flower.x = (_cover.width - _flower.width)/2;
			_flower.y = (_cover.height - _flower.height)/2;			
			_cover.addChild(_flower);
		}
		
		// ------------------------------------
		// METHODS
		// ------------------------------------
		
		public function select ():void{
			trace("NavNode::select");
			_cover.visible = true;
			_flower.visible = true;
			var ct:ColorTransform = new ColorTransform();
			ct.color = 0x99FF33;
			_border.transform.colorTransform = ct;
			TweenLite.to(_flower, 0.2, {tint:0x99FF33, ease:Back.easeIn });
		}
		
		public function deselect ():void{
			trace("NavNode::deselect");
			_cover.visible = false;
			_flower.visible = false;
			var ct:ColorTransform = new ColorTransform();
			ct.color = 0x99FF33;
			_border.transform.colorTransform = ct;
			//TweenLite.to(_flower, 0.2, {tint:0x99FF33, ease:Back.easeIn });
		}
		
		public function load (path:String):void{
			trace("NavNode::load");
			
			var request:URLRequest = new URLRequest(path);
			_loader.load(request);
		}
		
		// ------------------------------------
		// EVENT METHODS
		// ------------------------------------
		
		private function completeHandler(event:Event):void {
		    trace("completeHandler: " + event);
		
			trace("\tevent.target.width is: "+event.target.width);
			trace("\tevent.currentTarget.width is: "+event.currentTarget.width);
			trace("\tevent.currentTarget.type is: "+event.currentTarget.toString());
 		
			_loader.x = (_bg.width - event.currentTarget.width)/2;
			_loader.y = (_bg.height - event.currentTarget.height)/2;
		}
        
		private function ioErrorHandler(event:IOErrorEvent):void {
		    trace("ioErrorHandler: " + event);
		}
        
		private function progressHandler(event:ProgressEvent):void {
		    trace("progressHandler: bytesLoaded=" + event.bytesLoaded + " bytesTotal=" + event.bytesTotal);
		}
	}
}