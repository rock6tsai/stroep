package nl.stroep.utils 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.PixelSnapping;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	/**
	 * Crop util
	 * @author Mark Knol - Stroep.nl - 2009 (c)
	 */
	public class CropUtil 
	{		
		public static function crop( _x:Number, _y:Number, _width:Number, _height:Number, scale:Number = 1, displayObject:DisplayObject = null):Bitmap
		{
			var cropArea:Rectangle = new Rectangle( 0, 0, _width*scale, _height*scale );
			var croppedBitmap:Bitmap = new Bitmap( new BitmapData( _width*scale, _height*scale ), PixelSnapping.ALWAYS, true );
			croppedBitmap.bitmapData.draw( (displayObject!=null) ? displayObject : stage, new Matrix(scale, 0, 0, scale, -_x, -_y) , null, null, cropArea, true );
			return croppedBitmap;
		}
	}
	
}