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
		protected var _easeFunc:Function;
		
		protected var _duration:Number = 0;
		protected var _target:DisplayObject;
		protected var _properties:Object;
		protected var _startTime:int = 0;
		
		protected var _timeoutID:uint = 0;
		
		protected var _propertiesList:Vector.<ChainTweenProperty>;
		protected var _isPlaying:Boolean = true;
		protected var _reversed:Boolean;
		private var isCollected:Boolean;
		
		public function ChainTween(target:DisplayObject = null, properties:Object = null, duration:Number = 0, easing:Function = null)
		{
			this._target = target;			
			this._properties = properties;			
			this._duration = duration;
			
			if (easing != null)
			{
				_easeFunc = easing;
			}
			else
			{
				_easeFunc = Easing.quartOut;
			}
		}
		
		public function start(reversed:Boolean = false):void
		{
			if (_duration > 0)
			{
				this._reversed = reversed;
				
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
			if (!isCollected)
			{
				if ( _propertiesList == null || !_propertiesList )
				{
					_propertiesList = new Vector.<ChainTweenProperty>();
					var name:Object;
					
					for ( name in _properties )
					{ 
						if ( name == "scale" )
						{
							var endScale:Number = _properties[name];
							_propertiesList.push( new ChainTweenProperty( "scaleX", _target["scaleX"], endScale ) );
							_propertiesList.push( new ChainTweenProperty( "scaleY", _target["scaleY"], endScale ) );
						}
						else if ( name == "shortRotation" )
						{
							_propertiesList.push( new ChainTweenProperty( String(name), _target["rotation"],  _properties[name] ) );
						}
						else
						{
							_propertiesList.push( new ChainTweenProperty( String(name), _target[name], _properties[name] ) );
						}
					}
				}
				isCollected = true;
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
						if (property.name == "shortRotation")
						{
							_target["rotation"] = (!_reversed) ? property.endValue : property.startValue;
						}
						else
						{
							_target[property.name] = (!_reversed) ? property.endValue : property.startValue;
						}
						executeOnComplete();
					}
					else
					{
						// tweening calculation here
						var easedPosition:Number = (!_reversed) ? _easeFunc(position) : _easeFunc(1 - position);
						
						if (property.name == "shortRotation")
						{
							_target["rotation"] = property.startValue + (((property.endValue - property.startValue + 540) % 360) - 180) * easedPosition;
						}
						else
						{
							_target[property.name] = property.startValue + (property.endValue - property.startValue) * easedPosition;
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
			if ( _propertiesList)
			{
				var i:int = _propertiesList.length - 1
				for (; i >= 0; --i) 
				{
					_propertiesList[i] = null;
					_propertiesList.splice(i, 1);
				}
				
				_propertiesList = null;		
			}
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
