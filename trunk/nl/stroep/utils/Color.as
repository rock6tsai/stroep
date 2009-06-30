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
    * Util for working with Color
    *
    * @author I-Company | Mark Knol | 2008
    */
    public class Color
    {      
		/** the real color value */
		public var value:uint = 0;
		
		
		public function Color ( value:uint = 0xFFFFFF ):void
		{
			this.value = value;
		}
		
        /**
        * Get the red value of a color
        *
        * @param color Enter full color from range 0x000000 to 0xFFFFFF
        * @return Red colorvalue
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
        * @return Green colorvalue
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
        * @return Blue colorvalue
        * @tiptext
        */
        public function get blue ( ):uint       
        {
            return value & 0xFF;
        }
       
		
        /**
         * Set new red value to a color
         * @param    tint    range between 0-255
         * @tiptext
         */
        public function set red ( tint:uint ):void
        {
			tint = limit( tint, 0, 255);           
            this.value += (tint << 16)
        }
       
       
        /**
         * Set new green value to a color
         * @param    tint    range between 0-255
         * @tiptext
         */
        public function set green ( tint:uint ):void
        {
			tint = limit( tint, 0, 255);
		   
            this.value += (tint << 8);
        }
       
       
        /**
         * Set new blue value to a color
         * @param    tint    range between 0-255
         * @tiptext
         */
        public function set blue ( tint:uint ):void
        {		
			tint = limit( tint, 0, 255);
           
            this.value += tint;
        }
		
		
        /**
        * Get a grayscale color from a tint
        *
        * @param tint Enter tint from range 0 to 255
        * @return Gray colorvalue
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
         * Darken or lighten color with count(-255 to 255)<br/>
         * Darken = count &lt; 0<br/>
         * Lighten = count &gt; 0
         * @param    count    amount sliding color (-255 to 255)
         * @return darker color
		 * @tiptext
         */
        public function slideColor( count:int = 0 ):uint
        {
            var retval:uint = value; 
			
            var r:int = limit( (retval >> 16) + count, 0, 255)
            var g:int = limit( (retval >> 8 & 0xFF)  + count, 0, 255)
            var b:int = limit( (retval & 0xFF) + count, 0, 255)
           
            return ( r ) << 16 | ( g ) << 8 | ( b );
        }   
		
		
		 /**
         * Darken color with amount (0 to 255)
         * @param    count    amount darken color (-255 to 255)
         * @return darker color
		 * @tiptext
         */
        public function darker( count:uint = 0 ):uint
        {     
            return slideColor(-count);
        }   
		
		
		/**
         * Lighten color with amount (0 to 255)
         * @param    count    amount lighten color (-255 to 255)
         * @return lighter color
		 * @tiptext
         */
        public function lighter( count:uint = 0 ):uint
        {
            return slideColor( count);        
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