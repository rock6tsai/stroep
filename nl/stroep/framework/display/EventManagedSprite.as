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
		protected var _eventRemover:EventRemover;
		
		/// global event center
		protected var eventcenter:EventCenter = EventCenter.getInstance();
		
		public function EventManagedSprite() 
		{			
			super();
			
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}
		
		private function onRemovedFromStage(e:Event):void 
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			
			eventRemover.destroy();
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
		
		public function get eventRemover():EventRemover 
		{ 
			if ( !_eventRemover ) _eventRemover = new EventRemover(this);
			return _eventRemover; 
		}

	}

}
