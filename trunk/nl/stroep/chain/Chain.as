package nl.stroep.chain
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	import flash.utils.Timer;
	
	/**
	 * Delayed function-call helper class
	 * @author Mark Knol
	 */
	
	/// Dispatched when the chain finishes playing / reaches last item
	[Event(name="complete", type="flash.events.Event")]
	 
	final public class Chain extends EventDispatcher
	{		
		protected var _list:Vector.<ChainItem> = new Vector.<ChainItem>();
		protected var _tweenList:Vector.<ChainTween> = new Vector.<ChainTween>();
		
		protected var _currentTweenIndex:int = 0;
		protected var _currentIndex:int = 0;
		protected var _currentRepeatIndex:int = 0;
		protected var _repeatCount:int = 0;
		protected var _intervalCompleteID:uint = 0;
		
		protected var _reversed:Boolean = false;
		protected var _isPlaying:Boolean = false;
		
		protected var _onComplete:Function;
		
		protected var _timer:Timer;
		
		
		/// Constructor
		public function Chain() 
		{	
			_timer = new Timer(0);
			_timer.addEventListener(TimerEvent.TIMER, onTimer);
		}
		
		
		/// Stop playing, use doContinue to play futher from current point
		public function stop():void
		{
			clearTimeout(_intervalCompleteID);
			
			var length:int = _tweenList.length;
			var i:int = 0;
			for (; i < length; ++i) 
			{
				_tweenList[i].stop();
			}
			
			_timer.stop();	
			_isPlaying = false;
		}
		
		/// Continue playing after a stop
		public function doContinue():Chain
		{
			_timer.start();	
			_isPlaying = true;
			
			var length:int = _tweenList.length;
			var i:int = 0;
			for (; i < length; ++i) 
			{
				_tweenList[i].doContinue();
			}
			
			return this;
		}
		
		/// Reset indexes, start from first point. If reversed, start at last point
		public function reset():void
		{
			if (!_reversed)
			{
				_currentIndex = 0;	
				_currentTweenIndex = 0;			
			}
			else
			{
				_currentIndex = _list.length - 1;
				_currentTweenIndex = _tweenList.length - 1;
			}
			
			_currentRepeatIndex = 0;
		}
		
		/// Adds a function at a specified interval (in milliseconds).
		public function add(func:Function, delay:Number = 0):Chain
		{
			_list.push( new ChainItem(func, delay) );
			
			return this;
		}
		
		/// Have a break, take some coffee. Do nothing for a specified interval (in milliseconds).
		public function wait(delay:Number = 0):Chain
		{
			_list.push( new ChainItem(null, delay) );
			
			return this;
		}

		
		/// Animate an displayobject, using a properties object with a specific duration and easing
		public function animate(target:DisplayObject = null, properties:Object = null, duration:Number = 0, easing:Function = null):Chain
		{
			var tween:ChainTween = new ChainTween( target, properties, duration, easing );
			_tweenList.push(tween);
			
			_list.push( new ChainItem(playTween, duration ) );
			
			return this;
		}
		
		
		/// Animate an displayobject, using a properties object with specific duration and easing, but with a alternative delay
		public function animateAsync(target:DisplayObject = null, properties:Object = null , duration:Number = 0, delay:Number = 0, easing:Function = null):Chain
		{
			var tween:ChainTween = new ChainTween( target, properties, duration, easing );
			_tweenList.push(tween);
			
			_list.push( new ChainItem(playTween, delay) );
			
			return this;
		}
		
		protected function playTween():void
		{
			_tweenList[_currentTweenIndex].start(_reversed);
			
			//trace("x,y",_tweenList[_currentTweenIndex].target,_tweenList[_currentTweenIndex].target.x,_tweenList[_currentTweenIndex].target.y );
			
			if (!_reversed)
			{
				_currentTweenIndex ++
			}
			else
			{
				_currentTweenIndex --
			}
			
			if (!_reversed && _currentTweenIndex > _tweenList.length)
			{
				_currentTweenIndex = 0;
			}
			if (_reversed && _currentTweenIndex < 0)
			{
				_currentTweenIndex = _tweenList.length;
			}
		}
		
		/// Applies settings to an object
		public function apply(object:DisplayObject = null, properties:Object = null ):Chain
		{
			var tween:ChainTween = new ChainTween( object, properties, 0 );
			_tweenList.push(tween);
			
			_list.push( new ChainItem(playTween, 0) );
			
			return this;
		}
		
		/// Start playing the sequence
		public function play(repeatCount:int = 1, onComplete:Function = null):void
		{
			this._reversed = false;
			this._repeatCount = repeatCount;
			
			if (_list.length > 0)
			{
				this.reset();
				
				_isPlaying = true;
				_timer.start();
			}
			_onComplete = onComplete;
		}	
		
		/// Start playing the sequence reversed
		public function playReversed(repeatCount:int = 1, onComplete:Function = null):void
		{
			this._reversed = true;
			this._repeatCount = repeatCount;
			
			if (_list.length > 0)
			{
				this.reset();
				
				_isPlaying = true;
				_timer.start();	
			}
			_onComplete = onComplete;
		}	
				
		/// Clears sequence list. Data will be removed.
		public function destroy():Chain
		{
			var i:int = 0;
			
			this.reset();
			
			for (i = _list.length - 1; i >= 0; i--) 
			{
				var listItem:ChainItem = _list[i];
				listItem.func = null;
				listItem = null;
				_list[i] = null;
				_tweenList.splice(i, 1);
			}
			
			for (i = _tweenList.length - 1; i >= 0; i--) 
			{
				var chainTween:ChainTween = _tweenList[i];
				chainTween.destroy();
				chainTween = null;
				_tweenList[i] = null;
				_tweenList.splice(i, 1);
			}
			
			_list.splice(0, _list.length);
			_tweenList.splice(0, _list.length);
			_onComplete = null;
			
			return this;
		}
		
		/// Returns the string representation of the Chain private vars.
		public override function toString():String
		{
			var retval:String = "_currentRepeatIndex:" + _currentRepeatIndex + ", _currentIndex:" + _currentIndex + ", _reversed:" + _reversed + ", _repeatCount:" + _repeatCount + ", loop length:" + _list.length;
			return retval;
		}
		
		protected function execute(index:uint):void
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
		
		protected function executeOnComplete():void
		{	
			var obj:ChainItem;
			
			if (!_reversed)
			{
				obj = _list[_list.length - 1] as ChainItem;
			}
			else
			{
				obj = _list[0] as ChainItem;
			}
		
			_intervalCompleteID = setTimeout( dispatchComplete, obj.delay );
		}
		
		protected function dispatchComplete():void
		{
			dispatchEvent( new Event( Event.COMPLETE, false, false) );
			
			if (_onComplete != null) _onComplete();
		}
		
		protected function onTimer(e:TimerEvent):void 
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
				_currentTweenIndex = 0;
			}
			
			if (_reversed && _currentIndex < 0)
			{
				_currentIndex = _list.length - 1;
				_currentRepeatIndex ++;
			}
		}
		
		/// Return chain is playing, stopped or completed
		public function get isPlaying():Boolean { return _isPlaying }
	}

}

final class ChainItem
{
	public var func:Function;
	public var delay:Number = 0;
	
	public function ChainItem( func:Function, delay:Number = 0 ) 
	{
		this.func = func;
		this.delay = delay;
	}
}