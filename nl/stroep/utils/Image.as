package nl.stroep.utils 
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
		/**
		 * 
		 * @param	url	relative or absolute path to the image
		 */
		public function Image( url:String, scale:Number = 1 ) 
		{
			bitmapdata = new BitmapData ( 400, 300 );	
			bitmap = new Bitmap( bitmapdata, PixelSnapping.AUTO, true );
			this.addChild(bitmap);
			
			this.scale = scale;			
			this.src = url;	
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
		
	}
	
}