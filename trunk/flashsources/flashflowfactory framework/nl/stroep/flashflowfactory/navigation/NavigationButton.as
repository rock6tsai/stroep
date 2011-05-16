package nl.stroep.flashflowfactory.navigation
{
	import flash.display.BlendMode;
	import flash.display.FrameLabel;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import nl.stroep.flashflowfactory.display.EventManagedMovieClip;
	import nl.stroep.flashflowfactory.navigation.events.NavigationButtonEvent;
	import nl.stroep.flashflowfactory.PageFactory;
	/**
	 * Navigation Button class with smart states, grouping and an easy click function
	 * 
	 * Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
	 * @author Mark Knol
	 */
	public class NavigationButton extends EventManagedMovieClip
	{
		private static const OVER:String = "over";
		private static const OUT:String = "out";
		private static const DOWN:String = "down";
		private static const ACTIVE:String = "active";
		
		public var type:String = ButtonTypes.INTERNAL;
		public var group:String;
		public var rollOver:Function;
		public var rollOut:Function;
		
		private var _isActive:Boolean;
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
					_isActive = true;
					
					setEnabled(false);
					
					if (hasActiveLabel)
					{
						gotoAndPlay(ACTIVE);
					}
					else if (hasDownLabel)
					{
						gotoAndPlay(DOWN);
					}
					else if (hasOverLabel)
					{
						gotoAndPlay(OVER);
					}
				}
				else
				{
					_isActive = false;
					
					setEnabled(true);
					
					gotoAndPlay(OUT);
				}
			}
		}
		
		/**
		 * Easy click function, sets path,type and parameters within one function.
		 * @param	path	Based on the type, this refers to the path where you should navigate to when clicked.<br><br>
		 * @param	type	Use ButtonTypes to define what kind of action the action should be handled on click.
							ButtonTypes.EXTERNAL navigates to external page. First parameter could be <br><br>
							ButtonTypes.EVENT dispatches a new event. You should pass the eventType as first parameter. Rest of parameters is based on the event parameters.<br><br>
							ButtonTypes.INTERNAL navigates to page which should be added in PageFactory<br><br>
							ButtonTypes.FUNCTION calls a flash function. Parameters are optional. <br><br>
							ButtonTypes.JAVASCRIPT calls a javascript function with optional parameters;
		 * @param	...parameters Optional parameters. In case of ButtonTypes.JAVASCRIPT, ButtonTypes.FUNCTION and ButtonTypes.Event; you can pass optional (function) parameter here. In case of ButtonTypes.EXTERNAL you could pass a window-target.
		 */
		public function click(path:*, type:String = "internal", ...parameters):void
		{
			this.path = path;
			this.type = type;
			if (parameters) this.parameters = parameters;
		}
		
		/**
		 * Enables or disables current button
		 * @param	value	Required. true = make enabled, false = make disabled
		 */
		public function setEnabled(value:Boolean):void 
		{
			enabled = value;
			
			if (value)
			{
				buttonMode = tabEnabled = mouseEnabled = true;
			}
			else
			{
				buttonMode = tabEnabled = mouseEnabled = false;
			}
		}
		
		private function getLabelsInfo():void
		{
			for (var i:uint = 0; i < currentLabels.length; i++) 
			{
				var label:FrameLabel = currentLabels[i];
				
				switch (label.name) 
				{
					case OUT:
						hasOutLabel = true;
						break;
				
					case OVER:
						hasOverLabel = true;
						break;
				
					case ACTIVE:
						hasActiveLabel = true
						break;
					
					case DOWN:
						hasDownLabel = true; 
						addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
						break;
						
					default:
				}
			}
		}
		
		private function onMouseDown(e:MouseEvent):void 
		{
			gotoAndPlay(DOWN);
		}
		
		private function onButtonClick(e:MouseEvent):void 
		{
			// trace("onButtonClick", this, path, type);
			
			PageFactory.navigateTo(path, type, parameters);
			
			if (group != null) eventcenter.dispatchEvent(new NavigationButtonEvent(NavigationButtonEvent.BUTTON_SELECTED, group, this.ID));
		}
		
		private function onRollOut(e:MouseEvent):void 
		{
			if (!isActive)
			{
				if (hasOutLabel) gotoAndPlay(OUT);
			}
			
			if (rollOut != null) rollOut();
		}
		
		private function onRollOver(e:MouseEvent):void 
		{
			if (!isActive)
			{
				if (hasOverLabel) gotoAndPlay(OVER);
			}
			
			if (rollOver != null) rollOver();
		}
		
		public function get path():* { return _path; }
		
		public function set path(value:*):void 
		{
			_path = value;
		}
		
		public function get isActive():Boolean { return _isActive; }
		
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