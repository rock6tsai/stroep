package nl.stroep.framework.transitions.interfaces 
{
	import nl.stroep.framework.Page;
	
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