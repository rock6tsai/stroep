package nl.stroep.flashflowfactory.utils
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	/**
	 * Global eventdispatching singleton class 
	 * 
	 * Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
	 * @author Mark Knol
	 */
	public class EventCenter 
	{
		private static var instance:EventCenter;
		private static var allowInstantiation:Boolean = false;
		
		private var dispatcher:EventDispatcher;
		private var _eventRemover:EventRemover;
		
		public static function getInstance():EventCenter
		{
			if ( instance == null )
			{
				allowInstantiation = true;
				
				instance = new EventCenter();
				
				allowInstantiation = false;
			}
			return instance;
		}
		
		public function EventCenter()
		{
			if ( !allowInstantiation )
			{
				throw new Error("Error: Instantiation failed: Use EventCenter.getInstance() instead of new.");
			}
			else
			{
				dispatcher = new EventDispatcher();
			}
		}
		
		public function dispatchEvent( event:Event ):Boolean
		{
			//trace("eventcenter dispatched ", event.type);
			if (dispatcher.hasEventListener(event.type) || event.bubbles) 
			{
				return dispatcher.dispatchEvent(event);
			}
			return true;
		}
		
		/// Add global listener
		public function addListener(scope:*, type:String, listener:Function, useCapture:Boolean = false):void
		{
			dispatcher.addEventListener(type, listener, useCapture);
			
			try 
			{ 
				eventRemover.addEventListener(type, listener, useCapture, scope); 
			} 
			catch (e:Error) 
			{
				trace("failed to add eventRemover to ", this, type)
			}
		}
		
		/// Manually remove global listener
		public function removeListener(type:String, listener:Function, useCapture:Boolean = false):void
		{
			dispatcher.removeEventListener(type, listener, useCapture);
			
			try 
			{ 
				eventRemover.removeEventListener(type, listener, useCapture); 
			} 
			catch (e:Error) 
			{
				trace("failed to remove eventRemover to ", this, type)
			}
		}
		
		/// Remove listeners from scope
		public function removeListeners(scope:*):void 
		{
			if (scope) eventRemover.removeListenersByScope(scope);
		}
		
		public function get eventRemover():EventRemover 
		{ 
			if ( !_eventRemover ) _eventRemover = new EventRemover(dispatcher);
			return _eventRemover; 
		}
	}
}
