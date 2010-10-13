package nl.stroep.flashflowfactory.navigation
{
	import com.greensock.easing.Strong;
	import com.greensock.motionPaths.PathFollower;
	import com.greensock.TweenLite;
	import flash.display.BlendMode;
	import flash.display.FrameLabel;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.geom.Rectangle;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import nl.stroep.flashflowfactory.display.EventManagedMovieClip;
	import nl.stroep.flashflowfactory.navigation.events.NavigationButtonEvent;
	import nl.stroep.flashflowfactory.PageFactory;
	/**
	 * ...
	 * @author Mark Knol
	 */
	public class NavigationButton extends EventManagedMovieClip
	{
		//private var eventcenter:EventCenter = EventCenter.getInstance();
		
		private static const OVER:String = "over";
		private static const OUT:String = "out";
		private static const DOWN:String = "down";
		private static const ACTIVE:String = "active";
		
		public var type:String = ButtonTypes.INTERNAL;
		public var group:String;
		
		private var isActive:Boolean;
		private var hasOverLabel:Boolean;
		private var hasOutLabel:Boolean;	
		private var hasActiveLabel:Boolean;
		private var hasDownLabel:Boolean;
		
		private static const enableFakeHitarea:Boolean = false;
		
		public var parameters:*;
		private var _path:*;
		
		private static var index:int = 0;
		private const ID:int = index++ // unique id
		
		function NavigationButton()
		{
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			stop();
			
			this.blendMode = BlendMode.LAYER;
			
			addListeners();
			
			setEnabled(true);
			
			getLabelsInfo();
			
			if (enableFakeHitarea) createFakeHitarea();
		}
		
		private function addListeners():void
		{
			addEventListener(MouseEvent.CLICK, onButtonClick);
			addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			addEventListener(MouseEvent.ROLL_OUT, onRollOut);
			
			eventcenter.addListener(this, NavigationButtonEvent.BUTTON_SELECTED, onButtonSelected);
		}
		
		private function onRemovedFromStage(e:Event):void 
		{
			path = null;
			parameters = null;
		}
		
		private function onButtonSelected(e:NavigationButtonEvent):void 
		{
			if (e.group == group)
			{
				if (e.id == ID)
				{
					isActive = true;
					
					if (hasActiveLabel)
					{
						gotoAndStop(ACTIVE);
					}
					else if (hasDownLabel)
					{
						gotoAndStop(DOWN);
					}
					else if (hasOverLabel)
					{
						gotoAndStop(OVER);
					}
				}
				else
				{
					isActive = false;
					gotoAndStop(OUT);
				}
			}
		}
		
		public function click(path:*, type:String = "internal", ...parameters):void
		{
			this.path = path;
			this.type = type;
			if (parameters) this.parameters = parameters;
		}
		
		public function setEnabled(value:Boolean = false):void 
		{
			TweenLite.killTweensOf(this);
			enabled = value;
			
			if (value)
			{
				alpha = 1;
				buttonMode = tabEnabled = mouseEnabled = true;
			}
			else
			{
				gotoAndStop("OUT");
				alpha = 0.5;
				
				buttonMode = tabEnabled = mouseEnabled = false;
			}
		}
		
		private function getLabelsInfo():void
		{
			for (var i:uint = 0; i < currentLabels.length; i++) 
			{
				var label:FrameLabel = currentLabels[i];
				if (label.name == OUT) hasOutLabel = true;
				if (label.name == OVER) hasOverLabel = true;
				if (label.name == ACTIVE) hasActiveLabel = true;
				if (label.name == DOWN) { hasDownLabel = true; addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown); }
			}
		}
		
		private function onMouseDown(e:MouseEvent):void 
		{
			gotoAndPlay(DOWN);
		}
		
		private function onButtonClick(e:MouseEvent):void 
		{
			// trace("onButtonClick", this, path, type);
			
			if (!path) { trace("Error: Property NavigationButton path undefined"); return }
			
			switch (type) 
			{
				case ButtonTypes.EXTERNAL:
					if (parameters)
					{
						navigateToURL( new URLRequest( path.toString() ), parameters );
					}
					else
					{
						navigateToURL( new URLRequest( path.toString() ), "_blank" );
					}
					break;
			
				case ButtonTypes.INTERNAL:
					PageFactory.gotoPage( path.toString() );
					break;
					
				case ButtonTypes.EVENT:	
					switch (parameters.length)
					{
						case 0:  trace("Error: missing event type"); break;
						case 1:  eventcenter.dispatchEvent( new path( parameters[0] )); break;
						case 2:  eventcenter.dispatchEvent( new path( parameters[0], parameters[1] )); break;
						case 3:  eventcenter.dispatchEvent( new path( parameters[0], parameters[1], parameters[2] )); break;
						case 4:  eventcenter.dispatchEvent( new path( parameters[0], parameters[1], parameters[2], parameters[3] )); break;
						case 5:  eventcenter.dispatchEvent( new path( parameters[0], parameters[1], parameters[2], parameters[3], parameters[4] )); break;
						default: trace("Error: too much arguments ")
					}
					break;
				
				case ButtonTypes.FUNCTION:	
					if (parameters)
					{
						path( parameters );
					}
					else
					{
						path();
					}
					break;
					
				case ButtonTypes.JAVASCRIPT:					
					if (ExternalInterface.available) ExternalInterface.call(path, (parameters) ? parameters : null);
					break;	
					
				default:
					trace("unknown type")
			}
			
			if (group != null) eventcenter.dispatchEvent(new NavigationButtonEvent(NavigationButtonEvent.BUTTON_SELECTED, group, this.ID));
		}
		
		private function onRollOut(e:MouseEvent):void 
		{
			if (!isActive)
			{
				if (hasOutLabel) gotoAndPlay(OUT);
				//TweenLite.to(this, 0.2, { alpha: 1, colorTransform: { exposure:1 }, ease: Strong.easeOut } );
			}
		}
		
		private function onRollOver(e:MouseEvent):void 
		{
			if (!isActive)
			{
				if (hasOverLabel) gotoAndPlay(OVER);
				//TweenLite.to(this, 0.3, { alpha: 1, colorTransform: { exposure:1.05 }, ease: Strong.easeIn } );
			}
		}
		
		public function get path():* { return _path; }
		
		public function set path(value:*):void 
		{
			_path = value;
		}
		
		private function createFakeHitarea():void
		{
			var rect:Rectangle = getRect(this);
			
			var area:Sprite = new Sprite();
			area.graphics.beginFill(0, 0);
			area.graphics.drawRect(rect.x + x, rect.y + y, rect.width, rect.height);
			area.mouseEnabled = false;
			
			parent.addChild(area);
			
			hitArea = area;
		}
		
	}

}