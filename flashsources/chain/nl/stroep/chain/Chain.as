package nl.stroep.chain
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.clearTimeout;
	import flash.utils.Dictionary;
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
		private static const fadeInObject:Object = { alpha:1 }
		private static const fadeOutObject:Object = { alpha:0 }
		private var destroyOnComplete:Boolean;
		
		protected var durationList:Dictionary = new Dictionary();
		protected var list:Vector.<ChainItem> = new Vector.<ChainItem>();
		protected var tweenList:Vector.<ChainTween> = new Vector.<ChainTween>();
		
		protected var currentTweenIndex:int = 0;
		protected var currentIndex:int = 0;
		protected var currentRepeatIndex:int = 0;
		protected var repeatCount:int = 0;
		protected var intervalCompleteID:uint = 0;
		
		protected var reversed:Boolean = false;
		protected var _isPlaying:Boolean = false;
		
		protected var onComplete:Function;
		
		protected var timer:Timer;
		
		
		/// Constructor
		public function Chain() 
		{	
			timer = new Timer(0);
			timer.addEventListener(TimerEvent.TIMER, onTimer);
		}
		
		/// quick way to get a new instance of Chain
		public static function get create():Chain { return new Chain() }
		
		/// Stop playing, use doContinue to play futher from current point
		public function stop():void
		{
			clearTimeout(intervalCompleteID);
			
			var length:int = tweenList.length;
			var i:int = 0;
			for (; i < length; ++i) 
			{
				tweenList[i].stop();
			}
			
			timer.stop();	
			_isPlaying = false;
		}
		
		/// Continue playing after a stop
		public function doContinue():Chain
		{
			timer.start();	
			_isPlaying = true;
			
			var length:int = tweenList.length;
			var i:int = 0;
			for (; i < length; ++i) 
			{
				tweenList[i].doContinue();
			}
			
			return this;
		}
		
		/// Reset indexes, start from first point. If reversed, start at last point
		public function reset():void
		{
			if (!reversed)
			{
				currentIndex = 0;	
				currentTweenIndex = 0;			
			}
			else
			{
				currentIndex = list.length - 1;
				currentTweenIndex = tweenList.length - 1;
			}
			
			currentRepeatIndex = 0;
		}
		
		/// Adds a function at a specified interval (in milliseconds).
		public function add(func:Function, delay:Number = 0):Chain
		{
			list.push( new ChainItem(func, delay) );
			
			return this;
		}
		
		/// Have a break, take some coffee. Do nothing for a specified interval (in milliseconds).
		public function wait(delay:Number = 0):Chain
		{
			list.push( new ChainItem(null, delay) );
			
			return this;
		}
		
		/// Animate an displayobject, using a properties object with a specific duration and easing
		public function animate(target:DisplayObject = null, properties:Object = null, duration:Number = 0, easing:Function = null):Chain
		{
			tweenList.push( new ChainTween( target, properties, duration, easing ) );
			
			addTweenChainItem(duration);
			
			return this;
		}
		
		/// Fade in DisplayObject
		public function show(target:DisplayObject = null, duration:Number = 0, easing:Function = null):Chain
		{
			tweenList.push( new ChainTween( target, fadeInObject, duration, easing ) );
			
			addTweenChainItem(duration);
			
			return this;
		}
		
		/// Fade out DisplayObject
		public function hide(target:DisplayObject = null, duration:Number = 0, easing:Function = null):Chain
		{
			tweenList.push( new ChainTween( target, fadeOutObject, duration, easing ) );
			
			addTweenChainItem(duration);
			
			return this;
		}
		
		/// Rotates DisplayObject to specific angle (in degrees)
		public function rotate(target:DisplayObject = null, angle:Number, duration:Number = 0, easing:Function = null):Chain
		{
			tweenList.push( new ChainTween( target, {shortRotation: angle}, duration, easing ) );
			
			addTweenChainItem(duration);
			
			return this;
		}
		
		/// Animate an displayobject, using a properties object with specific duration and easing, but with a alternative delay
		public function animateAsync(target:DisplayObject = null, properties:Object = null, duration:Number = 0, delay:Number = 0, easing:Function = null):Chain
		{
			tweenList.push( new ChainTween( target, properties, duration, easing ) );
			
			addTweenChainItem(delay);
			
			return this;
		}
		
		/// Applies settings to an object
		public function apply(object:DisplayObject = null, properties:Object = null, onStart:Boolean = false ):Chain
		{
			var tween:ChainTween = new ChainTween( object, properties, 0 );
			if (!onStart)
			{
				tweenList.push(tween);
			}
			else
			{
				tweenList.splice(0, 0, tween);
			}
			
			addTweenChainItem(0);
			
			return this;
		}
		
		/// Start playing the sequence
		public function play(repeatCount:int = 1, onComplete:Function = null, destroyOnComplete:Boolean = true):void
		{
			this.reversed = false;
			this.repeatCount = repeatCount;
			this.destroyOnComplete = destroyOnComplete;
			
			if (list.length > 0)
			{
				this.reset();
				
				_isPlaying = true;
				timer.start();
			}
			onComplete = onComplete;
		}	
		
		/// Start playing the sequence reversed
		public function playReversed(repeatCount:int = 1, onComplete:Function = null):void
		{
			this.reversed = true;
			this.repeatCount = repeatCount;
			
			if (list.length > 0)
			{
				this.reset();
				
				_isPlaying = true;
				timer.start();	
			}
			onComplete = onComplete;
		}	
				
		/// Clears sequence list. Data will be removed.
		public function destroy():Chain
		{
			var i:int = 0;
			
			this.reset();
			
			for (i = list.length - 1; i >= 0; i--) 
			{
				var listItem:ChainItem = list[i];
				listItem.func = null;
				listItem = null;
				list[i] = null;
				list.splice(i, 1);
			}
			
			for (i = tweenList.length - 1; i >= 0; i--) 
			{
				var chainTween:ChainTween = tweenList[i];
				chainTween.destroy();
				chainTween = null;
				tweenList[i] = null;
				tweenList.splice(i, 1);
			}
			
			list.splice(0, list.length);
			tweenList.splice(0, list.length);
			durationList = null;
			onComplete = null;
			
			return this;
		}
		
		/// Returns the string representation of the Chain private vars.
		public override function toString():String
		{
			var retval:String = "currentRepeatIndex:" + currentRepeatIndex + ", currentIndex:" + currentIndex + ", reversed:" + reversed + ", repeatCount:" + repeatCount + ", loop length:" + list.length;
			return retval;
		}
		
		
		private function addTweenChainItem(duration:Number = 0):void 
		{
			if (durationList[duration]) 
			{ 
				list.push(durationList[duration]);
			}
			else
			{
				var chainItem:ChainItem = new ChainItem(playTween, duration )
				list.push( chainItem );
				durationList[duration] = chainItem;
			}
		}
		
		protected function playTween():void
		{
			tweenList[currentTweenIndex].start(reversed);
			
			//trace("x,y",tweenList[currentTweenIndex].target,tweenList[currentTweenIndex].target.x,tweenList[currentTweenIndex].target.y );
			
			if (!reversed)
			{
				currentTweenIndex ++
			}
			else
			{
				currentTweenIndex --
			}
			
			if (!reversed && currentTweenIndex > tweenList.length)
			{
				currentTweenIndex = 0;
			}
			if (reversed && currentTweenIndex < 0)
			{
				currentTweenIndex = tweenList.length;
			}
		}
		
		protected function execute(index:uint):void
		{	
			timer.stop();
			
			var obj:ChainItem = list[index] as ChainItem;
			if (obj.func != null)
			{
				obj.func();
			}
			if (_isPlaying)
			{
				timer.delay = obj.delay;
				timer.repeatCount = 0;
				timer.start();
			}
		}	
		
		protected function executeOnComplete():void
		{	
			var obj:ChainItem;
			
			if (!reversed)
			{
				obj = list[list.length - 1] as ChainItem;
			}
			else
			{
				obj = list[0] as ChainItem;
			}
		
			intervalCompleteID = setTimeout( dispatchComplete, obj.delay );
		}
		
		protected function dispatchComplete():void
		{
			dispatchEvent( new Event( Event.COMPLETE, false, false) );
			
			if (onComplete != null) onComplete();
			if (destroyOnComplete) destroy();
		}
		
		protected function onTimer(e:TimerEvent = null):void 
		{
			if (!reversed && currentRepeatIndex >= repeatCount && currentIndex == 0 || 
				reversed  && currentRepeatIndex >= repeatCount && currentIndex == list.length - 1 )
			{		
				this.stop();
				this.executeOnComplete();
			}
			else
			{
				this.execute(currentIndex);
			}
			
			if (!reversed)
			{
				currentIndex ++
			}
			else
			{
				currentIndex --
			}
			
			if (!reversed && currentIndex >= list.length)
			{
				currentIndex = 0;
				currentRepeatIndex ++;
				currentTweenIndex = 0;
			}
			
			if (reversed && currentIndex < 0)
			{
				currentIndex = list.length - 1;
				currentRepeatIndex ++;
			}
			
			if (list[currentIndex].delay == 0 ) {
				timer.stop();
				onTimer()
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