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
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}
		
		private function onRemovedFromStage(e:Event):void 
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			
			eventRemover.removeListeners();
			eventcenter.removeListeners(this);
		}

		public override function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
		{
			super.addEventListener(type, listener, useCapture, priority, useWeakReference);
			
			try 
			{ 
				eventRemover.addEventListener(type, listener, useCapture, this); 
			} 
			catch (e:Error) 
			{
				trace("failed to add eventRemover to ", this, type)
			}
		}
		
		public override function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void
		{
			super.removeEventListener(type, listener, useCapture);
			
			try 
			{ 
				eventRemover.removeEventListener(type, listener, useCapture); 
			} 
			catch (e:Error) 
			{
				trace("failed to remove eventRemover to ", this, type)
			}
		}

	}

}
