/*The MIT License

Copyright (c) 2009 Mark Knol

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.*/


package nl.stroep.utils 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.Loader;
	import flash.display.PixelSnapping;
	import flash.display.Sprite;
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.system.System;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	
	/**
	 * Image class for loading images
	 * @author Mark Knol - Stroep.nl - 2009 (c)
	 */
	public class Image extends Sprite
	{
		public var bitmap:Bitmap;
		private var bitmapdata:BitmapData;
		private var loader:Loader;
		private var _src:String;
		private var req:URLRequest;
		private var scale:Number;
		private var _enableContextMenu:Boolean;
		
		private var item1:ContextMenuItem;			
		private var item2:ContextMenuItem;		
		private var item3:ContextMenuItem;		
		private var item4:ContextMenuItem;		
		private var item5:ContextMenuItem;
		
		/**
		 * 
		 * @param	url	relative or absolute path to the image
		 */
		public function Image( url:String, scale:Number = 1, enableContextMenu:Boolean = false ) 
		{
			bitmapdata = new BitmapData ( 400, 300 );	
			bitmap = new Bitmap( bitmapdata, PixelSnapping.AUTO, true );
			this.addChild(bitmap);
			
			this.scale = scale;			
			this.src = url;	
			this.enableContextMenu = enableContextMenu;
		}		
		
		private function onLoadComplete(e:Event):void 
		{	
			this.removeChild(bitmap);
			bitmapdata = new BitmapData ( this.loader.width * scale, this.loader.height * scale );		
			bitmapdata.draw( this.loader, new Matrix( scale, 0, 0, scale, 0, 0 ), null, BlendMode.NORMAL, null, true );
			bitmap = new Bitmap( bitmapdata, PixelSnapping.AUTO, true );					
			this.addChild(bitmap);
			
			this.loader.contentLoaderInfo.removeEventListener( Event.COMPLETE, onLoadComplete );
			this.loader.contentLoaderInfo.removeEventListener( IOErrorEvent.IO_ERROR, onError );
			this.loader.contentLoaderInfo.removeEventListener( ProgressEvent.PROGRESS, onLoading );
			this.loader  = null;
			
			dispatchEvent(e);
		}
		
		private function onLoading( e:ProgressEvent ):void 
		{		
			dispatchEvent(e);
		}
		
		private function onError(e:IOErrorEvent):void 
		{
			dispatchEvent(e);
		}
		
		public function get src():String { return _src; }
		
		public function set src(value:String):void 
		{
			_src = value;
			
			if ( value != "" && value != null )
			{
				this.loader = new Loader();

				this.loader.contentLoaderInfo.addEventListener( Event.COMPLETE, onLoadComplete );
				this.loader.contentLoaderInfo.addEventListener( IOErrorEvent.IO_ERROR, onError );
				this.loader.contentLoaderInfo.addEventListener( ProgressEvent.PROGRESS, onLoading );
				
				req = new URLRequest( value );			
				this.loader.load( req );   
			}
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