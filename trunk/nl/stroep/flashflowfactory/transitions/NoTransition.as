package nl.stroep.flashflowfactory.transitions 
{
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	import nl.stroep.flashflowfactory.Page;
	import nl.stroep.flashflowfactory.transitions.interfaces.ITransition;
	/**
	 * Default transition, without options. If you define a speed-value higher than 0, it will use a delay.
	 * 
	 * Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
	 * @author Mark Knol
	 */
	public class NoTransition implements ITransition
	{
		private var timeoutID:uint;
		
		public function NoTransition() 
		{
			
		}
		
		/* INTERFACE nl.stroep.flashflowfactory.transitions.interfaces.ITransition */
		
		public function animateIn(page:Page, speed:Number, easing:Function):void
		{
			if (speed == 0 ) 
			{
				page.onShowComplete();
				return;
			}
			else
			{
				timeoutID = setTimeout(onAnimateInComplete, speed, page);
			}
		}
		
		private function onAnimateInComplete(page:Page):void 
		{
			clearTimeout(timeoutID);
			page.onShowComplete();
		}
		
		public function animateOut(page:Page, speed:Number, easing:Function):void
		{
			if (speed == 0 ) 
			{
				page.onHideComplete();
				return;
			}
			else
			{
				timeoutID = setTimeout(onAnimateOutComplete, speed, page);
			}
		}
		
		private function onAnimateOutComplete(page:Page):void 
		{
			clearTimeout(timeoutID);
			page.onHideComplete();
		}
	}

}