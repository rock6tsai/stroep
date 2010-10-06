package nl.stroep.framework.transitions 
{
	import com.greensock.TweenLite;
	import nl.stroep.framework.Page;
	import nl.stroep.framework.transitions.interfaces.ITransition;
	/**
	 * Fading page transition
	 * @author Mark Knol
	 */
	public class FadeTransition implements ITransition
	{
		
		public function FadeTransition() 
		{
			
		}
		
		/* INTERFACE nl.stroep.framework.transitions.interfaces.ITransition */
		
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