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

	public class ForestPane extends Sprite {
		public static const VEIL_ALPHA:Number = 0.72;
		private var _holder:Sprite;
		
		//env stuff
		private var _holderEnv:Sprite;
		private var _loaderEnv:Loader; 
		private var _maskEnv:Sprite;
		private var _veilEnv:Sprite;  //covers the env image; to be revealed as projects found
		
		
		//message
		private var _messageOverlay:Sprite;
		private var _messageText:TextField;
		
		// ------------------------------------
		// CONSTRUCTOR
		// ------------------------------------

		public function ForestPane () {
			trace("ForestPane");
			create();
		}

		// ------------------------------------
		// ACCESSORS
		// ------------------------------------
		public function get holder():Sprite { return _holder; }
		public function get messageOverlay():Sprite { return _messageOverlay; }

		
		// ------------------------------------
		// INIT METHODS
		// ------------------------------------


		// ------------------------------------
		// CREATE / DESTROY
		// ------------------------------------		
		private function create ():void{
			trace("ForestPane::create");
			_holder = Drawer.createFill(0, 0, 240, 215, 0x000000, 0.8);
			
			//MESSAGE
			_messageOverlay = Drawer.createFill(0, 0, 240, 48, 0x333333, 0.8); 
			_messageText = Texter.createMultiLineField(224,13,0xFFFFFF);
			_messageText.x = (_messageOverlay.width - _messageText.width)/2;
			_messageText.y = 4;
			_messageText.htmlText = "Every time we reduce CO2 emissions by 1 ton, our forests breathe easier...";
			_messageOverlay.addChild(_messageText);
			
			//LOADER for env image
			_loaderEnv = new Loader();
			_loaderEnv.contentLoaderInfo.addEventListener(Event.COMPLETE, completeHandler);
			_loaderEnv.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			_loaderEnv.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			
			

			// masks!!!!
			_holderEnv = Drawer.createFill(0,0,232,207,0x333333,1);
			_maskEnv = Drawer.createFill(0,0,232,207,0x00FF00,1);
			_veilEnv = Drawer.createFill(0,0,232,207,0xFFFFFF,1);
			_veilEnv.alpha = VEIL_ALPHA;
			_holderEnv.mask = _maskEnv;
			
			_holderEnv.addChildAt(_loaderEnv, 0);
			//_holderEnv.addChild(_maskEnv);
			_holderEnv.addChild(_veilEnv);
			_holderEnv.addChild(_messageOverlay);
			_holderEnv.addChild(_maskEnv);
			
			//position it
			_holderEnv.x = (_holder.width - _holderEnv.width)/2;
			_holderEnv.y = (_holder.height - _holderEnv.height)/2;
			_holder.addChild(_holderEnv);
			
			addChildAt(_holder, 0);
			//_messageOverlay.y = _holder.height - _messageOverlay.height;
			_messageOverlay.y = _holder.height;
		}
		
		// ------------------------------------
		// METHODS
		// ------------------------------------	
		//load the env image
		public function loadEnv (path:String):void{
			trace("ForestPane::loadEnv");
			var request:URLRequest = new URLRequest(path);
			_loaderEnv.load(request);
		}
		
		//reveal!
		public function reveal(increment:Number) {
			var diff:Number = VEIL_ALPHA/increment;
			//trace("\tForestPane::reveal about to brighten env by a change of "+diff+"\ncurrent alpha = "+_veilEnv.alpha);
			var toAlpha:Number = _veilEnv.alpha - diff;
			if (toAlpha > -0.2){
				TweenLite.to(_veilEnv, 0.8, {alpha:toAlpha, delay: 1.2, ease:Linear.easeOut});
			}else{
				_veilEnv.alpha = 0;
			}
			
		}
		
		// ------------------------------------
		// EVENT METHODS
		// ------------------------------------
		private function completeHandler(event:Event):void {
		    trace("completeHandler: " + event);
		
			trace("\tevent.target.width is: "+event.target.width);
			trace("\tevent.currentTarget.width is: "+event.currentTarget.width);
			trace("\tevent.currentTarget.type is: "+event.currentTarget.toString());
 		
			_loaderEnv.x = -8;
			_loaderEnv.y = -8;
		}
        
		private function ioErrorHandler(event:IOErrorEvent):void {
		    trace("ioErrorHandler: " + event);
		}
        
		private function progressHandler(event:ProgressEvent):void {
		    trace("progressHandler: bytesLoaded=" + event.bytesLoaded + " bytesTotal=" + event.bytesTotal);
		}
		
		
	}
}