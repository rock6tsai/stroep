package nl.stroep.flashflowfactory.transitions 
{
	import com.greensock.plugins.AutoAlphaPlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.greensock.TweenLite;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import nl.stroep.flashflowfactory.Page;
	import nl.stroep.flashflowfactory.transitions.interfaces.ITransition;
	/**
	 * Randomly moves children from page away. Can be intensive when having lots of them.
	 * 
	 * Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
	 * @author Mark Knol
	 */
	public class ExplosionTransition implements ITransition
	{
		private var impact:int;
		private var levels:int;
		
		public function ExplosionTransition(impact:int = 200, levels:int=1) 
		{
			this.impact = impact;
			this.levels = levels;
			
			TweenPlugin.activate([AutoAlphaPlugin]);
		}
		
		private function rnd(val:Number = 1):Number
		{
			return -val * 0.5 + Math.random() * val;
		}
		
		/* INTERFACE nl.stroep.flashflowfactory.transitions.interfaces.ITransition */
		
		public function animateIn(page:Page, speed:Number, easing:Function):void
		{
			moveChildrenIn(page, 1, levels, speed, easing);
			TweenLite.delayedCall(speed, page.onShowComplete);
		}
		
		private function moveChildrenIn(clip:DisplayObjectContainer, level:int, maxLevels:int, speed:Number, easing:Function):void
		{
			if ( level <= maxLevels )
			{
				for (var i:int = 0; i < clip.numChildren; i++) 
				{
					var child:DisplayObject = clip.getChildAt(i);
					if (child is DisplayObject)
					{
						var scale:Number = 1 + rnd(1);
						TweenLite.from( child, speed/level, { autoAlpha:0, scaleX:scale, scaleY:scale, x:rnd(impact / level).toString(), y:rnd(impact / level).toString(), rotation:rnd(180).toString(), ease:easing } );
						
						if (child is DisplayObjectContainer && DisplayObjectContainer(child).numChildren > 0) 
							moveChildrenIn(DisplayObjectContainer(child), level + 1, levels, speed, easing);
					}
				}
				
			}
		}
		
		public function animateOut(page:Page, speed:Number, easing:Function):void
		{
			moveChildrenOut(page, 1, levels, speed, easing);
			TweenLite.delayedCall(speed, page.onHideComplete);
		}
		
		private function moveChildrenOut(clip:DisplayObjectContainer, level:int, maxLevels:int, speed:Number, easing:Function):void
		{
			if ( level <= maxLevels )
			{
				for (var i:int = 0; i < clip.numChildren; i++) 
				{
					var child:DisplayObject = clip.getChildAt(i);
					if (child is DisplayObject)
					{
						var scale:Number = 1 + rnd(1);
						TweenLite.to( child, speed/level, { autoAlpha:0, scaleX:scale, scaleY:scale, x:rnd(impact / level).toString(), y:rnd(impact / level).toString(), rotation:rnd(180).toString(), ease:easing } );
						
						if (child is DisplayObjectContainer && DisplayObjectContainer(child).numChildren > 0) 
							moveChildrenIn(DisplayObjectContainer(child), level + 1, levels, speed, easing);
					}
				}
				
			}
		}
	}

}