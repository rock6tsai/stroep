package nl.stroep.flashflowfactory.enum 
{
	import flash.display.DisplayObject;
	/**
	 * Alignment util class with static enums 
	 * 
	 * Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
	 * @author Mark Knol
	 */
	public class Alignment
	{
		public static const LEFT_TOP:String = "left_top";
		public static const CENTER_TOP:String = "center_top";
		public static const RIGHT_TOP:String = "right_top";
		
		public static const LEFT_MIDDLE:String = "left_middle";
		public static const CENTER_MIDDLE:String = "center_middle";
		public static const RIGHT_MIDDLE:String = "right_middle";
		
		public static const LEFT_BOTTOM:String = "left_bottom";
		public static const CENTER_BOTTOM:String = "center_bottom";
		public static const RIGHT_BOTTOM:String = "right_bottom";
		
		public static function setAlignment(displayObject:DisplayObject, pageAlignment:String = "left_top", clipAlignment:String = "left_top"):void
		{
			const clipWidth:Number = displayObject.width;
			const clipHeight:Number = displayObject.height;
			
			const stageWidth:Number = displayObject.stage.stageWidth;
			const stageHeight:Number = displayObject.stage.stageHeight;
			
			if (pageAlignment.indexOf("left") > -1) 
			{
				if (clipAlignment.indexOf("center") > -1) { displayObject.x = clipWidth * 0.5; }
				else if (clipAlignment.indexOf("right") > -1) { displayObject.x = clipWidth; }
				else { displayObject.x = 0; }
			}
			else if (pageAlignment.indexOf("center") > -1)
			{
				if (clipAlignment.indexOf("left") > -1) { displayObject.x = stageWidth * 0.5 - clipWidth * 0.5; }
				else if (clipAlignment.indexOf("right") > -1) { displayObject.x = stageWidth * 0.5 - clipWidth * 0.5; }
				else { displayObject.x = stageWidth * 0.5; }
			}
			else if (pageAlignment.indexOf("right") > -1) 
			{
				if (clipAlignment.indexOf("center") > -1) { displayObject.x = stageWidth - clipWidth * 0.5; }
				else if (clipAlignment.indexOf("left") > -1) { displayObject.x = stageWidth - clipWidth; }
				else { displayObject.x = stageWidth - clipWidth - clipWidth; }
			}
			
			if (pageAlignment.indexOf("top") > -1) 
			{
				if (clipAlignment.indexOf("middle") > -1) { displayObject.y = clipHeight * 0.5; }
				else if (clipAlignment.indexOf("bottom") > -1) { displayObject.y = clipHeight; }
				else { displayObject.y = 0; }
			} 
			else if (pageAlignment.indexOf("middle") > -1)
			{
				if (clipAlignment.indexOf("top") > -1) { displayObject.y = stageHeight * 0.5 - clipHeight * 0.5; }
				else if (clipAlignment.indexOf("bottom") > -1) { displayObject.y = stageHeight * 0.5 + clipHeight * 0.5; }
				else { displayObject.y = stageHeight * 0.5; }
			} 
			else if (pageAlignment.indexOf("bottom") > -1) 
			{
				if (clipAlignment.indexOf("middle") > -1) { displayObject.y = stageHeight - clipHeight - clipHeight * 0.5; }
				else if (clipAlignment.indexOf("top") > -1) { displayObject.y = stageHeight - clipHeight - clipHeight; }
				else { displayObject.y = stageHeight - clipHeight; }
			}
			
			// trace("pageAlignment", pageAlignment, ", clipAlignment", clipAlignment, " : ", displayObject.x, displayObject.y);
		}
	}

}