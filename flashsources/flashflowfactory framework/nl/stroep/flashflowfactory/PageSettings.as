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
		/**
		 *Transition which implement ITransition that takes care of the in+out animation. Default: NoTransition. 
		 */
		public var transition:ITransition;
		/**
		 * Easing function which will be applied on the in-animation. You can use easing equotations from several tweenengines. Default: Build-in Quart out
		 */
		public var easingInFunc:Function;
		/**
		 * Easing function which will be applied on the out-animation. You can use easing equotations from several tweenengines. Default: Build-in Quart out
		 */
		public var easingOutFunc:Function;
		/**
		 * Duration of the in-animation in milliseconds. This value should not be negative.
		 */
		public var transitionInSpeed:Number = 0;
		/**
		 * Duration of the out-animation in milliseconds. This value should not be negative.
		 */
		public var transitionOutSpeed:Number = 0;
		/**
		 * Alignment of the page to the stage. You can use the Alignment class for this value. Default value: "left_top"
		 */
		public var pageAlignment:String;
		/**
		 * Alignment of the centerpoint inside the page. Normally you should place the centerpoint to the upperleft, You can use the Alignment class for this settings. Default value: "left_top"
		 */
		public var clipAlignment:String;
		
		/**
		 * Page settings value object. Will be applied on every Page. 
		 * @param	transition	Transition which implement ITransition that takes care of the in+out animation. Default: NoTransition.
		 * @param	easingInFunc	Easing function which will be applied on the in-animation. You can use easing equotations from several tweenengines. Default: Build-in Quart out
		 * @param	easingOutFunc	Easing function which will be applied on the out-animation. You can use easing equotations from several tweenengines. Default: Build-in Quart out
		 * @param	transitionInSpeed	Duration of the in-animation in milliseconds. This value should not be negative.
		 * @param	transitionOutSpeed	Duration of the out-animation in milliseconds. This value should not be negative.
		 * @param	pageAlignment	Alignment of the page to the stage. You can use the Alignment class for this value. 
		 * @param	clipAlignment	Alignment of the centerpoint inside the page. Normally you should place the centerpoint to the upperleft, You can use the Alignment class for this settings. Default value: "left_top"
		 */
		public function PageSettings( transition:ITransition = null, easingInFunc:Function = null, easingOutFunc:Function = null, transitionInSpeed:Number = 0, transitionOutSpeed:Number = 0, pageAlignment:String = "left_top", clipAlignment:String = "left_top"):void
		{
			this.transition = transition || new NoTransition();
			
			this.easingInFunc = easingInFunc || defaultEasing;
			this.easingOutFunc = easingOutFunc || defaultEasing;
			
			this.transitionInSpeed = transitionInSpeed || 0;
			this.transitionOutSpeed = transitionOutSpeed | 0;
			
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
		
		/**
		 * Create new instance with same PageSettings as current instance.
		 * @return cloned PageSettings instance
		 */
		public function clone():PageSettings
		{
			return new PageSettings(transition, easingInFunc, easingOutFunc, transitionInSpeed, transitionOutSpeed, pageAlignment, clipAlignment);
		}
	}

}