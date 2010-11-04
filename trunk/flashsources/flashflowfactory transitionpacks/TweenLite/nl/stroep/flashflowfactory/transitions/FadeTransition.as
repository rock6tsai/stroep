package nl.stroep.flashflowfactory.transitions 
{
	import com.greensock.plugins.AutoAlphaPlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.greensock.TweenLite;
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
			TweenPlugin.activate([AutoAlphaPlugin]);
		}
		
		/* INTERFACE nl.stroep.flashflowfactory.transitions.interfaces.ITransition */
		
		public function animateIn(page:Page, speed:Number, easing:Function):void
		{
			page.alpha = 0;
			TweenLite.to( page, speed, { autoAlpha: 1, onComplete: page.onShowComplete, ease: easing } );
		}
		
		public function animateOut(page:Page, speed:Number, easing:Function):void
		{
			TweenLite.to( page,  speed, { autoAlpha: 0, onComplete: page.onHideComplete, ease: easing } );
		}
		
	}

}