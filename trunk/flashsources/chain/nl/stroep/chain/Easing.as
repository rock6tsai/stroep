package nl.stroep.chain 
{
	/**
	 * @author Robert Penner / http://www.robertpenner.com/easing_terms_of_use.html
	 */

	public class Easing
	{
		public function Easing() { throw new Error("Cannot instantiate Easing class") };
		
		/// linear
		public static function linear(k:Number = 0):Number
		{
			return k;
		}		
		
		/// Quart easeIn
		public static function quartIn(k:Number = 0):Number 
		{
			return k * k * k * k;
		}
		
		/// Quart easeOut
		public static function quartOut(k:Number = 0):Number 
		{
			return -(--k * k * k * k - 1);
		}
		
		/// Quart easeInOut
		public static function quartInOut(k:Number = 0):Number 
		{
			if ((k *= 2) < 1) return 0.5 * k * k * k * k;
			return -0.5 * ((k -= 2) * k * k * k - 2);
		}
		
		/// Elastic easeIn
		public static function elasticIn(k:Number = 0):Number
		{
			var a:Number = 1;
			var p:Number  = 0.4;
			
			if (k == 0) return 0; if (k == 1) return 1;
			var s:Number =  p / (2 * Math.PI) * Math.asin (1 / a);
			return -(a * Math.pow(2, 10 * (k -= 1)) * Math.sin( (k - s) * (2 * Math.PI) / p ));
		}
		
		/// Elastic easeOut
		public static function elasticOut(k:Number = 0):Number
		{
			var a:Number = 1;
			var p:Number  = 0.4;
			
			if (k == 0) return 0; if (k == 1) return 1; 
			var s:Number = p / (2 * Math.PI) * Math.asin (1 / a);
			return (a * Math.pow(2, -10 * k) * Math.sin((k - s) * (2 * Math.PI) / p ) + 1);
		}
		
		/// Elastic easeInOut
		public static function elasticInOut(k:Number = 0):Number
		{
			var a:Number = 1;
			var p:Number  = 0.35;
			
			if (k == 0) return 0; if (k == 1) return 1; 
			var s:Number = p / (2 * Math.PI) * Math.asin (1 / a);
			if ((k *= 2) < 1) return -0.5 * (a * Math.pow(2, 10 * (k -= 1)) * Math.sin( (k - s) * (2 * Math.PI) / p ));
			return a * Math.pow(2, -10 * (k -= 1)) * Math.sin( (k - s) * (2 * Math.PI) / p ) * .5 + 1;			
		}
		
		/// Back easeIn
		static public function backIn(k:Number = 0):Number
		{
			var s:Number = 1.70158;
			return k * k * ((s + 1) * k - s);
		}
		
		/// Back easeOut
		static public function backOut(k:Number = 0):Number
		{
			var s:Number = 1.70158;
			return (k = k - 1) * k * ((s + 1) * k + s) + 1;
		}
		
		/// Back easeInOut
		static public function backInOut(k:Number = 0):Number
		{
			var s:Number = 1.70158;
			if ((k *= 2) < 1) return 0.5 * (k * k * ((s + 1) * k - s));
			return 0.5 * ((k -= 2) * k * ((s + 1) * k + s) + 2);
		}
	}
}