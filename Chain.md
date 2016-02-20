# Overview #



# Introduction #

This is a util-class to make delayed function calling easy. You can make a chain of functions, by adding them with a delay in milliseconds. This chain can be executed multiple times, even in reversed order. It is also possible to chain tweens with the animate function.


# Examples #

## Example 1 - The add function ##

```
var myChain:Chain = new Chain();
    
myChain
  .add(one, 2000)
  .add(two, 500)
  .add(three, 1000)
  .play(3, onChainComplete);  // play 3 times

// some functions
function one():void { trace("one") }
function two():void { trace("two") }
function three():void { trace("three") }

// complete handler
function onChainComplete():void { 
    trace("done."); 
    myChain.destroy(); // dispose Chain
}
/* trace output:
one two three one two three one two three done.
*/
```

## Example 2 - The animate functions ##

There are 2 animation functions: `animate()` and `animateAsync()`.

```
var myChain:Chain = new Chain();    
myChain
   .animateAsync(myMc, {x:300,y:100}, 700, 10, Easing.elasticInOut) // tween object for 700ms, but start next item after 10 ms
   .animate(myMc2, {rotation:100, alpha:0.5}, 500, Easing.quartIn)  // tween object for 500ms and start next item after 500 ms
   .wait(200) // have a break
   .play(2, onChainComplete); // play 2 times

function onChainComplete():void { 
   trace("done.");
   myChain.destroy(); // dispose Chain
}
```

# Documentation #

## Chain ##
```
/// Stop playing, use doContinue to play futher from current point
public function stop():void

/// Continue playing after a stop
public function doContinue():Chain

/// Reset indexes, start from first point. If reversed, start at last point
public function reset():void

/// Adds a function at a specified interval (in milliseconds).
public function add(func:Function, delay:Number = 0):Chain

/// Have a break, take some coffee. Do nothing for a specified interval (in milliseconds).
public function wait(delay:Number = 0):Chain

/// Animate an displayobject, using a properties object with a specific duration and easing
public function animate(target:DisplayObject = null, properties:Object = null, duration:Number = 0, easing:Function = null):Chain

/// Animate an displayobject, using a properties object with specific duration and easing, but with a alternative delay
public function animateAsync(target:DisplayObject = null, properties:Object = null , duration:Number = 0, delay:Number = 0, easing:Function = null):Chain

/// Apply settings to an object
public function apply(object:DisplayObject = null, properties:Object = null ):Chain

/// Start playing the sequence
public function play(repeatCount:int = 1, onComplete:Function = null):void

/// Start playing the sequence reversed
public function playReversed(repeatCount:int = 1, onComplete:Function = null):void
	
/// Clears sequence list. Data will be removed.
public function destroy():Chain

/// Return chain is playing, stopped or completed
public function get isPlaying():Boolean { return _isPlaying }
```


## Easing ##

Currently you can use these easings:

  * Linear

  * Quart (in, out, in-out)

  * Elastic(in, out, in-out)

  * Back (in, out, in-out)