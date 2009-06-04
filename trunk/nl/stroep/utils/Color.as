package nl.stroep.utils 
{
    /**
    * Util for working with Color
    *
    * @author I-Company | Mark Knol | 2008
    */
    public class Color
    {      
		public var value:Number = 0;
		
		public function Color ( value:uint = 0xFFFFFF ):void
		{
			this.value = value;
		}
		
        /**
        * Get the red value of a color
        *
        * @param color Enter full color from range 0x000000 to 0xFFFFFF
        * @return Red value from the color
        * @tiptext
        */
        public function get red ( ):uint       
        {
            return value >> 16 & 0xFF;
        }
       
       
        /**
        * Get the green value of a color
        *
        * @param color Enter full color from range 0x000000 to 0xFFFFFF
        * @return Green hexadecimal colorvalue
        * @tiptext
        */
        public function get green ( ):uint       
        {
            return value >> 8 & 0xFF;
        }
       
       
        /**
        * Get the blue value of a color
        *
        * @param color Enter full color from range 0x000000 to 0xFFFFFF
        * @return Blue hexadecimal colorvalue
        * @tiptext
        */
        public function get blue ( ):uint       
        {
            return value & 0xFF;
        }
       
       
        /**
        * Get a grayscale color from a tint
        *
        * @param tint Enter tint from range 0 to 255
        * @return Gray hexadecimal colorvalue
        * @tiptext
        */
        public static function grayscale ( tint:uint = 0 ):uint
        {
            // restriction
            if (tint < 0) { tint = 0 }
            if (tint > 255) { tint = 255 }
           
            return (tint << 16) | (tint << 8) | tint;
        }
       
        /**
         * set new red value to a color
         * @param    tint    range between 0-255
         * @param    color    color to edit
         * @tiptext
         */
        public function set red ( tint:uint ):void
        {
            // restriction
            if (tint < 0) { tint = 0 }
            if (tint > 255) { tint = 255 }
           
            this.value += (tint << 16)
        }
       
       
        /**
         * set new green value to a color
         * @param    tint    range between 0-255
         * @param    color    color to edit
         * @tiptext
         */
        public function set green ( tint:uint ):void
        {
            // restriction
            if (tint < 0) { tint = 0 }
            if (tint > 255) { tint = 255 }
           
            this.value += (tint << 8);
        }
       
       
        /**
         * set new blue value to a color
         * @param    tint    range between 0-255
         * @param    color    color to edit
         * @tiptext
         */
        public function set blue ( tint:uint  ):void
        {
            // restriction
            if (tint < 0) { tint = 0 }
            if (tint > 255) { tint = 255 }
           
            this.value += tint;
        }
		
       
        /**
         * Darken or lighten color with count
         * Darken = count < 0
         * Lighten = count > 0
         * @param    color    color to be darkened or lightened
         * @return Hexadecimal colorvalue of darkened/lightened color
		 * @tiptext
         */
        public function slideColor( count:Number = 0 ):uint
        {
            var retval:uint = value;  
   
            var r:int = limit( (retval >> 16) + count, 0, 255)
            var g:int = limit( (retval >> 8 & 0xFF)  + count, 0, 255)
            var b:int = limit( (retval & 0xFF) + count, 0, 255)
           
            return ( r ) << 16 | ( g ) << 8 | ( b );
        }       
		
        private function limitToLower( value:Number, lowerLimit:Number ):Number
        {
            return Math.max( value, lowerLimit );
        }

        private function limitToUpper( value:Number, upperLimit:Number ):Number
        {
            return Math.min( value, upperLimit );
        }

        private function limit( value:Number, lowerLimit:Number, upperLimit:Number ):Number
        {
            return limitToLower( limitToUpper( value, upperLimit ), lowerLimit );
        }
    }

	
}