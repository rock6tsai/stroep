package nl.stroep.flashflowfactory.utils 
{
	import flash.events.IEventDispatcher;
	/**
	 * Automatic event remover util. Removes events when displayobject is removed from stage
	 * @author Mark Knol
	 */
	public class EventRemover
	{ 
		private var eventsListLength:int;
		private var eventsList:Array = [];
		private var dispatcher:IEventDispatcher;

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
			eventsList = [];
			eventsList = null;
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
            eventsListLength = eventsList.length;
			
			for ( var i:int = eventsListLength - 1; i >= 0; i -- )
			{
				var eventObject:EventObject = eventsList[i];
				
				if (eventObject.scope == scope)
				{
					//trace( "automaticly removed listener (by scope)", eventObject.type, "from", dispatcher);
					eventObject = null;
					eventsList.splice( i, 1);
					eventsListLength--
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
