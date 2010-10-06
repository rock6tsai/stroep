package nl.stroep.framework.utils
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	/**
	 * Global eventdispatching singleton class 
	 * @author Mark Knol
	 */
	public class EventCenter extends EventDispatcher implements IEventDispatcher
	{
		private var eventsList:Object = {};
		
		private static var instance:EventCenter;
		private static var allowInstantiation:Boolean = false;
		
		private var dispatcher:EventDispatcher;
		
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
		}
		
		public function addListener(scope:Object, type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void 
		{
			super.addEventListener(type, listener, useCapture, priority, useWeakReference);
			
			trace("scope addListener:",scope)
			if (!eventsList[ scope ])
			{
				eventsList[ scope ] = [ new EventObject( type, listener, useCapture ) ];
			}
			else
			{
				eventsList[ scope ].push( new EventObject( type, listener, useCapture ) );
			}
		}
		
		public function removeListeners(scope:Object):void 
		{
			var events:Array = eventsList[scope] as Array;
			
			trace("scope onRemove:", scope)
			if (events && events.length > 0)
			{
				for (var i:int = 0; i < events.length; i++) 
				{
					var eventObject:EventObject = events[i];
					removeEventListener( eventObject.type, eventObject.listener, eventObject.useCapture );
					
					trace("Auto removed listener ", eventObject.type, eventObject.listener, "from", scope);
					
					eventObject.listener = null;
					eventObject = null;
					
					if (events.length == 0) 
						delete eventsList[scope];
				}
			}
			else
			{
				trace("no events found?")
			}
		}
		
	}
	
}

final internal class EventObject
{
	public var type:String
	public var listener:Function
	public var useCapture:Boolean
	
	public final function EventObject ( type:String, listener:Function, useCapture:Boolean ):void
	{
		this.type = type;
		this.listener = listener;
		this.useCapture = useCapture;
	}
}