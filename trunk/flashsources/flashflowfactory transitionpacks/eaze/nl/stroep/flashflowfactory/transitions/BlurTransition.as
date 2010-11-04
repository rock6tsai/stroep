package nl.stroep.flashflowfactory.transitions 
{
	import aze.motion.eaze;
	import nl.stroep.flashflowfactory.Page;
	import nl.stroep.flashflowfactory.transitions.interfaces.ITransition;
	/**
	 * Transition which blurs the page with a specified blur quality and blur amount. Keep in mind blurring could be a CPU heavy task. 
	 * 
	 * Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
	 * @author Mark Knol
	 */
	public class BlurTransition implements ITransition
	{
		private var quality:uint;
		private var blurAmount:Number;
		
		public function BlurTransition(blurAmount:Number = 20, quality:uint = 2) 
		{
			this.quality = quality;
			this.blurAmount = blurAmount;
		}
		
		/* INTERFACE nl.stroep.flashflowfactory.transitions.interfaces.ITransition */
		
		public function animateIn(page:Page, speed:Number, easing:Function):void
		{
			eaze(page).from(speed, {alpha: 0, blurFilter: { blurX:blurAmount, blurY:blurAmount, quality:this.quality}}).onComplete(page.onShowComplete).easing(easing);
		}
		
		public function animateOut(page:Page, speed:Number, easing:Function):void
		{
			eaze(page).to(speed, {alpha: 0, blurFilter: { blurX:blurAmount, blurY:blurAmount, quality:this.quality}}).onComplete(page.onHideComplete).easing(easing);
		}
	}

}