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
	
	public class SkylinePlayable extends Sprite {

		private static const HAZE_FACTOR = 0.72;
		
		private var _pathSkyline:String;  //path to actual image of skyline
				
		private var _bg:Sprite;
		private var _haze:Sprite;
		private var _nodeLayer:Sprite;  //add nodes as children of this; place over rest of the nav / skyline
		private var _border:Sprite;
		private var _loaderSkyline:Loader;
		
		private var _navLayer:Sprite;  //cursor moves around--above other layers
		private var _cursor:Arrow;  //moves around
		
		private var _mask:Sprite;  //for skyline loader 
	
		//TIMER
		private var _moveTimer:Timer;
		private var _hotSpots:Array;  //store in here the coords of building locations
		private var _nodes:Array;  //nodes to show on mouseover
		
		private var _currHotIndex:int = 0;
		
		//MESSAGE
		private var _messageField:TextField;
		private var _bgMessage:Sprite;
		
		private var _buttonStart:Sprite; //click to begin
		
		// ------------------------------------
		// CONSTRUCTOR
		// ------------------------------------

		public function SkylinePlayable (pPath:String="") {
			trace("SkylinePlayable");	
			_pathSkyline = pPath;	
			create();
		}

		// ------------------------------------
		// ACCESSORS
		// ------------------------------------
		public function get haze():Sprite{ return _haze; }
		public function get border():Sprite { return _border; }

		// ------------------------------------
		// INIT METHODS
		// ------------------------------------
		private function init():void {
			trace("SkylinePlayable::init");
			//button start
			//_buttonStart.addEventListener(MouseEvent.CLICK, onButtonStartClick, false, 0, true);
			_buttonStart.buttonMode = true;
			_buttonStart.mouseChildren = false;
			_buttonStart.useHandCursor = true;
			
			_moveTimer = new Timer(2800, 0);

			//create, populate hot spots array
			_hotSpots = new Array();
			//nodes
			var n0:Sprite = Drawer.createNode(440, 20, 36, 148);
			var n1:Sprite = Drawer.createNode(80, 55, 45, 108);
			var n2:Sprite = Drawer.createNode(88, 88, 76, 108);
			n0.visible = false;
			n1.visible = false;
			n2.visible = false;
			n0.alpha = 0;
			n1.alpha = 0;
			n2.alpha = 0;
			_nodeLayer.addChild(n0);
			_nodeLayer.addChild(n1);
			_nodeLayer.addChild(n2);
			
			
			var p0 = new Object();
			p0 = {pX:440, pY:20, node:n0};
			var p1 = new Object();
			p1 = {pX:80, pY:55, node:n1};
			var p2 = new Object();
			p2 = {pX:88, pY:88, node: n2};
			_hotSpots.push(p0,p1,p2);
			trace("_hotSpots contains: "+_hotSpots);
			
			//listen for addition to / removal from stage
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage, false, 0, true);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage, false, 0, true);
		}
		

		// ------------------------------------
		// CREATE / DESTROY
		// ------------------------------------
		
		public function create ():void{
			trace("SkylinePlayable::create");
					
			//set up bg stuff
			_bg = Drawer.createFill(0, 0, 900, 215, 0xFFFFFF, 0.2);
			
			// loader for skyline
			_loaderSkyline = new Loader();

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
			
			// navLayer
			_navLayer = Drawer.createFill(0,0,900,215,0x00FFFF, 0);
			_bg.addChild(_navLayer);
			
			// border
			_border = Drawer.createBorder(0,0,900,215,1,0x333333,1);

			_bg.addChild(_border);
			addChild(_bg);
			
			//POINTER, etc.
			_cursor = new Arrow();			
			_cursor.scaleX = _cursor.scaleY = 0.18;
			_cursor.rotation = -120;
			_cursor.x = 120;
			_cursor.y = 120;
			
			_navLayer.addChild(_cursor);
			
			//MESSAGE BOARD
			_bgMessage = Drawer.createFill(0,0,332,199,0x333333,0.8);
			var msgBorder:Sprite = Drawer.createBorder(0,0,332,199,1,0x99CC33,1);
			var messageSS:StyleSheet = Texter.createOverlayStylesheet();
			_messageField = Texter.createMultiLineField(312, 11, 0xFFFFFF);
			_messageField.styleSheet = messageSS;
			_messageField.htmlText = "<body><span class='title1'>CCI is Greening our Cities</span><br /><span class='emph'>Mouse over buildings in the skyline to learn more about CCI building retrofit projects</span></body>";
			_messageField.x = (_bgMessage.width - _messageField.width)/2;
			//_messageField.y = (_bgMessage.height - _messageField.height)/2;
			_messageField.y = 8;
			_bgMessage.addChild(msgBorder);
			_bgMessage.addChild(_messageField);
			
			//try on top of everything
			_bgMessage.x = _bg.width - _bgMessage.width -8;
			_bgMessage.y = 8;
			addChild(_bgMessage);
			
			//start button
			_buttonStart = Drawer.createRoundRectBorderFill(0,0,128,32, 8, 0xFFFFFF, 0x99CC33,0.8);
			var buttonLabel:TextField = Texter.createMultiLineField(108, 24, 0xFFFFFF);
			buttonLabel.htmlText = "<b>Begin</b>";
			buttonLabel.x = (_buttonStart.width - buttonLabel.width)/2;
			_buttonStart.addChild(buttonLabel);
			buttonLabel.y = (_buttonStart.height - buttonLabel.height)/2;
			_buttonStart.x = _messageField.width - _buttonStart.width - 8;
			_buttonStart.y = _messageField.y + _messageField.height + 48;
			_bgMessage.addChild(_buttonStart);
			init();
		}
		
		//destroy
		private function destroyPlayable():void {
			trace("SkylinePlayable::destroyPlayable");
		}
		// ------------------------------------
		// METHODS
		// ----------------------- -------------
		public function loadSkyline (path:String):void{
			trace("SkylinePlayable::loadSkyline");
			
			var request:URLRequest = new URLRequest(path);
			_loaderSkyline.load(request);
		}
		
		//check this
		public function brighten(increment:Number) {
			var diff:Number = HAZE_FACTOR/increment;
			trace("SkylinePlayable::brighten\n about to brighten skyline by a change of "+diff);
			//_haze.alpha -= diff;
			var toAlpha:Number = _haze.alpha - diff;
			if (toAlpha >= -1){
				TweenLite.to(_haze, 1.2, {alpha:toAlpha, ease:Quad.easeOut});
			}else{
				_haze.alpha = 0;
			}
			trace("haze alpha is now: "+_haze.alpha);
		}
		
		
		
		// ------------------------------------
		// EVENT METHODS
		// ------------------------------------
		//on added to stage
		private function onAddedToStage(event:Event):void {
			trace("onAddedToStage");
			//add listeners, etc.
			_moveTimer.addEventListener(TimerEvent.TIMER, onMoveTimer, false, 0, true);
			_moveTimer.start();
			
			_loaderSkyline.contentLoaderInfo.addEventListener(Event.COMPLETE, completeHandler);
			_loaderSkyline.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			_loaderSkyline.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			
			_buttonStart.addEventListener(MouseEvent.CLICK, onButtonStartClick, false, 0, true);
		}
		
		//on removed from stage
		private function onRemovedFromStage(event:Event):void {
			trace("\t\t\t\t\t>>>>>>>>>>>>>>>>>>>>>>>>>>>onRemovedFromStage");
			//remove listeners, etc.
			_moveTimer.stop();
			_moveTimer.removeEventListener(TimerEvent.TIMER, onMoveTimer);
			
			
			_loaderSkyline.contentLoaderInfo.removeEventListener(Event.COMPLETE, completeHandler);
			_loaderSkyline.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			_loaderSkyline.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, progressHandler);
		
			_buttonStart.removeEventListener(MouseEvent.CLICK, onButtonStartClick);
		}
		
		//button
		private function onButtonStartClick(event:MouseEvent):void {
			trace("onButtonStartClick");
			var e:MeterEvent = new MeterEvent(MeterEvent.METER_START);
			dispatchEvent(e);
		}
		
		
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
		
		
		//MOVE CURSOR!
		private function onMoveTimer(event:TimerEvent):void {
			trace("SkylinePlayable::onMoveTimer");
			
			var onIt:Object = _hotSpots[_currHotIndex];
			var toX:Number = onIt.pX;
			var toY:Number = onIt.pY;
			
			TweenLite.to(_cursor, 0.8, {x:toX+15, y:toY+30, onComplete:onCursorMove, ease:Quad.easeOut});
				
		}
		
		private function onCursorMove():void {
			trace("\t\t\t>>>>>>>>>>>>>>>>>>>SkylinePlayable::onCursorMove");
			//hide stuff that's not current
			for (var notIt:int=0; notIt<_hotSpots.length; notIt++){
					if (_hotSpots[notIt].node.visible){
					_hotSpots[notIt].node.visible = false;
				}

			}
			var onIt:Object = _hotSpots[_currHotIndex];
			var currNode = onIt.node;
			currNode.visible = true;
			TweenLite.to(currNode, 0.8, {alpha:1, delay: 0, ease: Linear.easeIn});
			brighten(_hotSpots.length);
			
			//update current index
			if(_currHotIndex < _hotSpots.length-1){
				_currHotIndex++;
			}else {
				_currHotIndex = 0;
			}
			trace("new _currHotIndex = "+_currHotIndex);
		}

	}
}
