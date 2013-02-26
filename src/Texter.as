package {
	
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.text.*;
		
	public class Texter extends Sprite {
		// ------------------------------------
		// CONSTRUCTOR
		// ------------------------------------
		public function Texter() {
			trace("Texter");

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
			
		//TEXT
		//create single line textfield
		public static function createOneLineField(w:uint, h:uint, fontSize:uint, color:Number, isBold:Boolean):TextField {
			var tf:TextFormat = new TextFormat();
			//tf.font = "_sans";
			var titleFont = new AdobeGaramondPro();
			//var titleFont = new TradeGothicBoldCond18();
			tf.font = titleFont.fontName;
		
			tf.color = color;
			tf.bold = isBold;
			tf.size = fontSize;
			//tf.leading = 2;
			tf.align = TextFormatAlign.LEFT;
			tf.leftMargin = tf.rightMargin = 0;
			
			var t:TextField = new TextField();
			t.defaultTextFormat = tf;
			t.width = w;
			t.height = h;
			t.border = false;
			t.background = false;
			t.selectable = false;
			t.multiline = false;
			t.type = TextFieldType.DYNAMIC;
			t.wordWrap = false;
			t.autoSize = TextFieldAutoSize.LEFT;
			t.displayAsPassword = false;
			t.htmlText = "info";
			return t;
		}
		
		//create single line textfield
		public static function createOneLineFieldTG(w:uint, h:uint, fontSize:uint, color:Number, isBold:Boolean):TextField {
			var tf:TextFormat = new TextFormat();
			var titleFont = new TradeGothicBoldCond18();
			tf.font = titleFont.fontName;
		
			tf.color = color;
			tf.bold = isBold;
			tf.size = fontSize;
			//tf.leading = 2;
			tf.align = TextFormatAlign.LEFT;
			tf.leftMargin = tf.rightMargin = 0;
			
			var t:TextField = new TextField();
			t.defaultTextFormat = tf;
			t.width = w;
			t.height = h;
			t.border = false;
			t.background = false;
			t.selectable = false;
			t.multiline = false;
			t.type = TextFieldType.DYNAMIC;
			t.wordWrap = false;
			t.autoSize = TextFieldAutoSize.NONE;
			t.displayAsPassword = false;
			t.htmlText = "info";
			return t;
		}
		
		//create single line textfield
		public static function createNumericField(w:uint, h:uint, fontSize:uint, color:Number):TextField {
			var tf:TextFormat = new TextFormat();
			tf.font = "_sans";
			tf.bold = false;
			tf.color = color;
			tf.size = fontSize;
			//tf.leading = 2;
			tf.align = TextFormatAlign.RIGHT;
			tf.leftMargin = tf.rightMargin = 0;
			
			var t:TextField = new TextField();
			t.defaultTextFormat = tf;
			t.width = w;
			t.height = h;
			t.border = false;
			t.background = false;
			t.selectable = false;
			t.multiline = false;
			t.type = TextFieldType.DYNAMIC;
			t.wordWrap = false;
			t.autoSize = TextFieldAutoSize.LEFT;
			t.displayAsPassword = false;
			t.htmlText = "info";
			return t;
		}
		
		
		//create single line textfield
		public static function createMultiLineField(w:uint, fontSize:uint, color:Number):TextField {
			var tf:TextFormat = new TextFormat();
			//var titleFont = new TradeGothicBoldCond18();
			//tf.font = titleFont.fontName;
			tf.font = "_sans";
			tf.color = color;
			tf.bold = false;
			tf.size = fontSize;
			tf.align = TextFormatAlign.LEFT;
			tf.leftMargin = tf.rightMargin = 0;
			
			var t:TextField = new TextField();
			t.defaultTextFormat = tf;
			t.width = w;
			t.border = false;
			t.background = false;
			t.selectable = false;
			t.multiline = true;
			t.type = TextFieldType.DYNAMIC;
			
			t.autoSize = TextFieldAutoSize.LEFT;
			t.wordWrap = true;
			t.displayAsPassword = false;
			t.htmlText = "info";
			return t;
		}
		
	
		
		//INPUT
		public static function createInputField(w:uint, h:uint, borderCol:Number):TextField {
            
         	var format:TextFormat = new TextFormat();
			format.font = "_sans";
			format.size = 12;
			format.color = 0x000000;
			
			var field:TextField = new TextField();
			//trace("initial field height: "+field.height);
			field.autoSize = TextFieldAutoSize.NONE;
			field.multiline = false;
			field.wordWrap = true;
			field.background = true;
			field.backgroundColor = 0xFFFFFF;
			field.border = true;
			field.borderColor = borderCol;
			field.selectable = true;
			field.defaultTextFormat = format;
			field.text = "info";
			field.width = w;
            field.height = h;

			trace("field height: "+field.height);
            return field;
		} 
		
		//stylesheet for scoreboard
		public static function createScoreStylesheet():StyleSheet {
		//trace("Texter::createStylesheet");
			var ss:StyleSheet = new StyleSheet();

	        var green:Object = new Object();
	        green = {color:"#99CC33", fontSize:"24", fontFamily:"Arial, Helvetica, _sans", fontWeight:"normal"};
			
			var white:Object = new Object();
	        white = {color:"#FFFFFF", fontSize:"24", fontFamily:"Arial, Helvetica, _sans", fontWeight:"normal"};
	
			var defaultText:Object = new Object();
	        defaultText = {color:"#999999", fontSize:"24", fontFamily:"Arial, Helvetica, _sans", fontWeight:"normal"};

			var body:Object = new Object();
	        body = {fontSize:"12 ", fontFamily:"Arial, Helvetica, _sans", fontWeight:"normal", fontStyle:"normal", color:"#666666"};

	        ss.setStyle(".green", green);
			ss.setStyle(".white", white);
			ss.setStyle(".defaultText", defaultText);
			ss.setStyle("body", body);
			
			return ss;
		}		
		
		
		//stylesheet for video info
		public static function createStylesheet():StyleSheet {
			//trace("Texter::createStylesheet");
			var ss:StyleSheet = new StyleSheet();

            var heading:Object = new Object();
            heading = {fontWeight:"bold", color:"#FDB913", fontSize:"16", leading:"4", fontFamily:"Arial, Helvetica, _sans"};
			
			var title1:Object = new Object();
            title1 = {color:"#FFFFFF", fontSize:"24", fontFamily:"Arial, Helvetica, _sans", fontWeight:"normal"};
			
			var title2:Object = new Object();
            title2 = {color:"#666666", leading:"4", fontSize:"18", fontFamily:"Georgia, Times New Roman, _serif", fontWeight:"bold", fontStyle:"italic"};
			
			var title3:Object = new Object();
            title3 = {color:"#FFFFFF", leading:"4", fontSize:"14", fontFamily:"Arial, Helvetica, _sans", fontWeight:"bold", fontStyle:"italic"};

			var a:Object = new Object();
			a = {textDecoration:"none", color:"#74A5CD"};
			
			var aHover:Object = new Object();
			aHover = {color:"#6DCFF6",textDecoration:"none"};
			
			var linkMain:Object = new Object();
            linkMain = {color:"#74A5CD", fontSize:"13", leading:"6", fontFamily:"Arial, Helvetica, _sans", fontWeight:"bold", fontStyle:"normal"};

			var linkRelated:Object = new Object();
            linkRelated = {fontFamily:"Arial, Helvetica, _sans", fontWeight:"normal", fontStyle:"normal", leading:"4"};

            var body:Object = new Object();
            body = {fontSize:"12 ", fontFamily:"Arial, Helvetica, _sans", fontWeight:"normal", fontStyle:"normal", color:"#666666"};

            ss.setStyle(".title1", title1);
			ss.setStyle(".title2", title2);
			ss.setStyle(".title3", title3);
            ss.setStyle("body", body);
			ss.setStyle("a", a);
			ss.setStyle("a:hover", aHover);
			ss.setStyle(".heading", heading);
			ss.setStyle(".linkMain", linkMain);
			ss.setStyle(".linkRelated", linkRelated);

			return ss;
		}
		

		//stylesheet for video info
		public static function createOverlayStylesheet():StyleSheet {
			//trace("Texter::createStylesheet");
			var ss:StyleSheet = new StyleSheet();

            var heading:Object = new Object();
            heading = {fontWeight:"bold", color:"#FDB913", fontSize:"24", leading:"4", fontFamily:"Arial, Helvetica, _sans"};
			
			var title1:Object = new Object();
            title1 = {color:"#99CC33", fontSize:"26", fontFamily:"Arial, Helvetica, _sans", fontWeight:"normal"};
			
			var title2:Object = new Object();
            title2 = {color:"#666666", leading:"4", fontSize:"18", fontFamily:"Georgia, Times New Roman, _serif", fontWeight:"bold", fontStyle:"italic"};
			
			var emph:Object = new Object();
            emph = {fontStyle:"italic"};

            var body:Object = new Object();
            body = {fontSize:"16", leading:"4", fontFamily:"Arial, Helvetica, _sans", fontWeight:"normal", fontStyle:"normal", color:"#CCCCCC"};

            ss.setStyle(".title1", title1);
			ss.setStyle(".title2", title2);
			ss.setStyle(".emph", emph);
            ss.setStyle("body", body);
			ss.setStyle(".heading", heading);

			return ss;
		}
		// ------------------------------------
		// METHODS
		// ------------------------------------
		//takes length of time in secs and returns formatted time as a String 
		public static function formatTime(secs:uint):String {
			var oMin:Number = Math.floor(secs/60);
			var oSec:Number = secs%60;

			var oResult:String = "";			
			if(oMin < 10) {
				oResult += "0";
			}
			if(oMin >= 1) {
				oResult += oMin.toString();
			} else {
				oResult += "0";
			}
			oResult += ":";
			if(oSec < 10) {
				oResult += "0";
			}
			oResult += oSec.toString();
			return oResult;
		}

		// ------------------------------------
		// EVENT METHODS
		// ------------------------------------

	
	}
}