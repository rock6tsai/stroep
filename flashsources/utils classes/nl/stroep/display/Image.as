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


package nl.stroep.display 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.Loader;
	import flash.display.PixelSnapping;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.geom.Matrix;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	
	/**
	 * Image class for loading images
	 * @author Mark Knol - Stroep.nl - 2009 (c)
	 */
	public class Image extends Sprite
	{
		public var bitmap:Bitmap;
		protected var bitmapdata:BitmapData;
		protected var loader:Loader;
		protected var _src:String;
		private var req:URLRequest;
		protected var scale:Number;
		
		/**
		 * 
		 * @param	url	relative or absolute path to the image
		 */
		public function Image( url:String, scale:Number = 1 ) 
		{
			this.scale = scale;			
			this.src = url;	
		}		
		
		private function onLoadComplete(e:Event):void 
		{	
			if (bitmap && this.contains(bitmap)) {
				this.removeChild(bitmap);
				bitmap = null;
				bitmapdata = null;
			}
			
			bitmapdata = new BitmapData ( this.loader.width * scale, this.loader.height * scale, true, 0x00FFFFFF );		
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
				this.loader.load( req, new LoaderContext(true) );   
			}
		}		
	}
	
}