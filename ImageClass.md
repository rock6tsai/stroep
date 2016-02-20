# Documentation Image Class #
### nl.stroep.display.Image ###

Easily create an image without taking care of loaders and URLRequest etc.
Most simple usage of the Image class:

**Usage**
```
import nl.stroep.display.Image

var myImage:Image = new Image("myImage.jpg");
this.addChild(myImage);
 
```

You can also add these eventListeners to the image:

**Usage**
```
import nl.stroep.display.Image

var myImage:Image = new Image("myImage.jpg");
this.addChild(myImage);

myImage.addEventListener(Event.COMPLETE, onImageLoaded );
myImage.addEventListener(IOErrorEvent.IO_ERROR, onImageError );
myImage.addEventListener(ProgressEvent.PROGRESS, onImageLoading );

function onImageLoaded (e:Event):void {   
   var currentImage:Image = Image(e.currentTarget);
   trace("image loaded! src:", currentImage.src);
}

function onImageError (e:IOErrorEvent):void {
   trace("image error", e.text);
}

function onImageLoading (e:ProgressEvent):void {
   trace("loading image.. bytesLoaded=" + e.bytesLoaded + " bytesTotal=" + e.bytesTotal );
}
```

If you want a rightclick context menu on the image, you should use `nl.stroep.display.ExtendedImage`.

Content context menu
```
"View Image"
"Save Image As.."
"Copy Image Location"
"Send Image"
```
