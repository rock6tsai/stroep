package nl.stroep.framework.display 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import nl.stroep.framework.utils.EventCenter;
	import nl.stroep.framework.utils.EventRemover;
	/**
	 * Simple event managing MovieClip (with eventcenter) which automatically removes eventlisteners when the sprite is removed from stage. This class should be extended.
	 * @author Mark Knol
	 */
	public class EventManagedSprite extends Sprite
	{
		protected var eventRemover:EventRemover;
		protected var eventcenter:EventCenter = EventCenter.getInstance();
		
		public function EventManagedSprite() 
		{			
			super();
			
			eventRemover = new EventRemover(this);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}
		
		private function onRemovedFromStage(e:Event):void 
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			
			eventRemover.onRemovedFromStage(e);
			eventcenter.removeListeners(this);
		}

		public override function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
		{
			super.addEventListener(type, listener, useCapture, priority, useWeakReference);
			try { eventRemover.addEventListener(type, listener, useCapture, priority, useWeakReference); } catch (e:*) {
				
				trace("failed to add eventRemover to ", this, type)
			}
		}

	}

}
