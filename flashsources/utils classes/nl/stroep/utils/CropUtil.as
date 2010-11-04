﻿/*The MIT License

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
	import flash.display.DisplayObject;
	import flash.display.PixelSnapping;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	/**
	 * Crop util	
	 * 
	 *  @example
	 * 		var myCroppedImage:Bitmap = CropUtil.crop( this, 0, 0, 1366, 768);
	 * 		addChild(myCroppedImage);
	 * 
	 * @author Mark Knol - Stroep.nl - 2009 (c)
	 */
	public class CropUtil 
	{		
		/**
		 * crop a image on the stage or in a movieclip
		 * 
		 * @param	inDisplayObject		object on the display list (this or foobarMovie)
		 * @param	inWidth				width of the cropped image (default = 550)
		 * @param	inHeight			height of the cropped image (default = 400)
		 * @param	inX					left starting point in pixels (default = 0)
		 * @param	inY					top starting point in pixels (default = 0)
		 * @param	inScale				scale (default 1, don't know any reason to change that...)
		 * @return
		 */
		public static function crop( inDisplayObject:DisplayObject, inWidth:Number = 550, inHeight:Number = 400, inX:Number = 0, inY:Number = 0, inScale:Number = 1):Bitmap
		{
			if (!inDisplayObject) { throw new Error('CropUtil.crop > needs a something on the display list'); return null; }
			var cropArea:Rectangle = new Rectangle( 0, 0, inWidth * inScale, inHeight * inScale);
			var croppedBitmap:Bitmap = new Bitmap( new BitmapData( inWidth * inScale, inHeight * inScale), PixelSnapping.ALWAYS, true );
			croppedBitmap.bitmapData.draw( inDisplayObject, new Matrix(inScale, 0, 0, inScale, -inX, -inY), null, null, cropArea, true );
			return croppedBitmap;
		}
	}
	
}