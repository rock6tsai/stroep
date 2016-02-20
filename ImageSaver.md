# Description of ImageSaver

# Introduction #

ImageSaver class for easy saving/uploading displayobjects to JPG / PNG


# Example usage #

```
// Create saver instance + point to php file on server
var imageSaver:ImageSaver = new ImageSaver( "http://localhost:8080/save-my-image.php" );       
// additional: Add eventlisteners.
imageSaver.addEventListener ( Event.COMPLETE, onSaveComplete );
imageSaver.addEventListener ( IOErrorEvent.IO_ERROR, onSaveError );
// Save textfield as JPG with red background
imageSaver.save ( myTextField, "myfilename1.jpg", 0xFFFF0000 );
// Save bitmap as JPG with red background in low JPG quality (15)
imageSaver.save ( myBitmap, "myfilename2.jpg", 0xFFFF0000, 15 );
// Save a shape as transparent PNG
imageSaver.save ( myShape, "myfilename3.png" );
// Save a movieclip as half-transparent (red) PNG
imageSaver.save ( myMovieClip, "myfilename4.png", 0xCCFF0000 );
// handle events
        
private function onSaveError( e:IOErrorEvent ):void {
    trace ( "Image save failed. Error while saving: " + e.text );
}
private function onSaveComplete( e:Event ):void {
    trace ( "Image save completed"  );
}
```

**upload to server**

The save / upload function works like this:

`public function save( bitmapDrawable:IBitmapDrawable, filename:String, backgroundColor:Number = 0x00FFFFFF, JPGquality:int = 85, rect:Rectangle = null ):void`


**saving local**

The local save function works like this:

`public function saveLocal( bitmapDrawable:IBitmapDrawable, filename:String, backgroundColor:Number = 0x00FFFFFF, JPGquality:int = 85, rect:Rectangle = null ):void`