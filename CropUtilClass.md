# Documentation `CropUtil` Class #
### `nl.stroep.utils.CropUtil` ###

Easily crop a `DisplayObject` like a `Sprite`, `Movieclip`, `BitmapData` or even your `stage`. The class returns a cropped `Bitmap` object.

**Example Usage**
```
import nl.stroep.utils.CropUtil

// crop stage
var cropFromStage:Bitmap = CropUtil.crop( 100, 100, 200, 200 );
this.addChild ( myCroppedImage );

// crop a movieclip (named myMc)
var cropFromMC:Bitmap = CropUtil.crop( 100, 100, 200, 200, 1, myMc );
this.addChild ( cropFromMC);
 
```

**`CropUtil.crop()` function parameters**

```
public static function crop( _x:Number, _y:Number, _width:Number, _height:Number, scale:Number = 1, displayObject:DisplayObject = null):Bitmap
```