package nl.stroep.flashflowfactory.transitions.interfaces 
{
	import nl.stroep.flashflowfactory.Page;
	
	/**
	 * ...
	 * @author Mark Knol
	 */
	public interface ITransition 
	{
		function animateIn(page:Page, speed:Number, easing:Function):void
		function animateOut(page:Page, speed:Number, easing:Function):void
	}
	
}