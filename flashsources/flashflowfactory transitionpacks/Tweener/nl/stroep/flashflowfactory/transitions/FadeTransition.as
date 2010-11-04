package nl.stroep.flashflowfactory.transitions 
{
	import caurina.transitions.Tweener;
	import nl.stroep.flashflowfactory.Page;
	import nl.stroep.flashflowfactory.transitions.interfaces.ITransition;
	/**
	 * Transition which fades the page. Without options.
	 * 
	 * Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
	 * @author Mark Knol
	 */
	public class FadeTransition implements ITransition
	{
		
		public function FadeTransition() 
		{
		}
		
		/* INTERFACE nl.stroep.flashflowfactory.transitions.interfaces.ITransition */
		
		public function animateIn(page:Page, speed:Number, easing:Function):void
		{
			page.alpha = 0;
			Tweener.addTween(page, {time:speed, alpha:1, onComplete: page.onShowComplete, transition:easing});
		}
		
		public function animateOut(page:Page, speed:Number, easing:Function):void
		{
			Tweener.addTween(page, {time:speed, alpha:0, onComplete: page.onHideComplete, transition:easing});
		}
		
	}

}