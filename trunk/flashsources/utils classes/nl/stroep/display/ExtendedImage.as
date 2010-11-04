package nl.stroep.display 
{
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.system.System;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	/**
	 * Image with contextMenu
	 * @author Mark Knol
	 */
	public class ExtendedImage extends Image
	{
		private var _enableContextMenu:Boolean;
		
		private var item1:ContextMenuItem;			
		private var item2:ContextMenuItem;		
		private var item3:ContextMenuItem;		
		private var item4:ContextMenuItem;		
		private var item5:ContextMenuItem;
		
		public function ExtendedImage( url:String, scale:Number = 1 ) 
		{
			super(url, scale);
			
			addContextMenu();
		}
		
		
		public function get enableContextMenu():Boolean { return _enableContextMenu; }
		
		public function set enableContextMenu(value:Boolean):void 
		{
			_enableContextMenu = value;
			
			if (true == value)
			{				
				addContextMenu()
			}
			else
			{
				removeContextMenu()
			}
		}
		
		private function removeContextMenu():void
		{
			var defaultCM:ContextMenu = new ContextMenu();			
			contextMenu = defaultCM;
			
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemoveContextMenuListeners);
		}
		
		private function addContextMenu():void
		{
			var customCM:ContextMenu = new ContextMenu();

			item1 = new ContextMenuItem("View Image", false, true, true);
			if (!item1.hasEventListener(ContextMenuEvent.MENU_ITEM_SELECT)) item1.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, onViewImage);
			
			item2 = new ContextMenuItem("Save Image As..", false, true, true);
			if (!item2.hasEventListener(ContextMenuEvent.MENU_ITEM_SELECT)) item2.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, onSaveImageAs);
			
			item3 = new ContextMenuItem("Copy Image Location", false, true, true);
			if (!item3.hasEventListener(ContextMenuEvent.MENU_ITEM_SELECT)) item3.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, onCopyImageLocation);
			
			item4 = new ContextMenuItem("Send Image", false, true, true);
			if (!item4.hasEventListener(ContextMenuEvent.MENU_ITEM_SELECT)) item4.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, onSendImage);
			
			customCM.customItems = [item1, item2, item3, item4];
			
			customCM.builtInItems.forwardAndBack = false;
			customCM.builtInItems.loop = false;
			customCM.builtInItems.play = false;
			customCM.builtInItems.print = false;
			customCM.builtInItems.quality = true;
			customCM.builtInItems.rewind = false;
			customCM.builtInItems.save = false;
			customCM.builtInItems.zoom = false;
			
			contextMenu = customCM;
			
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemoveContextMenuListeners);
		}
		
		private function onSendImage(e:ContextMenuEvent):void 
		{
			navigateToURL(new URLRequest("mailto:&body=" + this._src), "_self");
		}
		
		private function onSaveImageAs(e:ContextMenuEvent):void 
		{
			var imagesaver:ImageSaver = new ImageSaver();
			if (this._src.indexOf("/") > -1)
			{
				var splittedURL:Array = this._src.split("/");			
				imagesaver.saveLocal(bitmapdata, splittedURL[splittedURL.length - 1]);
			}
			else
			{
				imagesaver.saveLocal(bitmapdata, this._src );
			}
		}
		
		private function onCopyImageLocation(e:ContextMenuEvent):void 
		{
			System.setClipboard(this._src);
		}
		
		private function onViewImage(e:ContextMenuEvent):void 
		{
			navigateToURL(new URLRequest(this._src), "_blank");
		}
		
		private function onRemoveContextMenuListeners(e:Event):void 
		{
			item1.removeEventListener(ContextMenuEvent.MENU_ITEM_SELECT, onViewImage);
			item2.removeEventListener(ContextMenuEvent.MENU_ITEM_SELECT, onSaveImageAs);
			item3.removeEventListener(ContextMenuEvent.MENU_ITEM_SELECT, onCopyImageLocation);
			item4.removeEventListener(ContextMenuEvent.MENU_ITEM_SELECT, onSendImage);
			
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemoveContextMenuListeners);
			
		}
	}

}