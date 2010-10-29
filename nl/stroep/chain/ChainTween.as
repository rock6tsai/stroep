package nl.stroep.chain 
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.utils.clearInterval;
	import flash.utils.clearTimeout;
	import flash.utils.describeType;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	import flash.utils.setInterval;
	import flash.utils.setTimeout;
	
	/**
	 * Chain tween
	 * @author Mark Knol
	 */
	public class ChainTween
	{
		public static var UPDATE_INTERVAL:uint = 24;
		protected var _easeFunc:Function = Easing.quartOut;
		
		protected var _duration:Number = 0;
		protected var _target:DisplayObject;
		protected var _properties:Object;
		protected var _startTime:int = 0;
		
		protected var _timeoutID:uint = 0;
		
		protected var _propertiesList:Vector.<ChainTweenProperty>;
		protected var _reversed:Boolean = false;
		protected var _isPlaying:Boolean = true;
		
		public function ChainTween(target:DisplayObject = null, properties:Object = null, duration:Number = 0, easing:Function = null)
		{
			this._target = target;			
			this._properties = properties;			
			this._duration = duration;
			
			if (easing != null)
			{
				_easeFunc = easing;
			}
		}
		
		public function start(reversed:Boolean = false):void
		{			
			this._reversed = reversed;
			
			if (_duration > 0)
			{
				_startTime = getTimer();
				collectProperties();				
				_timeoutID = setInterval(update, UPDATE_INTERVAL);
			}
			else
			{
				applyAll();
			}
		}
		
		protected function collectProperties():void
		{
			var i:int = 0;
			var name:Object;
			var property:ChainTweenProperty;
			
			if ( _propertiesList == null || !_propertiesList )
			{
				_propertiesList = new Vector.<ChainTweenProperty>();
				
				for ( name in _properties )
				{ 
					property = new ChainTweenProperty( String(name), _target[name], _properties[name] );				
					_propertiesList[i] = property;
					
					i++
				}
			}
		}
		
		protected function update():void 
		{	
			var total:uint = _propertiesList.length;
			
			if (total > 0)
			{
				var currentTime:int = getTimer();
				var position:Number = (currentTime - _startTime) / _duration;
				var property:ChainTweenProperty;
				
				var i:int = 0;
				
				for (; i < total; ++i) 
				{
					property = _propertiesList[i];
					
					if (position >= 1)
					{
						// on tween complete
						if (!_reversed)
						{
							_target[property.name] = property.endValue;
						}
						else
						{
							_target[property.name] = property.startValue;
						}						
						executeOnComplete();
					}
					else
					{
						// tweening calculation here
						if (!_reversed)
						{
							_target[property.name] = property.startValue + ((property.endValue - property.startValue) * _easeFunc(position));
						}
						else
						{
							_target[property.name] = property.startValue + ((property.endValue - property.startValue) * _easeFunc(1 - position));
						}
					}
				}				
			}
		}
		
		protected function applyAll():void
		{
			for ( var obj:Object in _properties)
			{				
				_target[obj] = _properties[obj];
			}
		}
		
		protected function executeOnComplete():void
		{
			clearInterval(_timeoutID);
		}
		
		/// dispose object
		public function destroy():void
		{
			clearInterval(_timeoutID);
			
			_properties = null;
			
			var i:int = _propertiesList.length - 1
			for (; i >= 0; --i) 
			{
				_propertiesList[i] = null;
				_propertiesList.splice(i, 1);
			}
			
			_propertiesList = null;			
		}
		
		public function stop():void
		{
			this._isPlaying = false;
		}
		
		public function doContinue():void
		{
			this._isPlaying = true;
		}
	}
}

internal final class ChainTweenProperty
{
	private var _startValue:Number;
	private var _endValue:Number;
	private var _name:String;
	
	public function ChainTweenProperty (name:String, startValue:Number, endValue:Number)
	{
		this._name = name;
		this._startValue = startValue;
		this._endValue = endValue;
	}
	
	public function get startValue():Number { return _startValue; }
	
	public function set startValue(value:Number):void 
	{
		_startValue = value;
	}
	
	public function get endValue():Number { return _endValue; }
	
	public function set endValue(value:Number):void 
	{
		_endValue = value;
	}
	
	public function get name():String { return _name; }
	
	public function set name(value:String):void 
	{
		_name = value;
	}
}
