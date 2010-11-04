package nl.stroep.flashflowfactory.transitions 
{
	import caurina.transitions.properties.FilterShortcuts;
	import caurina.transitions.Tweener;
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
			
			FilterShortcuts.init();
		}
		
		/* INTERFACE nl.stroep.flashflowfactory.transitions.interfaces.ITransition */
		
		public function animateIn(page:Page, speed:Number, easing:Function):void
		{
			Tweener.addTween(page, {time:0, alpha:0, _Blur_quality:quality, _Blur_blurX:blurAmount,_Blur_blurY:blurAmount});
			Tweener.addTween(page, {time:speed, delay:0.01, alpha:1, _Blur_quality:quality, _Blur_blurX:0,_Blur_blurY:0, onComplete: page.onShowComplete, transition:easing});
		}
		
		public function animateOut(page:Page, speed:Number, easing:Function):void
		{
			Tweener.addTween(page, {time:speed, alpha:0, _Blur_quality:quality, _Blur_blurX:blurAmount,_Blur_blurY:blurAmount, onComplete: page.onHideComplete, transition:easing});
		}
	}

}