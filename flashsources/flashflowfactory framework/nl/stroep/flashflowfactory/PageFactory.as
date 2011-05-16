package nl.stroep.flashflowfactory 
{
	import com.usual.SWFAddress;
	import com.usual.SWFAddressEvent;
	import flash.display.Sprite;
	import flash.external.ExternalInterface;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	import nl.stroep.flashflowfactory.events.PageEvent;
	import nl.stroep.flashflowfactory.navigation.ButtonTypes;
	import nl.stroep.flashflowfactory.utils.EventCenter;
	/**
	 * Page system which creates/destroys pages and takes care of SWFAddress and it's handling. It is a custom factory design pattern.
	 * 
	 * Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
	 * @author Mark Knol
	 */
	public class PageFactory
	{
		/**
		 * Default prefix title for all pages. The PageFactory will set the browser title like this: 'titlePrefix pageTitle'
		 */
		public var titlePrefix:String = "";
		/**
		 * You can use this value to start on this page (startPage), after you call init()
		 */
		public var defaultPageName:String;
		/**
		 * PageSettings` class which will be applied on every `Page`. These settings can be overridden in the `Page` Class itself.
		 */
		public var defaultSettings:PageSettings;
		
		/**
		 * Sets SwfAddress active/inactive
		 */
		public var swfAddressEnabled:Boolean = true;
		
		private var _view:Sprite;
		private var currentPageName:String;
		private var eventcenter:EventCenter;
		private var pageDataList:Dictionary;
		private var page:Page;
		
		public function PageFactory() 
		{	
			eventcenter = EventCenter.getInstance();
			
			pageDataList = new Dictionary();
		}
		
		/**
		 * Registers a page reference with optional title to the pageFactory. 
		 * @param	pageName			The pageName reflects the deeplink url, and should start with forward-slash.
		 * @param	classReference		Reference to a class, which should extend the Page class
		 * @param	title				Optional. Title which is showed as browser title
		 * @param	wildcard			Optional. Normally an url represents one page (because the exact pageName links to a classReference). It is possible to add a wildcard to the url, which means you can add optional directories after the pageName (mostly on dynamic pages). 
		 */
		public function add(pageName:String, classReference:Class, title:String = "", wildcard:Boolean = false):void
		{
			pageDataList[ pageName ] = new PageData( pageName, classReference, title, wildcard);
			if (!defaultPageName) defaultPageName = pageName;
		}
		
		/**
		 * Unregisters a page reference from the pageFactory
		 * @param	pageName	The pageName which should be unregistered from the PageFactory
		 */
		public function remove(pageName:String):void
		{
			pageDataList[ pageName ] = null;
			delete pageDataList[ pageName ];
		}
		
		/**
		 * Start the factory, opens the first page
		 */
		public function init():void
		{
			initListeners();
			
			var pageData:PageData = findPageData(defaultPageName);
			
			if (swfAddressEnabled)
			{
				SWFAddress.setTitle( titlePrefix + pageData.pageTitle );
			}
		}
		
		/**
		 * Navigate to external website or webpage
		 * @param	url				The target URL of the website / webpage
		 * @param	windowTarget	Choose "_blank", "_self", "_top" or another window target.
		 */
		public static function gotoURL(url:String, windowTarget:String = "_blank"):void
		{
			navigateToURL( new URLRequest(url), windowTarget );
		}
		
		/**
		 * Global navigate function, sets path,type and parameters within one function.
		 * @param	path	Based on the type, this refers to the path where you should navigate to.<br><br>
		 * @param	type	Use ButtonTypes to define what kind of action the action should be handled.
							ButtonTypes.EXTERNAL navigates to external page. First parameter could be <br><br>
							ButtonTypes.EVENT dispatches a new event. You should pass the eventType as first parameter. Rest of parameters is based on the event parameters.<br><br>
							ButtonTypes.INTERNAL navigates to page which should be added in PageFactory<br><br>
							ButtonTypes.FUNCTION calls a flash function. Parameters are optional. <br><br>
							ButtonTypes.JAVASCRIPT calls a javascript function with optional parameters;
		 * @param	...parameters Optional parameters. In case of ButtonTypes.JAVASCRIPT, ButtonTypes.FUNCTION and ButtonTypes.Event; you can pass optional (function) parameter here. In case of ButtonTypes.EXTERNAL you could pass a window-target.
		 */
		public static function navigateTo(path:*, type:String = "internal", ...parameters):void
		{
			if (!path) { trace("Error: Property path undefined"); return }
			
			switch (type) 
			{
				case ButtonTypes.EXTERNAL:
					gotoURL( path, (parameters && parameters.length > 0) ? parameters[0] : null );
					break;
			
				case ButtonTypes.INTERNAL:
					PageFactory.gotoPage( path.toString() );
					break;
					
				case ButtonTypes.EVENT:	
					dispatchEvent(path, (parameters) ? parameters : null);
					break;
				
				case ButtonTypes.FUNCTION:	
					if (parameters)
					{
						path( parameters );
					}
					else
					{
						path();
					}
					break;
					
				case ButtonTypes.JAVASCRIPT:					
					if (ExternalInterface.available) ExternalInterface.call(path, (parameters) ? parameters : null);
					break;	
					
				default:
					trace("Error: navigateTo gets unknown type")
			}
		}
		
		static private function dispatchEvent(eventClassReference:Class, ...parameters):void 
		{
			switch (parameters.length)
			{
				case 0:  trace("Error: missing event type"); break;
				case 1:  EventCenter.getInstance().dispatchEvent( new eventClassReference( parameters[0] )); break;
				case 2:  EventCenter.getInstance().dispatchEvent( new eventClassReference( parameters[0], parameters[1] )); break;
				case 3:  EventCenter.getInstance().dispatchEvent( new eventClassReference( parameters[0], parameters[1], parameters[2] )); break;
				case 4:  EventCenter.getInstance().dispatchEvent( new eventClassReference( parameters[0], parameters[1], parameters[2], parameters[3] )); break;
				case 5:  EventCenter.getInstance().dispatchEvent( new eventClassReference( parameters[0], parameters[1], parameters[2], parameters[3], parameters[4] )); break;
				case 6:  EventCenter.getInstance().dispatchEvent( new eventClassReference( parameters[0], parameters[1], parameters[2], parameters[3], parameters[4], parameters[5] )); break;
				case 7:  EventCenter.getInstance().dispatchEvent( new eventClassReference( parameters[0], parameters[1], parameters[2], parameters[3], parameters[4], parameters[5], parameters[6] )); break;
				default: trace("Error: dispatchEvent has too much arguments..")
			}
		}
		
		/**
		 * Navigate to new page
		 * @param	pageName	The pageName reflects the deeplink url, and should start with forward-slash.
		 */
		public static function gotoPage(pageName:String):void
		{
			//EventCenter.getInstance().dispatchEvent( new PageEvent(PageEvent.NEW_PAGE, pageName) );
			dispatchEvent(PageEvent, PageEvent.NEW_PAGE, pageName);
		}
		
		/**
		 * Removes + cleans pageFactory data
		 */
		public function dispose():void
		{
			destroyPage();
			
			eventcenter.removeListeners(this);
			
			if (swfAddressEnabled)
			{
				SWFAddress.removeEventListener(SWFAddressEvent.CHANGE, handleSWFAddress);
			}
			
			pageDataList = null;
		}
		
		private function initListeners():void
		{
			eventcenter.addListener(this, PageEvent.NEW_PAGE, onNewPage);
			eventcenter.addListener(this, PageEvent.HIDE_COMPLETE, onPageHideComplete);
			
			// Automaticly triggers to call first page or deep linked page
			if (swfAddressEnabled)
			{
				currentPageName = SWFAddress.getPath();
				SWFAddress.addEventListener(SWFAddressEvent.CHANGE, handleSWFAddress);
			}
		}
		
		private function onNewPage(e:PageEvent):void
		{
			if (e.pageName != currentPageName)
			{
				currentPageName = e.pageName;
				
				if (page) 
				{
					page.hide();
				}
			}
		}
		
		private function onPageHideComplete(e:PageEvent):void
		{
			destroyPage();
			
			var pageData:PageData = findPageData(currentPageName);
			
			if (swfAddressEnabled)
			{
				SWFAddress.setTitle( titlePrefix + pageData.pageTitle );
				SWFAddress.setValue( currentPageName );
			}
			else
			{
				createPage(currentPageName);
			}
		}
		
		private function handleSWFAddress(e:SWFAddressEvent):void 
		{
			createPage(e.value);
		}
		
		private function createPage(pageName:String):void
		{
			destroyPage();
			
			var pageData:PageData = findPageData(pageName);
			var PageReference:Class = pageData.classReference;
			page = new PageReference() as Page;
			
			if (page != null)
			{
				if (!page.settings)
				{
					page.settings = (defaultSettings) ? defaultSettings.clone() : new PageSettings();
				}
				page.pageName = pageName;
				page.pageTitle = pageData.pageTitle;
				view.addChild(page);
			}
		}
		
		private function findPageData(pageName:String):PageData
		{
			if (pageName && pageName.length > 0)
			{
				return pageDataList[pageName] as PageData || findWildCardPageData(pageName) || findDefaultPage();
			}
			return null;
		}
		
		private function findDefaultPage():PageData
		{
			return pageDataList[defaultPageName] as PageData;
		}
		
		private function findWildCardPageData(name:String):PageData
		{
			for each (var pageData:PageData in pageDataList)
			{
				if (pageData.wildcard && name.indexOf( pageData.pageName ) > -1)
				{
					return pageData;
				}
			}
			return null;
		}
		
		private function destroyPage():void
		{
			while (view.numChildren > 0)
			{
				var page:Page = view.getChildAt(0) as Page;
				view.removeChild(page);
				page = null;
			}
		}
		
		/**
		 * All pages will be added to this Sprite. Don't forget to addChild 'em in your main document.
		 */
		public function get view() : Sprite 
		{
			return _view ||= new Sprite(); 
		}
		
		public function set view(value:Sprite):void 
		{
			_view = value;
		}
		
	}

}

final internal class PageData
{
	public var pageName:String;
	public var classReference:Class;
	public var pageTitle:String;
	public var wildcard:Boolean;
	
	public function PageData(pageName:String, classReference:Class, pageTitle:String, wildcard:Boolean) 
	{
		this.pageName = pageName;
		this.classReference = classReference;
		this.pageTitle = pageTitle;
		this.wildcard = wildcard;
	}
 
}