package nl.stroep.framework.display 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import nl.stroep.framework.utils.EventCenter;
	import nl.stroep.framework.utils.EventRemover;
	/**
	 * Simple event managing MovieClip (with eventcenter) which automatically removes eventlisteners when the sprite is removed from stage. This class should be extended.
	 * @author Mark Knol
	 */
	public class EventManagedMovieClip extends MovieClip
	{
		private var eventRemover:EventRemover;
		protected var eventcenter:EventCenter = EventCenter.getInstance();
		
		public function EventManagedMovieClip() 
		{			
			super();
			
			eventRemover = new EventRemover(this);
			addEventListener(Event.REMOVED_FROM_STAGE, eventRemover.onRemovedFromStage);
		}

		public override function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
		{
			eventRemover.addEventListener(type, listener, useCapture, priority, useWeakReference);			
			super.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}

	}

}
