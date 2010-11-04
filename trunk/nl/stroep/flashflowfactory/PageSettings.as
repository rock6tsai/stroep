package nl.stroep.flashflowfactory 
{
	import nl.stroep.flashflowfactory.transitions.interfaces.ITransition;
	import nl.stroep.flashflowfactory.transitions.NoTransition;
	/**
	 * Page settings value object. 
	 * 
	 * Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
	 * @author Mark Knol
	 */
	public final class PageSettings
	{
		public var transition:ITransition;
		public var easingInFunc:Function;
		public var easingOutFunc:Function;
		public var transitionInSpeed:Number;
		public var transitionOutSpeed:Number;
		public var pageAlignment:String;
		public var clipAlignment:String;
		
		public function PageSettings( transition:ITransition = null, easingInFunc:Function = null, easingOutFunc:Function = null, transitionInSpeed:Number = 0, transitionOutSpeed:Number = 0, pageAlignment:String = "left_top", clipAlignment:String = "left_top"):void
		{
			this.transition = (transition) ? transition : new NoTransition();
			
			this.easingInFunc = (easingInFunc != null) ? easingInFunc : defaultEasing;
			this.easingOutFunc = (easingOutFunc != null) ? easingOutFunc : defaultEasing;
			
			this.transitionInSpeed = (transitionInSpeed) ? transitionInSpeed : 0;
			this.transitionOutSpeed = (transitionOutSpeed) ? transitionOutSpeed : 0;
			
			this.pageAlignment = pageAlignment;
			this.clipAlignment = clipAlignment;
		}
		
		// Quart out
		private function defaultEasing(...values:Array):Number 
		{
			if (values.length == 1) // Applies for: Eaze-tween, TweenLite, gTween
			{
				var k:Number = values[0] || 0;
				return -(--k * k * k * k - 1);
			}
			else // special exeption for Tweener, which uses other easing system
			{
				var t:Number = values[0] || 0;
				var b:Number = values[1] || 0;
				var c:Number = values[2] || 0;
				var d:Number = values[3] || 0;
				var p_params:Object = values[4];
				return -c * (t /= d) * (t - 2) + b;
			}
		}
		
		public function clone():PageSettings
		{
			return new PageSettings(transition, easingInFunc, easingOutFunc, transitionInSpeed, transitionOutSpeed, pageAlignment, clipAlignment);
		}
	}

}