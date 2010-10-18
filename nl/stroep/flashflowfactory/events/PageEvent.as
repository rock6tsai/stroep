package nl.stroep.flashflowfactory.events 
{
	import flash.events.Event;
	
	/**
	 * Page/PageFactory internal Event
	 * 
	 * Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
	 * @author Mark Knol
	 */
	public class PageEvent extends Event 
	{		
		public static const NEW_PAGE:String = "new_page";
		
		public static const SHOW_COMPLETE:String = "show_complete";
		public static const SHOW_START:String = "show_start";
		public static const HIDE_COMPLETE:String = "hide_complete";
		public static const HIDE_START:String = "hide_start";
		
		private var _pageName:String;
		
		public function PageEvent(type:String, pageName:String,  bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
			this._pageName = pageName;
		} 
		
		public override function clone():Event 
		{ 
			return new PageEvent(type, _pageName, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("PageEvent", "type", "pageName", "bubbles", "cancelable", "eventPhase"); 
		}
		
		public function get pageName():String { return _pageName; }
		
	}
	
}