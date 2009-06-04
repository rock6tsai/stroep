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
		private var scale:Number = 1;
		/**
		 * 
		 * @param	url	relative or absolute path to the image
		 */
		public function Image( url:String = "" ) 
		{		
			this.loader = new Loader();
			this.addChild( loader );

			this.loader.contentLoaderInfo.addEventListener( Event.COMPLETE, onLoadComplete );		   
			this.loader.contentLoaderInfo.addEventListener( IOErrorEvent.IO_ERROR, onError );		   
			this.loader.contentLoaderInfo.addEventListener( ProgressEvent.PROGRESS, onLoading );	
			
			bitmapdata = new BitmapData ( 400, 300 );	
			bitmap = new Bitmap( bitmapdata, PixelSnapping.AUTO, true );
			
			this.scale = scale;
			
			this.src = url;	
		}		
		
		private function onLoadComplete(e:Event):void 
		{	
			bitmapdata = new BitmapData ( this.loader.width, this.loader.height );		
			bitmapdata.draw( this.loader, new Matrix( 1, 0, 0, 1 , 0, 0 ), null, BlendMode.NORMAL, null, true );
			bitmap = new Bitmap( bitmapdata, PixelSnapping.AUTO, true );
			
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
				req = new URLRequest( value );			
				this.loader.load( req );   
			}
		}
		
	}
	
}