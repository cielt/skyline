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
	import flash.geom.ColorTransform;

	import com.greensock.TweenLite;
	import com.greensock.easing.*;

	public class InfoPane extends Sprite {

		private var _bg:Sprite;
		private var _mask:Sprite;

		private var _titleText:TextField;
		private var _descText:TextField;
		private var _bgLoader:Sprite; //bg for Loader
		private var _loader:Loader;  //for image
		
		//bg for actions
		private var _bgActions:Sprite;
		private var _actionNodes:Array = new Array();  //array of sprites / buttons as calls to action
		
		// ------------------------------------
		// CONSTRUCTOR
		// ------------------------------------

		public function InfoPane () {
			trace("InfoPane");
			
			create();
		}

		// ------------------------------------
		// ACCESSORS
		// ------------------------------------
		public function get titleTextField():TextField { return _titleText;  }
		public function get descTextField():TextField { return _descText;  }
		public function get loader():Loader { return _loader;  }

		// ------------------------------------
		// INIT METHODS
		// ------------------------------------

		// ------------------------------------
		// CREATE / DESTROY
		// ------------------------------------
		
		private function create ():void{
			trace("InfoPane::create");
			_bg = Drawer.createFill(0, 0, 540, 248, 0xA4AA4C, 0);
			//make this now but add it in later
			_bgActions = Drawer.createFill(0,0,264,76,0x99CC33,0.2);
			
			//text fields
			_titleText = Texter.createOneLineField(532,32,21,0xA4AA4C, false);
			_titleText.text = "";
			
			//text field + stylesheet
			var descStyle:StyleSheet = Texter.createStylesheet();
			_descText = Texter.createMultiLineField(264,12,0x666666);
			_descText.styleSheet = descStyle;
			_descText.htmlText = "";
			
			// loader container
			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeHandler);
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			_loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			
			_bgLoader = Drawer.createFill(0,0,240,180,0xFFFFFF,0.1);
			
			// masks!!!
			_mask = Drawer.createFill(0,0,240,200,0x00FF00,1);
			_loader.mask = _mask;
			//_titleText.x = (_bg.width - _titleText.width)/2;
			_titleText.x = (_bg.width - 532)/2;
			_titleText.y = 6;
			_bg.addChild(_titleText);
			//_descText.y = (_titleText.y + _titleText.height +8);
			_descText.y = (_titleText.y + 32 +8);
			
			_bg.addChild(_descText);
			_bgLoader.addChildAt(_loader, 0);
			_bgLoader.addChild(_mask);
					
			//_bgLoader.y = _titleText.y + _titleText.height +8;
			_bgLoader.y = _titleText.y + 32 +8;
			_bgLoader.x = 12;
			_descText.x = _bgLoader.x + _bgLoader.width + 12;
			_bg.addChild(_bgLoader);
	
			trace("about to add InfoPane to stage");
			addChild(_bg);

		}
		
		// ------------------------------------
		// METHODS
		// ------------------------------------
		
		public function load (path:String):void{
			trace("InfoPane::load");
			
			var request:URLRequest = new URLRequest(path);
			_loader.load(request);
		}
		
		//reset
		public function resetPane():void {
			trace("InfoPane::resetPane");
			clearActions();
			_loader.unload();
			var imgPath:String = "_assets/images/polar_bears_280.jpg";
			load(imgPath);
			_titleText.text = "Save Us Please!";
			_descText.htmlText = "<span class='title2'>learn how CCI's Building Retrofit initiative can lead to clearer skylines and a greener planet</span>";
		}
		
		//display calls to action!!!
		public function showActions(pActions:Array):void {

			trace("\t\t\t>>>>>>>>>>>>>>>>>>>>InfoPane::showActions");
			for (var a:int=0; a<pActions.length; a++){
				var aInfo:Object = pActions[a];
				trace("aInfo = "+aInfo.type);
				switch (aInfo.type){
					case "learn":
						trace ("\tlearn more");
						var t_learn:TextField = Texter.createMultiLineField(180, 14, 0xA4AA4C);
						t_learn.htmlText = "<body><a href=\'"+aInfo.url+"\' target='_blank'>"+aInfo.label+"</a>";
						_actionNodes.push(t_learn);
						break;
					
					case "support":
						trace ("\tsupport");
						var t_support:TextField = Texter.createMultiLineField(180, 14, 0xA4AA4C);
						t_support.htmlText = "<body><a href=\'"+aInfo.url+"\' target='_blank'>"+aInfo.label+"</a>";
						_actionNodes.push(t_support);

						break;	
					default:
					trace ("do something");
				}
				
				for (var n:int=0; n<_actionNodes.length; n++){

					var node:DisplayObject = _actionNodes[n]; 
					node.y = getButtonPosY(node, n);
					_bgActions.addChild(node);
				}
				
				//add actions!
				_bgActions.x = _descText.x;
				_bgActions.y = _descText.y + _descText.height + 8;
				_bg.addChild(_bgActions);
			}
		
			
		}
		
		
		public function getButtonPosX (thing:DisplayObject, value:int):Number{
			trace("InfoPane::getButtonPosX");
			//var r:uint = value%_colCount;
			//return (sprite.width + 2) * value;
			return (thing.width + 2) * value;
		}
		
		public function getButtonPosY (thing:DisplayObject, value:int):Number{
			trace("InfoPane::getButtonPosY");
			//var n:uint = Math.floor(value/_colCount);
			return (thing.height + 8) * value;
			//return 0;
		}
		
		//CREATE action button
		private function createButton(btnLabel:String, btnURL:String):Sprite {
			trace("InfoPane::createLearnButton");
			var bgButton:Sprite = Drawer.createRoundRectBorderFill(0,0,148,20,8,0xFFFFFF, 0x99CC33,1);
			var lbl:TextField = Texter.createMultiLineField(140,12,0xFFFFFF);
			lbl.text=btnLabel;
			lbl.x = (bgButton.width - lbl.width)/2;
			lbl.y = (bgButton.height - lbl.height)/2;
			bgButton.addChild(lbl);
			bgButton.buttonMode = true;
			bgButton.mouseChildren = false;
			bgButton.useHandCursor = true;
			bgButton.addEventListener(MouseEvent.CLICK, onLearnButtonClick, false, 0, true);
			return bgButton;
		}
		
		//CLEAR ACTIONS; remove pane
		public function clearActions():void {
			trace("InfoPane::clearActions");
			if(_bgActions.numChildren>0){
				while (_bgActions.numChildren>0){
					_bgActions.removeChildAt(0);
				}
				_bg.removeChild(_bgActions);
				//clear _actionNodes[]
				for (var n:int=_actionNodes.length; n>0; n--){
					_actionNodes.pop();
				}
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
 		
			//_loader.x = (0 - event.currentTarget.width)/2;
			//_loader.y = (0 - event.currentTarget.height)/2;
		}
        
		private function ioErrorHandler(event:IOErrorEvent):void {
		    trace("ioErrorHandler: " + event);
		}
        
		private function progressHandler(event:ProgressEvent):void {
		    trace("progressHandler: bytesLoaded=" + event.bytesLoaded + " bytesTotal=" + event.bytesTotal);
		}
		
		//make this generic
		private function onLearnButtonClick (event:MouseEvent):void{
			trace("InfoPane::onLearnButtonClick");
			
			trace("\tevent.currentTarget is: "+event.currentTarget);
			//trace("\t_nodeDictionary[event.currentTarget] is: "+_nodeDictionary[event.currentTarget]);
			//select(_nodeDictionary[event.currentTarget])
		}
	}
}