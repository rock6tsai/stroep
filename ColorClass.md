# Documentation Color Class #

_sources_

http://code.google.com/p/stroep/source/browse/trunk/flashsources/utils%20classes/nl/stroep/utils/Color.as

http://code.google.com/p/stroep/source/browse/trunk/flashsources/utils%20classes/nl/stroep/utils/ColorUtil.as

# nl.stroep.utils.Color #


Class to work/calculate with colors. You can easily abstract the red, green or blue values from a color.

## Usage ##
```
import nl.stroep.utils.Color

// create orange color
var myColor:Color = new Color(0xFFCC00);


// get individual color values
trace("value", myColor.value);
trace("red", myColor.red);
trace("green ", myColor.green);
trace("blue", myColor.blue);

// set individual color values
myColor.blue = 255;
myColor.green = 0;
myColor.red = 128;

trace("value", myColor.value);
trace("red", myColor.red);
trace("green ", myColor.green);
trace("blue", myColor.blue);
```

## Special functions ##


## `public static function grayscale ( val:int = 0 ):int` ##

_Get a grayscale color from a tint_

```
trace( Color.grayscale(5).toString(16) ); 
// returns 0x050505
```



## `public function darker( count:int = 0 ):int` ##

_Darken color with amount (0 to 255)_

```
var color:Color = new Color(0xFFCC00); // basic orange; 

trace( color.darken(50) ); 
// returns darker orange value. the original value of the instance has not changed 
```



## `public function lighten( count:int = 0 ):int` ##

_Lighten color with amount (0 to 255)_

```
var color:Color = new Color(0xFFCC00); // basic orange

trace( color.lighten(50) );
// returns lighter orange value. the original value of the instance has not changed 
```



**Note**
When you trace myColor.value, flash returns the whole number of the color, not the hex-value. If you want the hexadecimal value, you should use:
```
trace( myColor.value.toString(16) );
```

# nl.stroep.utils.ColorUtil #

All functions in this class are static.

  * `getPureRandomColor():Color`

> Returns a pure random Color instance with value between 0x000000 and 0xFFFFFF


  * `getRandomColor(value:int, offset:int = 0, type:uint = 0):Color`

> Returns a pure random Color instance


  * `getPureRandomColorValue():int`

> Returns a pure random between 0x000000 and 0xFFFFFF


  * `getRandomColorValue(value:int, offset:int = 0, type:uint = 0):int`

> Gets a random color value (int) based on a color. If you put 0xFFCC00 in it and an offset of 50 you get a random orange color.

> _Available types_
    * ColorUtil.DEFAULT = 0 Lighten/darkened colors.
    * ColorUtil.RANDOM = 1 Noisy colors


  * `getRandomColorValueList(length:int, value:int, offset:int = 0, type:uint = 0):/*int*/Array`

> Gets random list of specified length with color values (int). See `getRandomColorValue()`


  * `getRandomColorList(length:int, value:int, offset:int = 0, type:uint = 0):/*Color*/Array`

> Gets random list of specified length with Color instances based on a color. See `getRandomColorValue()`