package nl.stroep.framework.transitions 
{
	import com.greensock.TweenLite;
	import nl.stroep.framework.Page;
	import nl.stroep.framework.transitions.interfaces.ITransition;
	/**
	 * Blur + fading page transition
	 * @author Mark Knol
	 */
	public class BlurTransition implements ITransition
	{
		private var quality:uint;
		private var blurAmount:Number;
		
		public function BlurTransition(quality:uint = 2, blurAmount:Number = 10) 
		{
			this.quality = quality;
			this.blurAmount = blurAmount;
		}
		
		/* INTERFACE nl.stroep.framework.transitions.interfaces.ITransition */
		
		public function animateIn(page:Page, speed:Number, easing:Function):void
		{
			page.alpha = 0;
			TweenLite.to( page, 0, { autoAlpha: 0, blurFilter: { blurX:0, blurY:0, quality:this.quality, remove:false } });
			TweenLite.to( page, speed, { delay:0.01, overwrite:false,autoAlpha: 1, blurFilter: { blurX:0, blurY:0, quality:this.quality, remove:true}, onComplete: page.onShowComplete, ease: easing } );
		}
		
		public function animateOut(page:Page, speed:Number, easing:Function):void
		{
			TweenLite.to( page,  speed, { autoAlpha: 0, blurFilter: { blurX:blurAmount, blurY:blurAmount, quality:this.quality, remove:false}, onComplete: page.onHideComplete, ease: easing } );
		}
	}

}