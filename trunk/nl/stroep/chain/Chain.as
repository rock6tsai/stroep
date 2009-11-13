package nl.stroep.chain
{
	import flash.events.TimerEvent;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	import flash.utils.Timer;
	
	/**
	 * Delayed function-call helper class
	 * @author Mark Knol
	 */
	
	final public class Chain
	{		
		private const _list:/*ChainItem*/Array = [];
		private var _onComplete:Function = null;
		private var _totalInterval:int = 0;
		private var _currentIndex:int = 0;
		private var _currentRepeatIndex:int = 0;
		private var _repeatCount:int = 0;
		private var _intervalCompleteID:uint = 0;
		private var _reversed:Boolean = false;
		private var _isPlaying:Boolean = false;
		private var _timer:Timer;
		
		/// Constructor
		public function Chain() 
		{
			trace("created Chain");
			
			_timer = new Timer(0);			
			_timer.addEventListener(TimerEvent.TIMER, onTimer);
		}
		
		/// Stop playing, use doContinue to play futher from current point
		public function stop():void
		{
			clearTimeout(_intervalCompleteID);
			
			_timer.stop();	
			_isPlaying = false;
		}
		
		/// Continue playing after a stop
		public function doContinue():Chain
		{
			_timer.start();	
			_isPlaying = true;
			
			return this;
		}
		
		/// Reset indexes
		public function reset():void
		{
			if (!_reversed)
			{
				_currentIndex = 0;				
			}
			else
			{
				_currentIndex = _list.length - 1;
			}
			trace("resetted",_reversed)
			_currentRepeatIndex = 0;
		}
		
		/// Adds a function at a specified interval (in milliseconds).
		public function add(delay:Number = 0, func:Function = null):Chain
		{
			_list.push( new ChainItem(delay, func) );
			
			return this;
		}
		
		/// Start playing the sequence
		public function play(repeatCount:int = 0, onComplete:Function = null):void
		{
			this._reversed = false;
			this._repeatCount = repeatCount;
			this._onComplete = onComplete;
			
			if (_list.length > 0)
			{
				this.reset();
				
				_isPlaying = true;
				_timer.start();
			}
		}	
		
		/// Start playing the sequence reversed
		public function playReversed(repeatCount:int = 0, onComplete:Function = null):void
		{
			this._reversed = true;
			this._repeatCount = repeatCount;
			this._onComplete = onComplete;
			
			if (_list.length > 0)
			{
				this.reset();
				
				_isPlaying = true;
				_timer.start();	
			}
		}	
				
		/// Clears sequence list. Data will be removed.
		public function clear():Chain
		{
			var i:int = 0;
			
			for (i = 0; i < _list.length; ++i) 
			{
				var obj:ChainItem = _list[i] as ChainItem;
				obj = null;
			}
			
			_list.splice(0);
			
			this.reset();
			
			return this;
		}
		
		/// Returns the string representation of the Chain private vars.
		public function toString():String
		{
			var retval:String = "_currentRepeatIndex:" + _currentRepeatIndex + ", _currentIndex:" + _currentIndex + ", _reversed:" + _reversed + ", _repeatCount:" + _repeatCount + ", loop length:" + _list.length;
			return retval;
		}
		
		private function execute (index:uint):void
		{	
			_timer.stop();
			
			var obj:ChainItem = _list[index] as ChainItem;
			if (obj.func != null)
			{
				obj.func();
			}
			if (_isPlaying)
			{
				_timer.delay = obj.delay;
				_timer.repeatCount = 0;
				_timer.start();
			}
		}	
		
		/// 
		private function executeOnComplete():void
		{
			if (_onComplete != null)
			{
				var obj:ChainItem 
				if (!_reversed)
				{
					obj = _list[_list.length-1] as ChainItem;
				}
				else
				{
					obj = _list[0] as ChainItem;
				}
			
				_intervalCompleteID = setTimeout ( _onComplete, obj.delay, this );
			}
		}

		
		/// Get total interval count for 1 loop. Calculate does loop (call on start), otherwise use private _totalInterval
		private function get totalLoopIntervalTime( ):Number
		{
			var retval:Number = 0;
			var i:int = 0;
			
			for (i = 0; i < _list.length; ++i) 
			{
				retval += _list[i].delay;				
			}
			
			_totalInterval = retval;
			
			return _totalInterval;
		}
		
		private function onTimer(e:TimerEvent):void 
		{
			if (!_reversed && _currentRepeatIndex >= _repeatCount && _currentIndex == 0 || 
				_reversed  && _currentRepeatIndex >= _repeatCount && _currentIndex == _list.length - 1 ) 
			{		
				this.stop();			
				this.executeOnComplete();
			}
			else
			{
				this.execute(_currentIndex);
			}
			
			if (!_reversed)
			{
				_currentIndex ++;
			}
			else
			{
				_currentIndex --;
				
			}
			
			if (!_reversed && _currentIndex >= _list.length)
			{
				_currentIndex = 0;
				_currentRepeatIndex ++;
			}
			
			if (_reversed && _currentIndex < 0)
			{
				_currentIndex = _list.length - 1;
				_currentRepeatIndex ++;
			}
			
		}
		
		/// Return chain is playing, stopped or completed
		public function get isPlaying():Boolean { return _isPlaying; }
	}

}

class ChainItem
{
	public var delay:Number = 0;
	public var func:Function = null;
	
	public function ChainItem(delay:Number = 0, func:Function = null) 
	{
		this.delay = delay;
		this.func = func;
	}
}