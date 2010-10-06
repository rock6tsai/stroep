package nl.stroep.framework.enum 
{
	import flash.display.DisplayObject;
	/**
	 * Alignment util class with static enums 
	 * @author Mark Knol
	 */
	public class Alignment
	{
		public static const TOP_LEFT:String = "top_left";
		public static const TOP_CENTER:String = "top_center";
		public static const TOP_RIGHT:String = "top_right";
		
		public static const MIDDLE_LEFT:String = "middle_left";
		public static const MIDDLE_CENTER:String = "middle_center";
		public static const MIDDLE_RIGHT:String = "middle_right";
		
		public static const BOTTOM_LEFT:String = "bottom_left";
		public static const BOTTOM_CENTER:String = "bottom_center";
		public static const BOTTOM_RIGHT:String = "bottom_right";
		
		public static function setAlignment(displayObject:DisplayObject, pageAlignment:String = "top_left", clipAlignment:String = "top_left"):void
		{
			if (pageAlignment.indexOf("left") > -1) displayObject.x = 0;
			if (pageAlignment.indexOf("center") > -1) displayObject.x = displayObject.stage.stageWidth * 0.5;
			if (pageAlignment.indexOf("right") > -1) displayObject.x = displayObject.stage.stageWidth - displayObject.width;
			
			if (pageAlignment.indexOf("top") > -1) displayObject.y = 0;
			if (pageAlignment.indexOf("middle") > -1) displayObject.y = displayObject.stage.stageHeight * 0.5;
			if (pageAlignment.indexOf("bottom") > -1) displayObject.y = displayObject.stage.stageHeight - displayObject.height;
			
			
			if (clipAlignment.indexOf("left") > -1) displayObject.x -= displayObject.width * 0.5;
			//if (clipAlignment.indexOf("center") > -1) displayObject.x 0;
			if (clipAlignment.indexOf("right") > -1) displayObject.x += displayObject.width * 0.5;
			
			if (clipAlignment.indexOf("top") > -1) displayObject.y -= displayObject.height * 0.5;
			//if (clipAlignment.indexOf("middle") > -1) displayObject.y -= displayObject.height * 0.5
			if (clipAlignment.indexOf("bottom") > -1) displayObject.y += displayObject.height * 0.5;
			
		}
	}

}