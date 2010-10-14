package nl.stroep.flashflowfactory 
{
	import com.usual.SWFAddress;
	import com.usual.SWFAddressEvent;
	import flash.display.Sprite;
	import flash.system.System;
	import flash.utils.clearTimeout;
	import flash.utils.Dictionary;
	import flash.utils.setTimeout;
	import nl.stroep.flashflowfactory.events.PageEvent;
	import nl.stroep.flashflowfactory.utils.EventCenter;
	/**
	 * Page system - Custom factory design pattern
	 * @author Mark Knol
	 */
	public class PageFactory
	{
		public var cleanupDelay:uint = 5000;
		public var titlePrefix:String = "";
		
		public var defaultPageName:String;
		private var _view:Sprite;
		public var defaultSettings:PageSettings;
		
		private var currentPageName:String;
		private var eventcenter:EventCenter;
		private var pageDataList:Dictionary;
		private var page:Page;
		private var timeoutID:int;
		
		public function PageFactory() 
		{	
			eventcenter = EventCenter.getInstance();
			
			pageDataList = new Dictionary();
		}
		
		/// Registers a page reference with optional title to the pageFactory. The name reflects the deeplink url
		public function add(pageName:String, classReference:Class, title:String = "", wildcard:Boolean = false):void
		{
			pageDataList[ pageName ] = new PageData( pageName, classReference, title, wildcard);
			if (!defaultPageName) defaultPageName = pageName;
		}
		
		/// Unregisters a page reference from the pageFactory
		public function remove(pageName:String):void
		{
			pageDataList[ pageName ] = null;
			delete pageDataList[ pageName ];
		}
		
		/// Start the factory, opens first page
		public function init():void
		{
			if (!view) view = new Sprite();
			initListeners();
			
			var pageData:PageData = findPageData(defaultPageName);
			SWFAddress.setTitle( titlePrefix + pageData.pageTitle );
		}
		
		/// Navigate to new page
		public static function gotoPage(pageName:String):void
		{
			EventCenter.getInstance().dispatchEvent( new PageEvent( PageEvent.NEW_PAGE, pageName) );
		}
		
		/// Removes + cleans pageFactory data
		public function dispose():void
		{
			clearTimeout(timeoutID);
			
			destroyPage();
			
			eventcenter.removeListeners(this);
			
			SWFAddress.removeEventListener(SWFAddressEvent.CHANGE, handleSWFAddress);
			
			pageDataList = null;
		}
		
		private function initListeners():void
		{
			eventcenter.addListener(this, PageEvent.NEW_PAGE, onNewPage);
			eventcenter.addListener(this, PageEvent.HIDE_COMPLETE, onPageHideComplete);
			eventcenter.addListener(this, PageEvent.SHOW_COMPLETE, onPageShowComplete);
			
			// Automaticly triggers to call first page or deep linked page
			SWFAddress.addEventListener(SWFAddressEvent.CHANGE, handleSWFAddress);
		}
		
		private function onPageShowComplete(e:PageEvent):void 
		{
			trace("onPageShowComplete");
			timeoutID = setTimeout(cleanup, cleanupDelay);
		}
		
		private function cleanup():void
		{
			trace("GC called");
			System.gc();
		}
		
		private function onNewPage(e:PageEvent):void
		{
			clearTimeout(timeoutID);
			
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
				if (defaultSettings) page.settings = defaultSettings.clone();
				page.pageName = pageName;
				view.addChild(page);
			}
		}
		
		private function findPageData(pageName:String):PageData
		{
			if (pageName && pageName.length > 0)
			{
				var pageData:PageData = pageDataList[pageName] as PageData;
				
				var PageReference:Class;
				
				if (pageData)
				{
					return pageData;
				}
				else
				{
					pageData = findWildCardPageData(pageName);
					
					if (pageData)
					{
						return pageData;
					}
					else
					{
						pageData = findDefaultPage();
						return pageData;
					}
				}
			}
			return null;
		}
		
		private function findDefaultPage():PageData
		{
			var pageData:PageData = pageDataList[defaultPageName] as PageData;
			return pageData;
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
		
		public function get view():Sprite 
		{ 
			if (!_view) _view = new Sprite();
			return _view; 
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