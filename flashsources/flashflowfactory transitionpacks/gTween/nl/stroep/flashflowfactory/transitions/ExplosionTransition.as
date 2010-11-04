package nl.stroep.flashflowfactory.transitions 
{
	import com.gskinner.motion.GTween;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
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
		private var timeoutID:uint;
		
		public function ExplosionTransition(impact:int = 200, levels:int=1) 
		{
			this.impact = impact;
			this.levels = levels;
		}
		
		private function rnd(val:Number = 1):Number
		{
			return -val * 0.5 + Math.random() * val;
		}
		
		/* INTERFACE nl.stroep.flashflowfactory.transitions.interfaces.ITransition */
		
		public function animateIn(page:Page, speed:Number, easing:Function):void
		{
			moveChildrenIn(page, 1, levels, speed, easing);
			timeoutID = setTimeout(onAnimateInComplete, speed, page);
		}
		
		private function onAnimateInComplete(page:Page):void
		{
			clearTimeout(timeoutID);
			page.onShowComplete();
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
						
						var origScaleX:Number = child.scaleX;
						var origScaleY:Number = child.scaleY;
						var origRotation:Number = child.rotation;
						var origX:Number = child.x;
						var origY:Number = child.y;
						var origAlpha:Number = child.alpha;
						
						child.alpha = 0;
						child.scaleX = scale;
						child.scaleY = scale;
						child.rotation = child.rotation + rnd(180);
						child.x = child.x + rnd(impact / level);
						child.y = child.y + rnd(impact / level);
						
						var tween:GTween = new GTween(child, speed / level, { alpha:origAlpha, scaleX:origScaleX, scaleY:origScaleY, x:origX, y:origY, rotation:origRotation }, { ease: easing } );
						
						if (child is DisplayObjectContainer && DisplayObjectContainer(child).numChildren > 0) 
							moveChildrenIn(DisplayObjectContainer(child), level + 1, levels, speed, easing);
					}
				}
				
			}
		}
		
		public function animateOut(page:Page, speed:Number, easing:Function):void
		{
			moveChildrenOut(page, 1, levels, speed, easing);
			timeoutID = setTimeout(onAnimateOutComplete, speed, page);
		}
		
		private function onAnimateOutComplete(page:Page):void
		{
			clearTimeout(timeoutID);
			page.onHideComplete();
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
						
						var tween:GTween = new GTween(child, speed / level, { alpha:0, scaleX:scale, scaleY:scale, x:child.x + rnd(impact / level), y:child.y + rnd(impact / level), rotation:child.rotation + rnd(180) }, { ease: easing } );
						
						if (child is DisplayObjectContainer && DisplayObjectContainer(child).numChildren > 0) 
							moveChildrenIn(DisplayObjectContainer(child), level + 1, levels, speed, easing);
					}
				}
				
			}
		}
	}

}