package nl.stroep.flashflowfactory.display 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import nl.stroep.flashflowfactory.utils.EventCenter;
	import nl.stroep.flashflowfactory.utils.EventRemover;
	/**
	 * Simple event managing MovieClip (with eventcenter) which automatically removes eventlisteners when the sprite is removed from stage. This class should be extended.
	 * 
	 * Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
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
			try 
			{ 
				eventRemover.addEventListener(type, listener, useCapture, this); 
			} 
			catch (e:Error) 
			{
				trace("failed to add eventRemover to ", this, type);
			}
			finally
			{
				super.addEventListener(type, listener, useCapture, priority, useWeakReference);
			}
		}
		
		public override function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void
		{
			try 
			{ 
				eventRemover.removeEventListener(type, listener, useCapture); 
			} 
			catch (e:Error) 
			{
				trace("failed to remove eventRemover to ", this, type);
			}
			finally
			{
				super.removeEventListener(type, listener, useCapture);
			}
		}
		
		public function get eventRemover():EventRemover 
		{ 
			return _eventRemover ||= new EventRemover(this); 
		}

	}

}
