**Content**


---



<img src='http://blog.stroep.nl/wp-content/flashflowfactory1.png' align='right' title='flashflowfactory' alt='flash flow factory' width='160' />
# Flashflowfactory Framework #
_current version: 0.9 beta_

This lightweight framework helps you to easily setup a flash website. It is called **flashflowfactory**.

The framework makes use of `SWFAddress 2.5` for deeplinking.
Flashflowfactory is compatible to multiple tweenengines for transitions and easing.

_Download in 2 steps:_
  * **Step 1: Download framework SWC:
> > http://stroep.googlecode.com/files/flashflowfactory.swc**
  * **Step 2: Choose a transition pack:**
    * http://stroep.googlecode.com/files/TweenLite.zip
    * http://stroep.googlecode.com/files/gTween.zip
    * http://stroep.googlecode.com/files/Tweener.zip
    * http://stroep.googlecode.com/files/eaze.zip

**DOCUMENTATION / TUTORIAL:

> http://code.google.com/p/stroep/wiki/FlashFlowFactory**

**DISCUSSION / FEATURE REQUESTS / BUG REPORTS:
> http://groups.google.com/group/flashflowfactory**

**ASDOC DOCUMENTATION:
> http://flashflowfactory.stroep.nl/Documentation/flashflowfactory/**

_Example use of FlashFlowFactory_

```
var pageFactory:PageFactory = new PageFactory();
                                                
pageFactory.add( "/home", HomePageVC, "Welcome!" ); /* deeplink url, class reference, browser title */
pageFactory.add( "/contact", ContactPageVC, "Contact us" );
pageFactory.add( "/info", InfoPageVC, "About us" );                 

pageFactory.titlePrefix = "Our Website - "; 
pageFactory.defaultPageName = "/home"; 

pageFactory.defaultSettings = new PageSettings( 
	/* transition:			*/ new SlideTransition(),  
	/* easing in-transition:	*/ Elastic.easeOut,        
	/* easing out-transition:	*/ Strong.easeIn,           
	/* duration in-transition:	*/ 1,                      
	/* duration out-transition:	*/ 0.7,                    
	/* alignment:			*/ Alignment.LEFT_TOP     
   );

addChild( pageFactory.view );

pageFactory.init();

```

## Release notes ##
  * Update 16 may 2011
    * Patched SWFAddress to version 2.5 to avoid conflicts with javascript in some browsers.
    * Removed default blendmode `BlendMode.LAYER` on pages
    * Added `isFrozen` variable to `Page` to be able to detect if page currently is frozen
    * Added `swfAddressEnabled` to `PageFactory`
    * Some other small fixes
  * Update 27 dec 2010
    * Fixed unfreeze bug op Page class
  * Update 14 dec 2010
    * Updated wiki/docs on googlecode
    * Added transitionpacks as .zip file, see download section
  * Update 4 nov 2010
    * The SVN repository is reordered, every project is in a separate folder. Please make sure all paths are corrected after updating the project.
    * You can now use your own favorite tweenengine (it's not limited to `TweenLite` anymore), and you can use Tweener, gTween or eaze-tween too). Demo projects are under construction. You should download your transition pack separately from the framework. This allows me to deliver the framework as SWC.



---



# Chain #

_Delayed function calling / alternative tween engine_

**DOCS: http://code.google.com/p/stroep/wiki/Chain**

**CODE: https://code.google.com/p/stroep/source/checkout**



---



# Util classes #

`nl.stroep.display.Image` - http://code.google.com/p/stroep/wiki/ImageClass

`nl.stroep.display.ExtendedImage` - http://code.google.com/p/stroep/wiki/ImageClass

`nl.stroep.utils.Color` - http://code.google.com/p/stroep/wiki/ColorClass

`nl.stroep.utils.CropUtil` - http://code.google.com/p/stroep/wiki/CropUtilClass

`nl.stroep.utils.ImageSaver` - http://code.google.com/p/stroep/wiki/ImageSaver


---



# About / Licence #

All code is licensed under MIT. Just keep the comments in it and you are free to use it.
Please notify me when you used some of my classes. Thanks!


Greetings, Mark Knol

http://blog.stroep.nl
blog.stroep.nl