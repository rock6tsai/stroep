package nl.stroep.framework 
{
	import com.usual.SWFAddress;
	import com.usual.SWFAddressEvent;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.system.System;
	import flash.utils.clearTimeout;
	import flash.utils.Dictionary;
	import flash.utils.setTimeout;
	import nl.stroep.framework.utils.EventCenter;
	import nl.stroep.framework.events.PageEvent;
	/**
	 * Page system - Custom factory design pattern
	 * @author Mark Knol
	 */
	public class PageFactory
	{
		public static var cleanupDelay:int = 5000;
		public var titlePrefix:String = "";
		
		public var defaultPageReference:Class;
		public var view:Sprite;
		public var timeoutID:int;
		public var defaultSettings:PageSettings;
		
		private var currentPageName:String;
		private var eventcenter:EventCenter;
		private var wildcardPageList:Dictionary;
		private var pageList:Dictionary;
		private var page:Page;
		
		public function PageFactory() 
		{	
			eventcenter = EventCenter.getInstance();
			
			pageList = new Dictionary();
			wildcardPageList = new Dictionary();
		}
		
		/// add a class reference
		public function add(pageName:String, classReference:Class, wildcard:Boolean = false):void
		{
			pageList[ pageName ] = classReference;
			if (wildcard) wildcardPageList[ pageName ] = classReference;
		}
		
		/// remove page reference from 
		public function remove(pageName:String):void
		{
			pageList[ pageName ] = null;
			delete pageList[ pageName ];
			delete wildcardPageList[ pageName ];
		}
		
		/// Start the factory, opens first page
		public function init():void
		{
			if (!defaultPageReference) defaultPageReference = pageList[0];
			if (!view) view = new Sprite();
			
			initListeners();
		}
		
		/// Navigate to new page
		public static function gotoPage(pageName:String):void
		{
			EventCenter.getInstance().dispatchEvent( new PageEvent( PageEvent.NEW_PAGE, pageName) );
		}
		
		/// Remove private data
		public function dispose():void
		{
			clearTimeout(timeoutID);
			
			destroyPage();
			
			eventcenter.removeListeners(this);
			
			SWFAddress.removeEventListener(SWFAddressEvent.CHANGE, handleSWFAddress);
			
			pageList = null;
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
			timeoutID = setTimeout(cleanup, cleanupDelay);
		}
		
		private function cleanup():void
		{
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
				var PageReference:Class = pageList[name] as Class;
				
				if (PageReference != null)
				{
					page = new PageReference() as Page;
				}
				else
				{
					for each (var pageName:String in wildcardPageList)
					{
						if (name.indexOf( pageName ) > -1)
						{
							PageReference = wildcardPageList[pageName] as Class;
							
							page = new PageReference() as Page;
							
							break;
						}
					}
					
					if (page == null)
					{
						page = new defaultPageReference() as Page;
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
		
		private function destroyPage():void
		{
			while (view.numChildren > 0)
			{
				var page:DisplayObject = view.getChildAt(0) as DisplayObject;
				view.removeChild(page);
				page = null;
			}
		}
		
	}

}
