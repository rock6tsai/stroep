package nl.stroep.flashflowfactory.utils 
{
	import flash.events.IEventDispatcher;
	/**
	 * Automatic event remover util. Removes events when displayobject is removed from stage
	 * 
	 * Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
	 * @author Mark Knol
	 */
	public class EventRemover
	{ 
		private var eventsListLength:int;
		private var _eventsList:Array;
		private var dispatcher:IEventDispatcher;
		private var _length:uint;

		public function EventRemover(dispatcher:IEventDispatcher) 
		{
			if (dispatcher)
            {
				this.dispatcher = dispatcher;
			}
			else
            {
                throw new Error("ERROR: Cannot pass in a null dispatcher into new EventRemover()'");
            }
		}

		/// Removes all listeners
		public function removeListeners():void
        {
            eventsListLength = eventsList.length;
		   
			for ( var i:int = eventsListLength - 1; i >= 0; i -- )
			{
				var eventObject:EventObject = eventsList[i];
				
				//trace( "automaticly removed listener (all) ", eventObject.type, "from", dispatcher);
				eventObject = null;
                eventsList.splice( i, 1);
            }  
        }
		
		/// Removes Listeners, clears references
		public function destroy():void
		{
			removeListeners();
			_eventsList = [];
			_eventsList = null;
			dispatcher = null;
		}
		
		/// Remove all listeners with specific type
		public function removeListenersByType(type:String):void
        {
            eventsListLength = eventsList.length;
			
			for ( var i:int = eventsListLength - 1; i >= 0; i -- )
			{
				var eventObject:EventObject = eventsList[i];
				
				if (eventObject.type == type)
				{
					//trace( "automaticly removed listener (by type)", eventObject.type, "from", dispatcher);
					eventObject = null;
					eventsList.splice( i, 1);
				}
            }
        }
		
		/// Remove all listeners from specific scope
		public function removeListenersByScope(scope:*):void
        {
			if (scope)
			{
				eventsListLength = eventsList.length;
				
				for ( var i:int = eventsListLength - 1; i >= 0; i -- )
				{
					var eventObject:EventObject = eventsList[i];
					
					if (eventObject.scope == scope)
					{
						//trace( "automaticly removed listener (by scope)", eventObject.type, "from", dispatcher);
						eventObject = null;
						eventsList.splice( i, 1);
					}
				}
			}
        }
		
		/// Store listener in EventRemover
        public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, scope:* = null):void
        {
            eventsList.push( new EventObject( type, listener, useCapture, scope ) );
        }
		
		/// Remove specific listener
        public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void
        {
			eventsListLength = eventsList.length;
			
			for ( var i:int = eventsListLength - 1; i >= 0; i -- )
			{
				var eventObject:EventObject = eventsList[i];
				
				if (eventObject.type == type && eventObject.listener == eventObject.listener && eventObject.useCapture == useCapture)
				{
					//trace( "manually removed listener", eventObject.type, "from", dispatcher);
					eventObject = null;
					eventsList.splice( i, 1);
				}
			}
        }
		
		protected function get eventsList():Array { return _eventsList ||= []; }
		
		protected function set eventsList(value:Array):void 
		{
			_eventsList = value;
		}
		
		public function get length():uint { return _eventsList._length; }
    }
}

final internal class EventObject
{
    public var type:String;
    public var listener:Function;
    public var useCapture:Boolean;
    public var scope:*;
   
    public final function EventObject ( type:String, listener:Function, useCapture:Boolean = false, scope:* = null ):void
    {
        this.type = type;
        this.listener = listener;
        this.useCapture = useCapture;
        this.scope = scope;
    }
}
