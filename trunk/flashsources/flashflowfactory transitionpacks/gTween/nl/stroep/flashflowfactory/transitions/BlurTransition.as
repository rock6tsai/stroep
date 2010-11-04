package nl.stroep.flashflowfactory.transitions 
{
	import com.gskinner.motion.GTween;
	import com.gskinner.motion.plugins.BlurPlugin;
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
			BlurPlugin.install();
		}
		
		/* INTERFACE nl.stroep.flashflowfactory.transitions.interfaces.ITransition */
		
		public function animateIn(page:Page, speed:Number, easing:Function):void
		{
			page.alpha = 0;
			TweenLite.to( page, 0, { autoAlpha: 0, blurFilter: { blurX:0, blurY:0, quality:this.quality, remove:false } });
			TweenLite.to( page, speed, { delay:0.01, overwrite:false, autoAlpha: 1, blurFilter: { blurX:0, blurY:0, quality:this.quality, remove:true }, onComplete: page.onShowComplete, ease: easing } );
			
			//TODO: finiah him
			//var tween1:GTween = new GTween(page, speed, { alpha:1 }, { ease: easing }, {blurX: 0, blurY: 0, quality: quality} );
			//tween1.onComplete = page.onShowComplete;
			var tween2:GTween = new GTween(page, speed, { alpha:1 }, { ease: easing }, {blurX: 0, blurY: 0, quality: quality} );
			tween2.onComplete = page.onShowComplete;
		}
		
		public function animateOut(page:Page, speed:Number, easing:Function):void
		{
			TweenLite.to( page,  speed, { autoAlpha: 0, blurFilter: { blurX:blurAmount, blurY:blurAmount, quality:this.quality, remove:false }, onComplete: page.onHideComplete, ease: easing } );
			
			var tween:GTween = new GTween(page, speed, { alpha:0 }, { ease: easing }, {blurX: blurAmount, blurY: blurAmount, quality: quality} );
			tween.onComplete = page.onHideComplete;
		}
	}

}