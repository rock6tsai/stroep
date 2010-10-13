package  
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	import nl.stroep.utils.Color;
	import nl.stroep.utils.Image;
	
	/**
	 * ...
	 * @author Mark Knol
	 */
	public class Test extends Sprite
	{
		private var image:Image;
		
		public function Test() 
		{
			test1();
			test2();
			test3();
		}
		
		private function test1():void
		{
			var startTime:Number = getTimer();
			
			var color:Color = new Color(0);
			for (var i:uint = 0; i < 1000000; ++i) 
			{
				color.value = Color.grayscale( i%255 );
			}
			trace("test1", getTimer() - startTime);
		}
		
		private function test2():void
		{
			var startTime:Number = getTimer();
			
			var color:Color = new Color(0);
			for (var i:uint = 0; i < 1000000; ++i) 
			{
				color.value = color.grayscaleFast( i%255 );
			}
			
			trace("test2", getTimer() - startTime);
		}
		
		private var foo:Function = Color.grayscale;
		private function test3():void
		{
			var startTime:Number = getTimer();
			
			var color:Color = new Color(0);
			for (var i:uint = 0; i < 1000000; ++i) 
			{
				color.value = foo( i%255 );
			}
			
			trace("test3", getTimer() - startTime);
		}
		
		
	}
	
}