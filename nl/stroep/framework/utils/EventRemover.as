package nl.stroep.framework.utils 
{
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	/**
	 * Automatic event remover util. Removes events when displayobject is removed from stage
	 * @author Mark Knol
	 */
	public class EventRemover
	{ 
		private var eventsList:Object = {};
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
		
		public function onRemovedFromStage(e:Event = null):void
        {
            this.removeAllListeners();
        }

		public function removeAllListeners():void
        {
            for (var type:String in eventsList)
            {
                this.removeListenerByType(type);
            }        
        }
		
		public function removeListenerByType(type:String):void
        {
            var events:Array = eventsList[type] as Array;
            
            //Just in case you weren't listening to that event, this if will prevent #1009 errors
            if (events)
            {
                for (var i:int = 0; i < events.length; i++)
                {
                    var eventObject:EventObject = events[i];
                    dispatcher.removeEventListener( type, eventObject.listener, eventObject.useCapture );
                   
                    // trace("Auto removed listener ", type, eventObject.listener, "from", this, dispatcher);
                   
                    eventObject.listener = null;
                    eventObject = null; 
					events.splice(i, 1);
                }
                
                delete eventsList[type];
            }
        }
       
        public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
        {
            if (!eventsList[ type ])
            {
                eventsList[ type ] = [ new EventObject( listener, useCapture ) ];
            }
            else
            {
                eventsList[ type ].push( new EventObject( listener, useCapture ) );
            }
        }
    }
}

final internal class EventObject
{
    public var listener:Function
    public var useCapture:Boolean
   
    public final function EventObject ( listener:Function, useCapture:Boolean = false ):void
    {
        this.listener = listener;
        this.useCapture = useCapture;
    }
}
