package nl.stroep.framework 
{
	import com.greensock.easing.Strong;
	import nl.stroep.framework.transitions.interfaces.ITransition;
	import nl.stroep.framework.transitions.NoTransition;
	/**
	 * Page settings value object. 
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
		
		public function PageSettings( transition:ITransition = null, easingInFunc:Function = null, easingOutFunc:Function = null, transitionInSpeed:Number = 0, transitionOutSpeed:Number = 0, pageAlignment:String = "top_left", clipAlignment:String = "top_left"):void
		{
			/// Default transition function. Can be overrided when extending this Page class
			this.transition = (transition) ? transition : new NoTransition();
			
			this.easingInFunc = (easingInFunc != null) ? easingInFunc : Strong.easeOut;
			this.easingOutFunc = (easingOutFunc != null) ? easingOutFunc : Strong.easeOut;
			
			this.transitionInSpeed = (transitionInSpeed) ? transitionInSpeed : 0;
			this.transitionOutSpeed = (transitionOutSpeed) ? transitionOutSpeed : 0;
			
			this.pageAlignment = pageAlignment;
			this.clipAlignment = clipAlignment;
		}
		
		public function clone():PageSettings
		{
			return new PageSettings(transition, easingInFunc, easingOutFunc, transitionInSpeed, transitionOutSpeed, pageAlignment, clipAlignment);
		}
	}

}