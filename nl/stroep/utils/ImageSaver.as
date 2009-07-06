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
	/**
	* ImageSaver class for easy saving displayobjects to JPG / PNG
	* @author © Copyright 2009, Mark Knol | Stroep
	*/
	
	import com.adobe.images.*;
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.net.*;
	import flash.utils.ByteArray;
	
	public class ImageSaver extends EventDispatcher
	{				
		private const CONTENT_TYPE:String = "application/octet-stream";
		
		private const EXTENSION_JPG:String = "JPG";
		private const EXTENSION_PNG:String = "PNG";		
		
		private var bytearray:ByteArray;
		private var urlRequest:URLRequest;
		
		private var _ed:EventDispatcher;		
		private var _serverpath:String;
		
		private var jpgEncoder:JPGEncoder;
		
		/**
		 * Create instance of ImageSaver Class
		 * @param	serverpath 		Required. Path to server.
		 */
		public function ImageSaver( serverpath:String = "" ) 
		{	
			_serverpath = serverpath;
			_ed = new EventDispatcher();
		}
		
		/**
		 * Save displayobject to server
		 * @param	bitmapDrawable	Required. The bitmapDrawable that will be saved
		 * @param	filename		Required. The name of the new file including extension (only "JPG" and "PNG" supported)
		 * @param	rect			Optional. When rect is null, the bounds will be automaticly getted from the bitmapDrawable.
		 * @param	backgroundColor	Optional. Custom background color with alpha-channel. Default: transparent/white
		 * @param	JPGquality		Optional. The quality level between 1 and 100 that determines the level of compression used in the generated JPEG. 
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 10.0
		 * @tiptext
		 */
		public function save( bitmapDrawable:IBitmapDrawable, filename:String, backgroundColor:Number = 0x00FFFFFF, JPGquality:int = 85, rect:Rectangle = null ):void
		{				
			var bitmapdata:BitmapData = this.getBitmapData( bitmapDrawable, backgroundColor, rect );			
			var extension:String = this.getExtension( filename );
			
			switch ( extension.toUpperCase() )
			{		
				case EXTENSION_JPG :				
					jpgEncoder = new JPGEncoder( JPGquality )			
					this.bytearray = jpgEncoder.encode( bitmapdata );
					break;
				
				case EXTENSION_PNG :				
					this.bytearray = PNGEncoder.encode( bitmapdata );
					break;
				
				default :
					jpgEncoder = new JPGEncoder( JPGquality )			
					this.bytearray = jpgEncoder.encode( bitmapdata );
			}
			
			this.urlRequest = new URLRequest( this._serverpath + "?filename=" + filename );			
			this.urlRequest.contentType = this.CONTENT_TYPE;			
			this.urlRequest.method = URLRequestMethod.POST;			
			this.urlRequest.data = this.bytearray;
			
			var loader:URLLoader = new URLLoader();			
			loader.addEventListener( Event.COMPLETE, this.onSaveSucces );			
			loader.addEventListener( IOErrorEvent.IO_ERROR, this.onSaveFailed );
			loader.load( this.urlRequest );
			
		}
		/**
		 * Save displayobject local
		 * @param	bitmapDrawable	Required. The bitmapDrawable that will be saved
		 * @param	filename		Required. The name of the new file including extension (only "JPG" and "PNG" supported)
		 * @param	rect			Optional. When rect is null, the bounds will be automaticly getted from the bitmapDrawable.
		 * @param	backgroundColor	Optional. Custom background color with alpha-channel. Default: transparent/white
		 * @param	JPGquality		Optional. The quality level between 1 and 100 that determines the level of compression used in the generated JPEG. 
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 10.0
		 * @tiptext
		 */
		public function saveLocal( bitmapDrawable:IBitmapDrawable, filename:String, backgroundColor:Number = 0x00FFFFFF, JPGquality:int = 85, rect:Rectangle = null ):void
		{				
			var bitmapdata:BitmapData = this.getBitmapData( bitmapDrawable, backgroundColor, rect );			
			var extension:String = this.getExtension( filename );
			
			switch ( extension.toUpperCase() )
			{		
				case EXTENSION_JPG :				
					jpgEncoder = new JPGEncoder( JPGquality )			
					this.bytearray = jpgEncoder.encode( bitmapdata );
					break;
				
				case EXTENSION_PNG :				
					this.bytearray = PNGEncoder.encode( bitmapdata );
					break;
				
				default :
					jpgEncoder = new JPGEncoder( JPGquality )			
					this.bytearray = jpgEncoder.encode( bitmapdata );
			}
		
			this.urlRequest = new URLRequest( this._serverpath + "?filename=" + filename );			
			this.urlRequest.contentType = this.CONTENT_TYPE;			
			this.urlRequest.method = URLRequestMethod.POST;			
			this.urlRequest.data = this.bytearray;
			
			var file:FileReference = new FileReference();			
			file.addEventListener( Event.COMPLETE, this.onSaveSucces );			
			file.addEventListener( IOErrorEvent.IO_ERROR, this.onSaveFailed );
			file.save( this.bytearray, filename );			
		}
				
		/**
		 * Draws bitmapDrawable intro new bitmapdata object using backgroundColor 
		 * @param	bitmapDrawable	Object to draw into bitmapdata object
		 * @param	backgroundColor	Background color for bitmapdata object ( including alpha channel )
		 * @param	rect			Rectangle
		 * @return  bitmapData object with displayObject drawed into ( it and a nice backgroundColor
		 */
		private function getBitmapData( bitmapDrawable:IBitmapDrawable, backgroundColor:Number = 0xFFFFFFFF, rect:Rectangle = null ):BitmapData
		{
			if ( bitmapDrawable is BitmapData )
			{
				return bitmapDrawable as BitmapData;
			}  
			else 
			{			
				var displayObject:DisplayObject = bitmapDrawable as DisplayObject;
				
				var bitmapdata:BitmapData = new BitmapData( displayObject.width, displayObject.height, true, backgroundColor );
				
				var bitmap:Bitmap = new Bitmap( bitmapdata );
				
				if ( rect == null )
				{
					var matrix:Matrix = new Matrix( 1, 0, 0, 1, -displayObject.getBounds( bitmap ).x + displayObject.x, -displayObject.getBounds( bitmap ).y + displayObject.y )
				
					bitmapdata.draw( displayObject, matrix );
				}
				else
				{
					bitmapdata.draw( displayObject, null, null, null, rect );
				}
				return bitmapdata;			
			}
		}
		
		/**
		 * Get the extension of a file
		 * @param	filename	filename to strip extension from
		 * @return	Extension of the file
		 */
		private function getExtension( filename:String ):String
		{
			return filename.split(".")[1];
		}
	
		private function onSaveFailed( event:IOErrorEvent ):void
		{
			this.dispatchEvent( event );			
		}
		
		private function onSaveSucces( event:Event ):void
		{						
			this.dispatchEvent( event );			
		}		
		
		public function get serverpath():String { return this._serverpath; }
		
		public function set serverpath( value:String ):void 
		{
			this._serverpath = value;
		}
		
	}
	
}
