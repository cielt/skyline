package {

	/**
	Document class for Skyline 
	
	**/

	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.text.*;
	
	import skyline.ui.*;
	import skyline.*;
	//import gs.TweenLite;
	//import gs.easing.*;
	import com.greensock.TweenLite;
	import com.greensock.easing.*;
	
	public class SkylineDemo extends Sprite {
		
		public static var POS_X:Number = 0;
		public static var POS_Y:Number = 0;

		
		//bg
		private var _bg:Sprite;
		
		//nav stuff
		private var _projectsData:Array = new Array();
		private var _navSkyline:NavSkyline;
		//private var _data:Array;
		
		//headers
		private var _headerText:TextField;
		private var _tagText:TextField;
		
		//display project info
		private var _infoPane:InfoPane;
		
		private var _xmlData:XML;
		private var _xmlLoader:URLLoader;
		
		//aspirational
		//private var _blueBird:BlueBird;
		private var _world:World;


		// ------------------------------------
		// CONSTRUCTOR
		// ------------------------------------
		
		public function SkylineDemo () {
			trace("SkylineDemo");
			
			loadXML("_assets/xml/skylineProjectData.xml");
			
			/*
			var projects:Array = createProjectData();	
			var skylinePath:String = "_assets/images/skyline900_nyc.jpg";
			var envPath:String = "_assets/images/skyline900_london.jpg";
			var skylineNYC:NavSkyline = new NavSkyline(skylinePath, envPath, projects);
			skylineNYC.loadSkyline(skylineNYC.pathSkyline);
			_navSkyline = skylineNYC;
			_navSkyline.addEventListener(NavEvent.SELECT, navSelecthandler, false, 0, true);
			addChild(_navSkyline);
			*/
		}

		
		// ------------------------------------
		// ACCESSORS
		// ------------------------------------

				
		// ------------------------------------
		// INIT METHODS
		// ------------------------------------
		private function init ():void{
			trace("SkylineDemo::init");
			create();
		}


		// ------------------------------------
		// CREATE / DESTROY
		// ------------------------------------
		private function create ():void{
			trace("SkylineDemo::create");
			_bg = Drawer.createFill(0,0,960,480, 0xFFFFFF, 0);
			
			// we now need to mess with the XML data object
			
			//var foo:XML = new XML();
					
			var a:Array = new Array();
			trace("\t_xmlData.name is: "+_xmlData.name);
			trace("\t_xmlData.cities.city.project is: "+_xmlData.cities.city.project);
			
			//get city-specific info
			var cityName:String = _xmlData.cities.city.@name;
			trace("this city name is: "+cityName);
			var skylinePath:String = _xmlData.cities.city.skyline.@path;
			trace("the path to the skyline image = "+skylinePath);
			var envPath:String = _xmlData.cities.city.env.@path;
			trace("the path to the env image = "+envPath);
			
			var xmllist:XMLList = _xmlData.cities.city;
			trace("\txmllist is: "+xmllist);
			
			
			
			var count:int = xmllist.projects.project.length();
			trace("the size of count [project]s is: "+count);
			
			for ( var i:int=0; i<count; i++ ) {
				//trace("\ti is: "+i);
				//trace("\txmllist.project[i].title is: "+xmllist.project[i].title);
				//trace("\txmllist.project[i].@path is: "+xmllist.project[i].@path);
				
				//var p:String = xmllist.project[i].@path;
				var pImgPath:String = xmllist.projects.project[i].image.@path;
				var pTitle:String = xmllist.projects.project[i].title;
				var pDesc:String = xmllist.projects.project[i].description;
				//position
				var pNavPosX:Number = xmllist.projects.project[i].navPosition.@posX;
				var pNavPosY:Number = xmllist.projects.project[i].navPosition.@posY;
				
				//size
				var pNavSizeW:Number = xmllist.projects.project[i].navSize.@nodeW;
				var pNavSizeH:Number = xmllist.projects.project[i].navSize.@nodeH;
				
				trace("another project in this list");
				//create the Project Object
				var newP:Project = new Project(pNavPosX, pNavPosY, pNavSizeW, pNavSizeH, pTitle);
				newP.pathImage = pImgPath;
				newP.description = pDesc;
				
				_projectsData.push(newP);
			}
			
			
			//header
			_headerText = Texter.createOneLineField(900,36,32,0xA4AA4C, false);
			var headerText = _xmlData.name;
			_headerText.text = headerText + " in " + cityName;
			
			//tagline
			_tagText = Texter.createOneLineField(900, 28, 21, 0x000000, false);
			_tagText.htmlText = "<i>Retrofit our Buildings, Reforest our land, Refine our Planet</i>"
			
			//placeholders - to be made
			_world = new World();
				
			// make the skyline nav
			_navSkyline = new NavSkyline(skylinePath, envPath, _projectsData);

			_navSkyline.create();
			
			_headerText.y = 18;
			_tagText.y = _headerText.y + _headerText.height + 8;
			_navSkyline.y = _tagText.y + _tagText.height + 8;
			_navSkyline.loadSkyline("_assets/images/"+skylinePath);
			
			_navSkyline.addEventListener(NavEvent.SELECT, navSelecthandler, false, 0, true);
			
			_infoPane = new InfoPane();
			_infoPane.y = _navSkyline.y + _navSkyline.height +8;
			_world.y = _navSkyline.y + _navSkyline.height + 18;
		 	_world.x = _navSkyline.x + _navSkyline.width -300;
			
			_headerText.x = _tagText.x = _navSkyline.x = _infoPane.x = (stage.stageWidth - _navSkyline.width)/2;
			//add the stuff to the stage
				
			_bg.addChild(_headerText);
			_bg.addChild(_tagText);
			_bg.addChild(_navSkyline);
			_bg.addChild(_infoPane);
			_bg.addChild(_world);
			addChild(_bg);
	
		}
		
		

		// ------------------------------------
		// METHODS
		// ------------------------------------
		private function loadXML (path:String):void{
			trace("SkylineDemo::loadXML");
			
			_xmlLoader = new URLLoader();
			_xmlLoader.dataFormat = URLLoaderDataFormat.TEXT;
			_xmlLoader.addEventListener(Event.COMPLETE, xmlCompleteHandler);
			_xmlLoader.addEventListener(IOErrorEvent.IO_ERROR, xmlIoErrorHandler);
			_xmlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, xmlSecurityErrorHandler);
						
			var request:URLRequest = new URLRequest(path);
			_xmlLoader.load(request);
		}
		
		private function xmlCompleteHandler (event:Event):void{
			trace("SkylineDemo::xmlCompleteHandler");
			
			try {
				// Convert downloaded text into XML instance
				trace("\tSUCCESS!");
				_xmlData = new XML( event.target.data);
				init();
				
			} catch ( event:TypeError ) {
				// Downloaded text could not be converted to XML instance
				trace("!!! XMLLoader: "+ event.message);
				return;
			}
			
		}
		
		private function xmlIoErrorHandler (event:Event):void{
			trace("SkylineDemo::xmlIoErrorHandler");
			
		}
		
		private function xmlSecurityErrorHandler (event:Event):void{
			trace("SkylineDemo::xmlSecurityErrorHandler");
			
		}
		
		private function selectProject (id:int):void{
			trace("SkylineDemo::selectProject");
			trace("haze alpha = "+_navSkyline.haze.alpha);
			_navSkyline.brighten(_navSkyline.nodeCount());
			// hit the xml again
		
			var xmllist:XMLList = _xmlData.cities.city;
			var p:String = "_assets/images/nyc/"+xmllist.projects.project[id].image.@path;
			//var p:String = "_assets/images/"+_data[id].path;
			var t:String = xmllist.projects.project[id].title;
			var d:String = xmllist.projects.project[id].description;
			trace("\tp is: "+p);
			
			//var request:URLRequest = new URLRequest(p);

			_infoPane.load(p);
			_infoPane.titleTextField.text = t;
			_infoPane.descTextField.htmlText = d;
				
			TweenLite.to(_infoPane.loader, 0.8, {alpha:1, ease:Back.easeIn });
	
		}
		
		
		// ------------------------------------
		// EVENT METHODS
		// ------------------------------------
        		
		private function navSelecthandler (event:NavEvent):void{
			trace("SkylineDemo::navSelecthandler");	
			trace("\tevent.id is: "+event.id);
			selectProject (event.id);
		}
		
	}
}