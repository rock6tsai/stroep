package nl.stroep.flashflowfactory.navigation
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	/**
	 * Custom button class - Virtual proxy 
	 * 
	 * Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
	 * @author Mark Knol
	 */
	public class NavigationProxyButton extends Sprite
	{
		public var button:NavigationButton;
		public var label:TextField;
		
		private var _text:String;
		private var _type:String;
		private var _window:String;
		private var _parameters:*;
		private var _path:*;
		private var _group:String;
		
		public function NavigationProxyButton() 
		{
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			label.mouseEnabled = false;
		}
		
		public function get text():String { return _text; }
		
		public function set text(value:String):void 
		{
			_text = label.text = value.toUpperCase();
		}
		
		public function get type():String { return _type; }
		
		public function set type(value:String):void 
		{
			_type = button.type = value;
		}
		
		public function get parameters():* { return _parameters; }
		
		public function set parameters(value:*):void 
		{
			_parameters = button.parameters = value;
		}
		
		override public function get width():Number { return button.width; }
		
		override public function set width(value:Number):void 
		{
			//super.width = value;
			button.width = label.width = value;
		}
		
		public function get path():* { return _path; }
		
		public function set path(value:*):void 
		{
			_path = button.path = value;
		}
		
		public function get group():String { return _group; }
		
		public function set group(value:String):void 
		{
			_group = button.group = value;
		}
		
		public function click(path:*, type:String = "internal", ...parameters):void
		{
			this.path = path;
			this.type = type;
			this.parameters = parameters;
		}
	}

}