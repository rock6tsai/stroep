package nl.stroep.flashflowfactory
{
	import com.greensock.easing.*;
	import flash.display.BlendMode;
	import flash.events.Event;
	import nl.stroep.flashflowfactory.display.EventManagedSprite;
	import nl.stroep.flashflowfactory.enum.Alignment;
	import nl.stroep.flashflowfactory.events.PageEvent;
	/**
	 * Standard page class. This class should be extended.
	 * @author Mark Knol
	 */
	public class Page extends EventManagedSprite
	{		
		public var pageName:String;
		public var pageTitle:String;
		public var settings:PageSettings = new PageSettings();
		
		public function Page():void
		{
			super();
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}
		
		/// Overridable method to detect if page is added from stage
		protected function onAddedToStage(e:Event):void 
		{
			freeze();
			
			/// Default blendmode
			this.blendMode = BlendMode.LAYER;
		}
		
		/// Overridable method to detect if page is removed from stage
		protected function onRemovedFromStage(e:Event):void 
		{
			settings.easingInFunc = null;
			settings.easingOutFunc = null;
			settings.transition = null;
			settings = null;
		}
		
		/// Overridable method to detect if page is ready (ready means after completing transition-in animation)
		protected function onPageReady():void 
		{
			
		}
		
		/// Starts transition-in animation and dispatches global event PageEvent.SHOW_START. Cannot be overridden. Listen to PageEvent.SHOW_START instead.
		final public function show():void
		{
			Alignment.setAlignment( this, settings.pageAlignment, settings.clipAlignment );
			
			settings.transition.animateIn(this, settings.transitionInSpeed, settings.easingInFunc);
			
			eventcenter.dispatchEvent( new PageEvent( PageEvent.SHOW_START, pageName ) );
		}
		
		/// Starts transition-out animation and dispatches global event PageEvent.HIDE_START. Cannot be overridden. Listen to PageEvent.HIDE_START instead.
		final public function hide():void
		{			
			settings.transition.animateOut(this, settings.transitionOutSpeed, settings.easingOutFunc);
			
			eventcenter.dispatchEvent( new PageEvent( PageEvent.HIDE_START, pageName ) );
			
			freeze();
		}
		
		/// Dispatches global event PageEvent.SHOW_COMPLETE after completing transition-in animation. Cannot be overridden. Listen to PageEvent.SHOW_COMPLETE instead.
		final public function onShowComplete():void
		{			
			eventcenter.dispatchEvent( new PageEvent( PageEvent.SHOW_COMPLETE, pageName ) );
			
			onPageReady();
			
			unfreeze();
		}
		
		/// Dispatches global event PageEvent.HIDE_COMPLETE after completing transition-out animation. Cannot be overridden. Listen to PageEvent.HIDE_COMPLETE instead.
		final public function onHideComplete():void
		{
			eventcenter.dispatchEvent( new PageEvent( PageEvent.HIDE_COMPLETE, pageName ) );
		}
		
		/// Disable page interactions
		protected function freeze():void   
		{
			tabEnabled = false;
			mouseChildren = false;
			mouseEnabled = false;
		}
		
		/// Enable page interactions
		protected function unfreeze():void   
		{
			tabEnabled = true;
			mouseChildren = true;
			mouseEnabled = true;
		}
	}
	
}