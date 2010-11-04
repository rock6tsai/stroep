package nl.stroep.flashflowfactory.transitions 
{
	import com.gskinner.motion.GTween;
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
			var tween:GTween = new GTween(page, speed, { alpha:1 }, { ease: easing } );
			tween.onComplete = page.onShowComplete;
		}
		
		public function animateOut(page:Page, speed:Number, easing:Function):void
		{
			var tween:GTween = new GTween(page, speed, { alpha:0 }, { ease: easing } );
			tween.onComplete = page.onHideComplete;
		}
		
	}

}