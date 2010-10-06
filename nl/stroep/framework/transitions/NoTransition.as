package nl.stroep.framework.transitions 
{
	import com.greensock.TweenLite;
	import nl.stroep.framework.Page;
	import nl.stroep.framework.transitions.interfaces.ITransition;
	/**
	 * No page transition.
	 * @author Mark Knol
	 */
	public class NoTransition implements ITransition
	{
			
		public function NoTransition() 
		{
			
		}
		
		/* INTERFACE nl.stroep.framework.transitions.interfaces.ITransition */
		
		public function animateIn(page:Page, speed:Number, easing:Function):void
		{
			if (speed == 0 ) 
			{
				page.onShowComplete();
				return;
			}
			else
			{
				TweenLite.delayedCall( speed, page.onShowComplete );
			}
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
				TweenLite.delayedCall( speed, page.onHideComplete );
			}
		}
	}

}