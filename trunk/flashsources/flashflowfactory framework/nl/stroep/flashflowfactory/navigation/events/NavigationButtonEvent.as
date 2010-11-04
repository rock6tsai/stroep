package nl.stroep.flashflowfactory.navigation.events
{
	import flash.events.Event;
	
	/**
	 * NavigationButton internal Event
	 * 
	 * Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
	 * @author Mark Knol
	 */
	public class NavigationButtonEvent extends Event 
	{
		public static const BUTTON_SELECTED:String = "BUTTON_SELECTED";
		
		private var _group:String;
		private var _id:int;
		
		public function NavigationButtonEvent(type:String, group:String, id:int, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
			_group = group;
			_id = id;
		} 
		
		public override function clone():Event 
		{ 
			return new NavigationButtonEvent(type, group, id, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("NavigationButtonEvent", "type", "group", "id", "bubbles", "cancelable", "eventPhase"); 
		}
		
		public function get group():String { return _group }
		public function get id():int { return _id }
		
	}	
}