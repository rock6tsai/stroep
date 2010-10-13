package nl.stroep.flashflowfactory 
{
	import com.usual.SWFAddress;
	import com.usual.SWFAddressEvent;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.system.System;
	import flash.utils.clearTimeout;
	import flash.utils.Dictionary;
	import flash.utils.setTimeout;
	import nl.stroep.flashflowfactory.utils.EventCenter;
	import nl.stroep.flashflowfactory.events.PageEvent;
	/**
	 * Page system - Custom factory design pattern
	 * @author Mark Knol
	 */
	public class PageFactory
	{
		public var cleanupDelay:uint = 5000;
		public var titlePrefix:String = "";
		
		public var defaultPageName:String;
		public var view:Sprite;
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
			
			//SWFAddress.setTitle( titlePrefix );
			SWFAddress.setValue( currentPageName );
		}
		
		private function handleSWFAddress(e:SWFAddressEvent):void 
		{
			createPage(e.value);
		}
		
		private function createPage(name:String):void
		{
			destroyPage();
			
			if (name && name.length > 0)
			{
				var pageData:PageData = pageDataList[name] as PageData;
				
				var PageReference:Class;
				
				if (pageData) PageReference = pageData.classReference as Class;
				
				if (PageReference != null)
				{
					page = new PageReference() as Page;
				}
				else
				{
					page = findWildCardPage(name);
					
					if (page == null)
					{
						page = findDefaultPage();
					}
				}
			}
			
			if (page != null)
			{
				if (defaultSettings) page.settings = defaultSettings.clone();
				page.pageName = name;
				view.addChild(page);
			}
		}
		
		private function findDefaultPage():Page 
		{
			var pageData:PageData = pageDataList[defaultPageName] as PageData;
			var PageReference:Class
			if (pageData) PageReference = pageData.classReference as Class;
			return new PageReference();
		}
		
		private function findWildCardPage(name:String):Page 
		{
			for each (var pageData:PageData in pageDataList)
			{
				if (pageData.wildcard && name.indexOf( pageData.pageName ) > -1)
				{
					var PageReference:Class = pageData.classReference as Class;
					
					return new PageReference() as Page;
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