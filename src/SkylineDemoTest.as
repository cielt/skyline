package {

	/**
	Document class for Skyline Demo
	
	TODO
	------------------------------------------------
	-refine appearance of city progress, state changes, etc.
	-add actions for projects!
	------------------------------------------------
	
	**/

	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.text.*;
	//import flashx.textLayout.formats.CharacterFormat;
	
	import skyline.ui.*;
	import skyline.*;

	import com.greensock.TweenLite;
	import com.greensock.easing.*;
	
	public class SkylineDemoTest extends Sprite {
		
		public static const SKYLINE_WIDTH = 900;
		public static const SKYLINE_HEIGHT = 215;
		
		//bg
		private var _bg:Sprite;
		
		//nav stuff
		private var _cities:Array = new Array();
		private var _navWorld:NavWorld;
		private var _worldCO2Meter:HorizontalProgressMeter;
		private var _meterLabelField:TextField;
		private var _holderSkyline:Sprite;
		
		//private var _skylineDictionary:Dictionary;
		private var _skylineArray:Array = new Array();  //Array of NavSkyline objects; we will show/hide on select
		private var _currNavSkyline:NavSkyline;  //current NavSkyline
		private var _currCity:City;
		//track #projects selected so far
		private var _selectedProjectCount:int = 0;
		
		//headers
		private var _headerText:TextField;
		private var _tagText:TextField;
		
		//display project info
		private var _infoPane:InfoPane;
		
		private var _xmlData:XML;
		private var _xmlLoader:URLLoader;
		
		//save state
		private var _mapSmallX:Number;
		private var _mapSmallY:Number;
		
		//intro
		private var _skylinePlayable:SkylinePlayable;


		// ------------------------------------
		// CONSTRUCTOR
		// ------------------------------------
		
		public function SkylineDemoTest () {
			trace("SkylineDemoTest");
			MochiBot.track(this, "1c0a164b");
			loadXML("_assets/xml/skylineProjectData.xml");
			
		}

		
		// ------------------------------------
		// ACCESSORS
		// ------------------------------------

				
		// ------------------------------------
		// INIT METHODS
		// ------------------------------------
		private function init ():void{
			trace("SkylineDemoTest::init");
			create();
		}


		// ------------------------------------
		// CREATE / DESTROY
		// ------------------------------------
		private function create ():void{
			trace("SkylineDemoTest::create");
			_bg = Drawer.createFill(0,0,320,180, 0xFFFFFF, 0);
			_holderSkyline = Drawer.createFill(0, 0, 900, 215, 0xA4AA4C, 0);
			
			//initially, put the intro in here
			_skylinePlayable = new SkylinePlayable("");
			_skylinePlayable.loadSkyline("_assets/images/skyline900_nyc.jpg");
			_skylinePlayable.addEventListener(MeterEvent.METER_START, onSkylinePlayableMeterStart, false, 0, true);
			_holderSkyline.addChild(_skylinePlayable);
			
			// we now need to mess with the XML data object				
			var a:Array = new Array();
			trace("\t_xmlData.name is: "+_xmlData.name);
						
			var xmllist:XMLList = _xmlData.cities.city;
			trace("\txmllist is: "+xmllist);
			
			var count:int = xmllist.length();
			trace("the size of count [city]s is: "+count);
			
		
			for ( var i:int=0; i<count; i++ ) {
				trace("\ti is: "+i);
				trace("\txmllist[i].@name is: "+xmllist[i].@name);
				
				//make the city!!!
				var pName:String = xmllist[i].@name;
			
				var pPathSkyline:String = xmllist[i].skyline.@path;
				var pPathEnv:String = xmllist[i].environment.@path;
				var pNameImageDir:String = xmllist[i].imageDir.@name;
				
				//position
				var pCityPosX:Number = xmllist[i].cityPosition.@posX;
				var pCityPosY:Number = xmllist[i].cityPosition.@posY;
				
				// ===========================================
				// BEGIN PROJECTS - get projects, put in an array!!!
				var pCityProjects:Array = new Array();
				var projectsList:XMLList = xmllist[i].projects.project;
				
				var projCount:int = projectsList.length();
				trace("the size of count [projectsList]s is: "+projCount);

				for ( var p:int=0; p<projCount; p++ ) {
					trace("\tp is: "+p);
						
					//var p:String = xmllist.project[i].@path;
					var pImgPath:String = projectsList[p].image.@path;
					var pTitle:String =  projectsList[p].title;
					var pDesc:String =  projectsList[p].description;
					//position
					var pNavPosX:Number =  projectsList[p].navPosition.@posX;
					var pNavPosY:Number =  projectsList[p].navPosition.@posY;

					//size
					var pNavSizeW:Number =  projectsList[p].navSize.@nodeW;
					var pNavSizeH:Number =  projectsList[p].navSize.@nodeH;
					
					var pProjectsArray:Array = new Array();
					var actionsList:XMLList = projectsList[p].actions.action;
					var actionsCount:int = actionsList.length();
					for (var acts:int=0; acts<actionsCount; acts++){
						trace("\t\t\tacts = "+acts);
						var pLabel:String = actionsList[acts].@label;
						var aURL:String = actionsList[acts].@url;
						var aType:String = actionsList[acts].@type;
						var newAction:Object = new Object();
						
						newAction = {label:pLabel, url:aURL, type:aType};
						trace("adding newAction with URL: "+newAction.url);
						pProjectsArray.push(newAction);
					}
					
					//create the Project instance
					var newP:Project = new Project(pNavPosX, pNavPosY, pNavSizeW, pNavSizeH, pTitle);
					newP.pathImage = pImgPath;
					newP.description = pDesc;
					newP.actions = pProjectsArray;

					pCityProjects.push(newP);
				}
				
				//END PROJECTS 
				// ===========================================
				
				//create the City Object, push into _cities
				var newC:City = new City(pCityPosX, pCityPosY, pName, pPathSkyline, pCityProjects);
				trace("adding city in this list: "+newC);
				newC.nameImageDir = pNameImageDir;
				newC.pathEnv = pPathEnv;
				_cities.push(newC);

			}
			
			//make the NavSkylines; save them to the Array _skylineArray
			trace("\tM A K I N G   C I T Y   S K Y L I N E S ! ! !");
			for (var cIndex:int = 0; cIndex<_cities.length; cIndex++){
				var current:City = _cities[cIndex];
				var cName = current.name;
				var cPathSkyline = current.pathSkyline;
				var cPathEnv = current.pathEnv;
				var newSkyline:NavSkyline = new NavSkyline(current);
				newSkyline.loadSkyline("_assets/images/"+cPathSkyline);
				newSkyline.addEventListener(NavEvent.SELECT_PROJECT, navSelectProjectHandler, false, 0, true);		
				_skylineArray.push(newSkyline);
				trace("\t\tadded skyline for city: "+cName);
			}
				
			// make the world nav		
			_navWorld = new NavWorld(_cities);
			_navWorld.create();
			_navWorld.addEventListener(NavEvent.SELECT_FIRST, onNavSelectFirst, false, 0, true);
			_navWorld.addEventListener(NavEvent.SELECT_CITY, navSelectCityHandler, false, 0, true); 
			
			//world co2 meter
			var totalProjects:int = getProjectCount();
			_worldCO2Meter = new HorizontalProgressMeter(240, _selectedProjectCount, totalProjects);

			_meterLabelField = Texter.createOneLineField(360,28,18,0xA4AA4C, false);
			var sub2:String = "2";
			//var subCharFmt:CharacterFormat = new CharacterFormat();
			//subCharFmt.baselineShift = flashx.textLayout.formats.BaselineShift.SUBSCRIPT;
			//sub2.characterFormat = subCharFmt;
			_meterLabelField.text = "CO"+sub2+" emissions worldwide";
		
			
			//header
			_headerText = Texter.createOneLineField(900,40,32,0xA4AA4C, true);
			_headerText.text = "Learn how CCI is Greening Our Cities...and Our Planet";			
			//tagline
			_tagText = Texter.createMultiLineField(900, 18, 0x333333);
			_tagText.htmlText = "<i>Retrofit our Buildings, Reforest our Land, Refine our Planet</i>"
			
			_headerText.y = 8;
			_tagText.y = _headerText.y + _headerText.height + 4; 
			
			_holderSkyline.y = _tagText.y + _tagText.height + 4;
			_infoPane = new InfoPane();
			_mapSmallY = _infoPane.y = _navWorld.y = _holderSkyline.y + _holderSkyline.height +8;
			
			_headerText.x = _tagText.x = _holderSkyline.x = _infoPane.x = (stage.stageWidth - _holderSkyline.width)/2;
			_mapSmallX = _navWorld.x = _holderSkyline.x + _holderSkyline.width - _navWorld.width;
			_worldCO2Meter.x = _meterLabelField.x = _navWorld.x + 12;

			
			//add the stuff to the stage		
			_bg.addChild(_headerText);
			_bg.addChild(_tagText);

			_bg.addChild(_infoPane);
			addChild(_bg);

			_bg.addChild(_holderSkyline);
			
		}
		

		//handle _navWorld
		private function scaleAndPositionMap(scaleFactor:Number, toX:int, toY:int):void {
			trace("SkylineDemoTest::expandMap");
			TweenLite.to(_navWorld, 1, {x:toX, y:toY, scaleX:scaleFactor, scaleY:scaleFactor, delay:0, ease:Strong.easeIn });
		}

		// ------------------------------------
		// METHODS
		// ------------------------------------
		private function loadXML (path:String):void{
			trace("SkylineDemoTest::loadXML");
			
			_xmlLoader = new URLLoader();
			_xmlLoader.dataFormat = URLLoaderDataFormat.TEXT;
			_xmlLoader.addEventListener(Event.COMPLETE, xmlCompleteHandler);
			_xmlLoader.addEventListener(IOErrorEvent.IO_ERROR, xmlIoErrorHandler);
			_xmlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, xmlSecurityErrorHandler);
						
			var request:URLRequest = new URLRequest(path);
			_xmlLoader.load(request);
		}
		
		private function xmlCompleteHandler (event:Event):void{
			trace("SkylineDemoTest::xmlCompleteHandler");
			
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
			trace("SkylineDemoTest::xmlIoErrorHandler");
			
		}
		
		private function xmlSecurityErrorHandler (event:Event):void{
			trace("SkylineDemoTest::xmlSecurityErrorHandler");
			
		}
		
		//CITY SELECT
		private function selectCity (id:int):void{
			trace("SkylineDemoTest::selectCity "+id);
			trace("current city : "+id+" = "+_cities[id]);
			_currCity = _cities[id];
			while (_holderSkyline.numChildren > 0){
				_holderSkyline.removeChildAt(0);
			}
			
			_headerText.text = _currCity.name;
			//set up and add skyline to holder; add holder to display list
			_currNavSkyline = _skylineArray[id];
			_holderSkyline.addChild(_currNavSkyline);
	
		}
		
		//PROJECT SELECT
		private function selectProject (id:int):void{
			trace("SkylineDemoTest::selectProject");
			var currNode:NavNodeSkyline = _currNavSkyline.nodeArray[id];
			trace("\t\t\t>>>>>>>>>>>>>>>>>>>>>>>>>>>>>currNode.selectCount = "+currNode.selectCount);
			if (currNode.selectCount==1){
				_currNavSkyline.brighten(_currNavSkyline.nodeCount());
			} else {
				trace("already selected");
			}
			
			// grab project info, load it into _infoPane
			var thisP:Project = _currCity.projects[id];
			var pPath:String = "_assets/images/"+_currCity.nameImageDir+"/"+thisP.pathImage;
			var pTitle:String = thisP.title;
			var pDesc:String = thisP.description;
			var pActions:Array = thisP.actions;
			trace("\tpPath is: "+pPath);
			
			//var request:URLRequest = new URLRequest(p);	
			_infoPane.resetPane();
			_infoPane.load(pPath);
			_infoPane.titleTextField.text = pTitle;
			_infoPane.descTextField.htmlText = pDesc;
			
			//handle calls to action
			_infoPane.showActions(pActions);	
			TweenLite.to(_infoPane.loader, 0.8, {alpha:1, ease:Back.easeIn });
			
			//refresh map
			_navWorld.refreshMap();
			//update count
			_selectedProjectCount = getSelectedProjectCount();
			_worldCO2Meter.refresh(_selectedProjectCount);
		}
		
		private function getProjectCount():int{
			trace("SkylineDemo::getProjectCount");
			var counting:int = 0;
			for (var i:int=0; i<_skylineArray.length; i++){
				var cityPCount:int = _skylineArray[i].projectArray.length;
				counting += cityPCount;
			}
			return counting;
		}
		
		private function getSelectedProjectCount():int {
			trace("SkylineDemoTest::getSelectedProjectCount");
			var counting:int = 0;
			for (var i:int=0; i<_skylineArray.length; i++){
				counting += _skylineArray[i].selectedNodeCount;
			}
			trace("\t\t\t}}}}}}}}}}}}}}}}}}}TOTAL # PROJECTS SELECTED SO FAR: "+counting);
			return counting;
		}
		
		// ------------------------------------
		// EVENT METHODS
		// ------------------------------------
        //CITY SELECT
		private function onNavSelectFirst (event:NavEvent):void {
			trace("onNavSelectFirst");
			_navWorld.removeEventListener(NavEvent.SELECT_FIRST, onNavSelectFirst);
			//again
			_bg.addChild(_holderSkyline);
			
			//after initial
			scaleAndPositionMap(1, _mapSmallX, _mapSmallY);
			_bg.addChild(_worldCO2Meter);
			_bg.addChild(_meterLabelField);
		}
		
		private function navSelectCityHandler (event:NavEvent):void{
			trace("SkylineDemoTest::navSelectCityHandler");	
			trace("\tevent.id is: "+event.id);
			_infoPane.resetPane();
			selectCity(event.id);
		}
		
		
		//PROJECT SELECT
		private function navSelectProjectHandler (event:NavEvent):void{
			trace("SkylineDemoTest::navSelectProjectHandler");	
			trace("\tevent.id is: "+event.id);
			trace("target is: "+event.target);

			selectProject (event.id);	
		}		
		
		//CO2 METER FULL
		private function onCO2MeterFull(event:MeterEvent):void {
			trace("SkylineDemoTest::onCO2MeterFull");
			_navWorld.greenWorld();
		}
		
		private function onSkylinePlayableMeterStart(event:MeterEvent):void {
			trace("SkylineDemoTest::onSkylinePlayableMeterStart");
			var toXMap:Number = (stage.stageWidth - (2.4*360))/2;
			scaleAndPositionMap(2.4, toXMap, 108);
			_holderSkyline.removeChild(_skylinePlayable);
			addChild(_navWorld);
			
			//ready meter
			_meterLabelField.y = _navWorld.y + _navWorld.height + 8;
			_worldCO2Meter.y = _meterLabelField.y + _meterLabelField.height;
			_worldCO2Meter.addEventListener(MeterEvent.METER_FULL, onCO2MeterFull, false, 0, true);

		}
	}
}