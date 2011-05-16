package nl.stroep.flashflowfactory
{
	import flash.display.BlendMode;
	import flash.events.Event;
	import nl.stroep.flashflowfactory.display.EventManagedMovieClip;
	import nl.stroep.flashflowfactory.enum.Alignment;
	import nl.stroep.flashflowfactory.events.PageEvent;
	/**
	 * Standard page class. This class should be extended.
	 * 
	 * Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
	 * @author Mark Knol
	 */
	public class Page extends EventManagedMovieClip
	{
		/**
		 * When enabled, the `show()` function is called onAddedToStage, otherwise you can call `show()` yourself (Useful when you want to load something before showing the page). Default `true`
		 */
		public var autoShow:Boolean = true;
		/** 
		 * Internal page name, auto filled by the PageFactory. The pageName reflects the deeplink url, which is set using SWFAddress. There is no need to modify this value.
		 */
		 public var pageName:String;
		/** 
		 * Page title, auto filled by the PageFactory. The pageTitle reflects the browser title, which is set using SWFAddress. There is no need to modify this value.
		 */
		public var pageTitle:String;
		/** 
		 * Settings from the page. auto filled by the PageFactory. All values from these settings can be overwritten. 
		 */
		public var settings:PageSettings;
		/**
		 * When enabled, the `show()` function is called onAddedToStage, otherwise you can call `show()` yourself (Useful when you want to load something before showing the page). Default `true`
		 */
		protected var isFrozen:Boolean = true;
		
		public function Page():void
		{
			super();
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}
		
		/**
		 * Overridable method to detect if page is added from stage
		 * @param	event	Callback Event
		 */
		protected function onAddedToStage(event:Event):void 
		{
			if (autoShow) show();
		}
		
		/**
		 * Overridable method to detect if page is removed from stage
		 * @param	event	Callback Event	
		 */
		protected function onRemovedFromStage(event:Event):void 
		{
			settings.easingInFunc = null;
			settings.easingOutFunc = null;
			settings.transition = null;
			settings = null;
		}
		
		/**
		 * Overridable method to detect if page is ready (ready means after completing transition-in animation)
		 */
		protected function onPageReady():void 
		{
			
		}
		
		/**
		 * Starts transition-in animation and dispatches global event PageEvent.SHOW_START. Cannot be overridden. Listen to PageEvent.SHOW_START instead.
		 */
		final public function show():void
		{
			if ( settings && settings.transitionInSpeed && settings.transitionInSpeed > 0 )
			{
				Alignment.setAlignment( this, settings.pageAlignment, settings.clipAlignment );
				
				settings.transition.animateIn(this, settings.transitionInSpeed, settings.easingInFunc);
				
				eventcenter.dispatchEvent( new PageEvent( PageEvent.SHOW_START, pageName ) );
				
				freeze();
			}
			else
			{
				onShowComplete();
			}
		}
		
		/**
		 * Starts transition-out animation and dispatches global event PageEvent.HIDE_START. Cannot be overridden. Listen to PageEvent.HIDE_START instead.
		 */
		final public function hide():void
		{			
			if ( settings && settings.transitionOutSpeed && settings.transitionOutSpeed > 0 )
			{
				settings.transition.animateOut(this, settings.transitionOutSpeed, settings.easingOutFunc);
				
				eventcenter.dispatchEvent( new PageEvent( PageEvent.HIDE_START, pageName ) );
				
				freeze();
			}
			else
			{
				onHideComplete();
			}
		}
		
		/**
		 * Dispatches global event PageEvent.SHOW_COMPLETE after completing transition-in animation. Cannot be overridden. Listen to PageEvent.SHOW_COMPLETE instead.
		 */
		final public function onShowComplete(e:* = null):void
		{			
			eventcenter.dispatchEvent( new PageEvent( PageEvent.SHOW_COMPLETE, pageName ) );
			
			onPageReady();
			
			unfreeze();
		}
		
		/**
		 * Dispatches global event PageEvent.HIDE_COMPLETE after completing transition-out animation. Cannot be overridden. Listen to PageEvent.HIDE_COMPLETE instead.
		 */
		final public function onHideComplete(e:* = null):void
		{
			eventcenter.dispatchEvent( new PageEvent( PageEvent.HIDE_COMPLETE, pageName ) );
		}
		
		/**
		 * Disable page interactions
		 */
		protected function freeze():void   
		{
			tabEnabled = 
			mouseChildren = 
			mouseEnabled = false;
			
			isFrozen = true;
		}
		
		/**
		 * Enable page interactions
		 */
		protected function unfreeze():void   
		{
			tabEnabled = 
			mouseChildren = 
			mouseEnabled = true;
			
			isFrozen = false;
		}
	}
	
}