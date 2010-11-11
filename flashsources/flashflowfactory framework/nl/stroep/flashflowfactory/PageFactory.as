package nl.stroep.flashflowfactory 
{
	import com.usual.SWFAddress;
	import com.usual.SWFAddressEvent;
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	import nl.stroep.flashflowfactory.events.PageEvent;
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
			SWFAddress.setTitle( titlePrefix + pageData.pageTitle );
		}
		
		/**
		 * Navigate to new page
		 * @param	pageName	The pageName reflects the deeplink url, and should start with forward-slash.
		 */
		public static function gotoPage(pageName:String):void
		{
			EventCenter.getInstance().dispatchEvent( new PageEvent(PageEvent.NEW_PAGE, pageName) );
		}
		
		/**
		 * Removes + cleans pageFactory data
		 */
		public function dispose():void
		{
			destroyPage();
			
			eventcenter.removeListeners(this);
			
			SWFAddress.removeEventListener(SWFAddressEvent.CHANGE, handleSWFAddress);
			
			pageDataList = null;
		}
		
		private function initListeners():void
		{
			eventcenter.addListener(this, PageEvent.NEW_PAGE, onNewPage);
			eventcenter.addListener(this, PageEvent.HIDE_COMPLETE, onPageHideComplete);
			
			// Automaticly triggers to call first page or deep linked page
			SWFAddress.addEventListener(SWFAddressEvent.CHANGE, handleSWFAddress);
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
			
			SWFAddress.setTitle( titlePrefix + pageData.pageTitle );
			SWFAddress.setValue( currentPageName );
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
				page.settings = (defaultSettings) ? defaultSettings.clone() : new PageSettings();
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