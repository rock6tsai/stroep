package nl.stroep.utils 
{
	/**
	 * ...
	 * @author Mark Knol
	 */
	public class ColorUtil
	{
		public static const DEFAULT:uint = 0
		public static const RANDOM:uint = 1
		
		/**
		 * Returns a pure random Color instance
		 * @return pure random Color instance
		 */		
		public static function getPureRandomColor():Color
		{
			return new Color(getPureRandomColorValue());
		}
		
		/**
		 * Returns a randomized color using a random distance
		 * @param	value	Color value
		 * @param	offset	Random offset from color
		 * @param	type	Color.DEFAULT = 0 Lighten/darkened colors. <br>Color.RANDOM = 1 Noisy colors
		 * @return	Color instance with a randomized color
		 */
		public static function getRandomColor(value:int, offset:int = 0, type:uint = 0):Color
		{
			var retval:Color = new Color(value);
			
			if (type == RANDOM)
			{
				retval.red   += -offset * 0.5 + Math.random() * offset;
				retval.green += -offset * 0.5 + Math.random() * offset;
				retval.blue  += -offset * 0.5 + Math.random() * offset;
			}
			else if (type == DEFAULT)
			{
				if (Math.random() > 0.5) 
				{
					retval.value = retval.lighter(Math.random() * offset);
				}
				else
				{
					retval.value = retval.darker(Math.random() * offset);
				}
			}
			return retval;
		}
		
		/**
		 * Returns a pure random between 0x000000 and 0xFFFFFF
		 * @return	Color value
		 */
		public static function getPureRandomColorValue():int
		{
			return Math.random() * 0xFFFFFF;
		}
		
		/**
		 * Gets a random color value (int) based
		 * @param	value	Color value
		 * @param	offset	Random offset from color
		 * @param	type	Color.DEFAULT = 0 Lighten/darkened colors. <br>Color.RANDOM = 1 Noisy colors
		 * @return	Color value
		 */
		public static function getRandomColorValue(value:int, offset:int = 0, type:uint = 0):int
		{
			return getRandomColor(value, offset, type).value;
		}
		
		/**
		 * Gets random list with color values (int)
		 * @param	length	Length of returning list
		 * @param	value	Color value
		 * @param	offset	Random offset from color
		 * @return Array with color values (int)
		 */
		public static function getRandomColorValueList(length:int, value:int, offset:int = 0, type:uint = 0):/*int*/Array
		{
			var retval:/*int*/Array = [];
			for (var i:uint = 0; i < length; ++i) 
			{
				retval.push( getRandomColorValue(value, offset, type) );
			}
			return retval;
		}
		
		/**
		 * Gets random list with Color instances
		 * @param	length	Length of returning list
		 * @param	value	Color value
		 * @param	offset	Random offset from color
		 * @param	type	Color.DEFAULT = 0 Lighten/darkened colors. <br>Color.RANDOM = 1 Noisy colors
		 * @return 	Array with Color instances
		 */
		public static function getRandomColorList(length:int, value:int, offset:int = 0, type:uint = 0):/*Color*/Array
		{
			var retval:/*Color*/Array = [];
			for (var i:uint = 0; i < length; ++i) 
			{
				retval.push( getRandomColor(value, offset, type) );
			}
			return retval;
		}
		
		/**
		 * calculates constrast YIQ and returns black or white
		 * @param	value	Color value
		 * @return	black or white color value
		 */
		public static function getContrastYIQ(value:int):int
		{
			var color:Color = new Color(value);
			var yiq:Number = ((color.red * 0x12B) + (color.green * 0x24B) + (color.blue * 0x90)) * 0.001;
			return (yiq >= 131.5) ? 0xFFFFFF : 0;
		}
	}

}