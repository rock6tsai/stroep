package nl.stroep.flashflowfactory.transitions.interfaces 
{
	import nl.stroep.flashflowfactory.Page;
	
	/**
	 * Transition Interface
	 * 
	 * Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
	 * @author Mark Knol
	 */
	public interface ITransition 
	{
		function animateIn(page:Page, speed:Number, easing:Function):void
		function animateOut(page:Page, speed:Number, easing:Function):void
	}
	
}