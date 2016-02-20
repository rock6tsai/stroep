<h4><font color='blue'>This is a working draft and will frequently be changed. The framework is currently in beta. Let me know what you think and what can be improved.</font></h4>


<img src='http://blog.stroep.nl/wp-content/flashflowfactory1.png' align='right' title='flashflowfactory' alt='flash flow factory' width='250' />
# Flashflowfactory Framework #
_current version: 0.9 beta_

This lightweight framework helps you to easily setup a flash website. It is called **flashflowfactory**.

The framework makes use of `SWFAddress 2.5` for deeplinking.
Flashflowfactory is compatible to multiple tweenengines for transitions and easing.


## Content overview ##



---

# About #

Over time I have created this lightweight framework which helps you to easily setup a flash website. It is called **flashflowfactory**. The framework makes use of `SWFAddress 2.5` for deeplinking and your favorite tweenengine for transitions (`TweenLite, Tweener, gTween or Eaze-Tween`). When you need to create small/medium websites with deeplinking and basic transitions, flashflowfactory could help you develop faster. The best of flashflowfactory is its simplicity; no need to learn hard design-patterns, it is really straight-forward if you know the basics. You don't have to develop a page setup with deeplinking and transitions or start from scratch, but keep the freedom to build the site in your style.

---

# Flashflowfactory Features #

These are the features of flashflowfactory
  * Fast but easy-to-learn [page setup creation](#How_to_use.md)
  * [Transition between pages](#Step_5:_Customize_settings_+_add_Transitions.md) with settings and states
    * There are useful [Transitions](FlashFlowFactory#Flashflowfactory_Transitions.md) included, download a transitionpack from your favorite tweenengine: `TweenLite, Tweener, gTween or Eaze-Tween`.
    * [Creating your own transitions](FlashFlowFactory#How_to_create_your_own_transition.md) is possible. This keeps your freedom of expression and makes it usable for every custom project.
  * [Customizable per-page (browser-)titles](#Add_titles.md)
  * Deeplinking made easy: `SWFAddress 2.5` is included and there is no need to worry about deeplinking anymore
  * [Global](#Step_5:_Customize_settings_+_add_Transitions.md) and [local](#How_to_overwrite_default_page_settings.md) [page settings](#Page_Settings.md)
    * Transition in/out between pages
    * Customizable easing/time
    * Alignment options
  * [Alternative navigation (button) system](#Flashflowfactory_Navigation_Button.md)
    * Really easy click function
    * Automatic states
    * Grouping aka active state
  * Global event system
    * Listen to an event from any point inside your application
  * Automatic event removal system


---


# Download the framework in 2 steps #

  * **Step 1: Download framework SWC:
> > http://stroep.googlecode.com/files/flashflowfactory.swc**
  * **Step 2: Choose a transition pack:**
    * http://stroep.googlecode.com/files/Tweenlite.zip
    * http://stroep.googlecode.com/files/gTween.zip
    * http://stroep.googlecode.com/files/Tweener.zip
    * http://stroep.googlecode.com/files/eaze.zip

## DOCUMENTATION ##
  * wiki : http://code.google.com/p/stroep/wiki/FlashFlowFactory (current page)
  * asdoc documentation: http://flashflowfactory.stroep.nl/Documentation/flashflowfactory/


---


# Flashflowfactory Tutorial #

## How to use ##

Before starting, you should know a few things: how to create link classes to `MovieClips`, and the basics from actionscript 3. I really recommend to use flash just for the graphics (link it to classes, 'export as SWC'), and use an external AS editor for ultimate coding-fun.
All classes related to the framework are inside package `nl.stroep.flashflowfactory`

I have separated the framework from the transitions since this allows me to give you multiple transition packs and some freedom to create an SWC file from the framework without any tweenengine. You should add both things (the SWC and the transition pack classes) to your project.

### Step 1: Create flashfile ###

Just to start, create a new flash file / project. Save it and place the flashflowframework files next to the flash, or create your own setup where the framework is included. Make sure you included the tween engine and `SWFAddress` too. In case you want to use `TweenLite`, you should download the SWC/sources from greensock.com, since I cannot offer the file from googlecode (because of it's license). Now we need to design some pages. In the next examples I am using the `TweenLite` pack.

### Step 2: Create Pages ###

Create a `MovieClip` called `HomePageVC`. Draw a square in it (about 500x400 px) and add some text and a title called 'Home'. Imaging this is your homepage. The centerpoint of the page should be on the top left. Find the `MovieClip` in your library and go to the linkage screen (right-click). Choose "_export for ActionScript_". In the _class_  input you should enter `HomePageVC` and the base class should be `nl.stroep.flashflowfactory.Page`. You are now extending the Page class from the framework. Create two other pages, called `ContactPageVC` and `InfoPageVC`, all should extend `nl.stroep.flashflowfactory.Page`. You now have 3 pages, ready to be used.

### Step 3: Create Document class ###
Create a `Main.as` and place it in the root of your project, and use this as Document Class. If you are creating a project from external code editor, mark this file as 'always compile' or compile starting point.

Note: This is the most simple usage of the framework. Ofcourse there are more settings available.
```
package
{
	import flash.display.Sprite;
	import nl.stroep.flashflowfactory.PageFactory;

	public class Main extends Sprite 
	{		
		private var pageFactory:PageFactory;
		
		public function Main():void 
		{
			pageFactory = new PageFactory();
						
			// add your pages here
			pageFactory.add( "/home", HomePageVC );
			pageFactory.add( "/contact", ContactPageVC );
			pageFactory.add( "/info", InfoPageVC );
			
			// add page holder to stage
			addChild( pageFactory.view );
						
			// load intropage
			pageFactory.init();
		}
	}
}
```

It would be better to create a `Pages.as` file, which contains constants with all paths. This is very useful when pointing at multiple places to the same page.
```
package
{
	public class Pages
	{
		public static const HOME_PAGE:String = "/home";
		public static const CONTACT_PAGE:String = "/contact";
		public static const INFO_PAGE:String = "/info";
	}
}
```

### Step 4: Create simple navigation ###

Now you have 3 pages ready to be used. You need some navigation buttons to navigate through the pages. Create 3 buttons for each page (home, contact, info). Find the buttons in your library and go to the linkage screen (right-click). Choose "_export for ActionScript_". In the _class_ input you should enter `HomePageButtonVC` and the base class should be `nl.stroep.flashflowfactory.navigation.NavigationButton`. Apply this rule for all buttons, they should all extend `nl.stroep.flashflowfactory.navigation.NavigationButton`. Place the buttons on the stage and give them the _instance names_ 'buttonHome', 'buttonInfo', 'buttonContact'.

Go to your `Main.as`. Replace all code to this code:
```
package
{
	import flash.display.Sprite;
	import nl.stroep.flashflowfactory.PageFactory;
	import nl.stroep.flashflowfactory.navigation.NavigationButton;

	public class Main extends Sprite 
	{		
		private var pageFactory:PageFactory;
		// stage instances
		public var buttonHome:NavigationButton;
		public var buttonInfo:NavigationButton;
		public var buttonContact:NavigationButton;

		public function Main():void 
		{
			pageFactory = new PageFactory();

			pageFactory.add( Pages.HOME_PAGE, HomePageVC );
			pageFactory.add( Pages.CONTACT_PAGE, ContactPageVC );
			pageFactory.add( Pages.INFO_PAGE, InfoPageVC );			
			
			addChild( pageFactory.view );
						
			pageFactory.init();

			initButtons();
		}

		private function initButtons():void 
		{
			// set button home to go to "/home" on click
			buttonHome.click(Pages.HOME_PAGE);
			// set button home to go to "/info" on click
			buttonInfo.click(Pages.INFO_PAGE);
			// set button home to go to "/contact" on click
			buttonContact.click(Pages.CONTACT_PAGE);
		}
	}
}
```
The `NavigationButton` is very powerful, please do read [this section](#Flashflowfactory_Navigation_Button.md) about the options

Note: If you are creating an as3-only project, you should create instances of the buttons, like `buttonHome = new HomePageButtonVC()` etc.

Run the movie; you should have a clickable+working "website" with navigation and deeplinking. If you don't want to use the NavigationButton from the framework you can also call `PageFactory.gotoPage(Pages.HOME_PAGE)` from any point inside your application.

### Step 5: Customize settings + add Transitions ###
Lets manipulate the default settings and add a slide transition (fading in from left). The animation-in effect should have an `Elastic.easeOut` and should take 1 second. The animation-out effect should be an `Strong.EaseIn` and should take 0.7 seconds. Note the easing functions are used from `TweenLite` package.

```
package
{
	import flash.display.Sprite;
	import com.greensock.easing.Elastic;
	import com.greensock.easing.Strong;
	import nl.stroep.flashflowfactory.PageFactory;
	import nl.stroep.flashflowfactory.PageSettings;
	import nl.stroep.flashflowfactory.navigation.NavigationButton;
	import nl.stroep.flashflowfactory.enum.Alignment;
	import nl.stroep.flashflowfactory.transitions.*;

	public class Main extends Sprite 
	{		
		private var pageFactory:PageFactory;
		// stage instances
		public var buttonHome:NavigationButton;
		public var buttonInfo:NavigationButton;
		public var buttonContact:NavigationButton;

		public function Main():void 
		{
			pageFactory = new PageFactory();
						
			pageFactory.add( Pages.HOME_PAGE, HomePageVC );
			pageFactory.add( Pages.CONTACT_PAGE, ContactPageVC );
			pageFactory.add( Pages.INFO_PAGE, InfoPageVC );			
			
			// add default page settings, can also be overridden from the Page class
			pageFactory.defaultSettings = new PageSettings( 
			    new SlideTransition(),   // transition (there are more transitions + you can easily create your own)
			    Elastic.easeOut,         // easing of the in-transition 
			    Strong.easeIn,           // easing of the out-transition 
			    1,                       // duration of the in-transition 
			    0.7,                     // duration of the out-transition 
			    Alignment.CENTER_MIDDLE, // alignment of the page on the stage
			    Alignment.LEFT_TOP       // centerpoint position of the page
			);

			addChild( pageFactory.view );

			pageFactory.init();

			initButtons();
		}

		private function initButtons():void 
		{
			buttonHome.click(Pages.HOME_PAGE);
			buttonInfo.click(Pages.INFO_PAGE);
			buttonContact.click(Pages.CONTACT_PAGE);
		}
	}
}
```

If you now run the flashfile, you should have a website with buttons, transition and deeplinking. There are a few transitions build in the framework, and some of them have some customizable options (see [Transitions](#Flashflowfactory_Transitions.md)).

#### Easing note ####
You are using easing functions from your tween engine, this means you have to import the right easings functions.

**Special note on easing (only applies for Tweener)**
Normally when you use Tweener, you would use something like  `transition:"linear"` to define an easing. The string definitions are not compatible with flashflowfactory. If you want to define easing in your pageSetting when you are using the Tweener pack, you should use the static functions from 'caurina.transitions.Equations'. for example Equations.easeOutElastic

### Step 6: Finishing touches ###

#### Add titles ####

It is possible to add a title to all page references, which will be shown as browser title (and also in your browserhistory). You can add a prefix for all pages using `pageFactory.titlePrefix` to show a global text message before that. For example, use that variable for your projectname or companyname.

#### Manipulate first page ####

Default the first item you'll add to the `pageFactory.` will be used as start page. You can override this by setting `pageFactory.defaultPageName`.

```
package
{
	import flash.display.Sprite;
	import com.greensock.easing.Elastic;
	import com.greensock.easing.Strong;
	import nl.stroep.flashflowfactory.PageFactory;
	import nl.stroep.flashflowfactory.PageSettings;
	import nl.stroep.flashflowfactory.navigation.NavigationButton;
	import nl.stroep.flashflowfactory.enum.Alignment;
	import nl.stroep.flashflowfactory.transitions.*;

	public class Main extends Sprite 
	{		
		private var pageFactory:PageFactory;
		// stage instances
		public var buttonHome:NavigationButton;
		public var buttonInfo:NavigationButton;
		public var buttonContact:NavigationButton;

		public function Main():void 
		{
			pageFactory = new PageFactory();
			
			pageFactory.add( Pages.HOME_PAGE, HomePageVC, "Welcome!" );
			pageFactory.add( Pages.CONTACT_PAGE, ContactPageVC, "Contact us");
			pageFactory.add( Pages.INFO_PAGE, InfoPageVC, "About us" );	
			
			// set the default title prefix text
			pageFactory.titlePrefix = "Our website - ";
			// set the info page start page as start page.
			pageFactory.defaultPageName = Pages.INFO_PAGE; 

			pageFactory.defaultSettings = new PageSettings( 
			    new SlideTransition(),   
			    Elastic.easeOut,        
			    Strong.easeIn,           
			    1,                       
			    0.7,                     
			    Alignment.CENTER_MIDDLE, 
			    Alignment.LEFT_TOP     
			);

			addChild( pageFactory.view );

			pageFactory.init();

			initButtons();
		}

		private function initButtons():void 
		{
			buttonHome.click(Pages.HOME_PAGE);
			buttonInfo.click(Pages.INFO_PAGE);
			buttonContact.click(Pages.CONTACT_PAGE);
		}
	}
}
```


---


# Flashflowfactory Navigation Button #

Flashflowframework includes a `NavigationButton` class. This is a semi-intelligent `MovieClip` with smart states and an uber-clickfunction.  Just extend `NavigationButton` and the features below are enabled.

## Smart states ##

You can add framelabels called _'out', 'over', 'down' and/or 'active'_. The button will automatically add the needed events for that, and `gotoAndPlay()` to that framelabel. If you extend the class, you can basically add your button-state-animation and it should work Do not forget to set a `stop()` commando at the end of each button-state-animation.

## Grouping ##

If you have multiple buttons, you can group them, to create an active state. Just pass a name (String) of the group to all buttons using the `group`-property. If you click on one member of the group, it will `gotoAndPlay()` to framelabel '_active_' if exist. This should make it easy to create simple buttons with cool states.

## Click functions ##

But that is not it. The `NavigationButton` class is very easy to configure. There is a `click` function, which should basically cover all types of button-click-functions you would ever create. See code below for the divers navigation button possibilities.
```
import nl.stroep.flashflowfactory.navigation.NavigationButton;
import nl.stroep.flashflowfactory.navigation.ButtonTypes;

// link to normal page inside application
myButton.click(Pages.HOME_PAGE);

// link to normal page inside application (equivalent)
myButton.click(Pages.HOME_PAGE, ButtonTypes.INTERNAL);

// link to external url outside the flash application. default target='_blank'
myButton.click("http://www.google.nl/", ButtonTypes.EXTERNAL);

// link to external url outside the flash application, with other target
myButton.click("http://www.google.nl/", ButtonTypes.EXTERNAL, "_self");

// link to javascript function (it's using ExternalInterface)
myButton.click("myJavascriptFunc", ButtonTypes.JAVASCRIPT);

// link to javascript function with parameters
myButton.click("alert", ButtonTypes.JAVASCRIPT, "Works like a charm");

// link to javascript function with multiple parameters
myButton.click("myJavascriptFunc", ButtonTypes.JAVASCRIPT, "param 1", "param 2", "param 3");

// link to function 'sayHello' inside flashapplication
myButton.click(sayHello, ButtonTypes.FUNCTION);

function sayHello(){ 
  trace("Hello!") 
}

// link to function 'sayHelloTo' inside flashapplication with parameters
myButton.click(sayHelloTo, ButtonTypes.FUNCTION, "Mark", "Knol");

function sayHelloTo( firstName:String, lastName:String ){ 
  trace("Hello " + firstName + " " + lastName );
}

```
It is even possible to dispatch global events. You can use the `EventCenter.getInstance()` to listen to them. Note; inside the `Page`-classes there is already an reference to the EventCenter Singleton, it is named `eventcenter`.
```
// OPTION 1. dispatch event without parameters (type only, thats always required)
myButton.click(MyCustomEvent, ButtonTypes.EVENT, "say_hello");

// OPTION 2. dispatch event with parameters
myButton.click(MyCustomEvent, ButtonTypes.EVENT, "say_hello_to", "Mark");


// Anywhere else inside the application you could receive the event
EventCenter.getInstance().addEventListener(MyCustomEvent.SAY_HELLO, onSayHello);
function onSayHello( e:MyCustomEvent ):void { 
  trace('Say hello') 
}

EventCenter.getInstance().addEventListener(MyCustomEvent.SAY_HELLO_TO, onSayHelloTo);
function onSayHelloTo( e:MyCustomEvent ):void { 
  trace('Hello ' + e.firstName) 
}


// example custom event: MyCustomEvent.as
package 
{
	import flash.events.Event;
	public class MyCustomEvent extends Event 
	{
		public static const SAY_HELLO:String = "say_hello";
		public static const SAY_HELLO_TO:String = "say_hello_to";
		
		private var _firstName:String;
		
		public function MyCustomEvent(type:String, firstname:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			this._firstName = firstname;
		} 
		public function get firstName():String { return _firstName; }
	}
}
```

# Documentation #

You can find code documentation here.

## Page Factory ##

This is the Page system which creates/destroys pages and takes care of SWFAddress and it's handling. It is a custom factory design pattern.

  * `titlePrefix:String`
> > Default prefix title for all pages. The `PageFactory` will set the browser title like this: _'titlePrefix pageTitle'_
  * `view`
> > All pages will be added to this `Sprite`. Don't forget to `addChild` 'em in your main document. If you want to use another view instead of this one; It is possible to assign another `Sprite` as `view`.
  * `defaultPageName`
> > You can use this value to start on this page, after you call `init()`
  * `defaultSettings`
> > `PageSettings` class which will be applied on every `Page`. These settings can be overridden in the `Page` Class itself.
  * `add(pageName:String, classReference:Class, title:String = "", wildcard:Boolean = false):void`
> > Registers a page reference with optional title to the pageFactory. The name reflects the deeplink url. These should start with a forwardslash "/".
> > You can (optional) pass a title too, this title will be displayed in your browser-title.
> > Normally an url represents one page (because the exact pageName links to a classReference). It is possible to add a wildcard to the url, which means you can add optional directories, without have declare them all (mostly on dynamic pages). This (optional) feature is still under construction.
  * `remove(pageName:String):void`
> > Unregisters a page reference from the pageFactory
  * `init()`
> > Start the factory, opens first page
  * `dispose()`
> > Removes + cleans pageFactory data
  * `PageFactory.gotoPage(pageName:String):void`
> > Static function. Easy way to navigate to a new page.

## Page ##

Standard page class. This class should be extended.

  * `autoShow:Boolean`
> > When enabled, the `show()` function is called onAddedToStage, otherwise you can call `show()` yourself (Useful when you want to load something before showing the page). Default `true`

  * `pageName:String`
> > Internal page name, auto filled by the `PageFactory`. The pageName reflects the deeplink url, which is set using `SWFAddress`. There is no need to modify this value.

  * `pageTitle:String`
> > Page title, auto filled by the `PageFactory`. The pageTitle reflects the browser title, which is set using `SWFAddress`. There is no need to modify this value.

  * `settings:PageSettings`
> > Settings from the page. auto filled by the `PageFactory`. All values from these settings can be overwritten.

  * `onAddedToStage(e:Event):void `
> > Protected. Overridable method to detect if page is added from stage


  * `onRemovedFromStage(e:Event):void `
> > Protected. Overridable method to detect if page is removed from stage


  * `onPageReady():void `
> > Protected. Overridable method to detect if page is ready (ready means after completing transition-in animation)


  * `show():void`
> > Final. Starts transition-in animation and dispatches global event `PageEvent.SHOW_START`. Cannot be overridden. Listen to `PageEvent.SHOW_START` instead.

  * `hide():void`
> > Final. Starts transition-out animation and dispatches global event `PageEvent.HIDE_START`. Cannot be overridden. Listen to `PageEvent.HIDE_START` instead.

  * `onShowComplete():void`
> > protected. Dispatches global event `PageEvent.SHOW_COMPLETE` after completing transition-in animation. Cannot be overridden. Listen to `PageEvent.SHOW_COMPLETE` instead.

  * `onHideComplete():void`
> > Protected. Dispatches global event `PageEvent.HIDE_COMPLETE` after completing transition-out animation. Cannot be overridden. Listen to `PageEvent.HIDE_COMPLETE` instead.

  * `freeze():void `
> > Protected. Disable page interactions

  * `unfreeze():void  `
> > Protected. Enable page interactions

## Page Settings ##

  * `transition:ITransition`
> > Transition (interface) which will be applied on the page when navigating from/to it, which includes the following functions.
    * `function animateIn(page:Page, speed:Number, easing:Function):void`
    * `function animateOut(page:Page, speed:Number, easing:Function):void`
> > There are already 4 transitions available in the framework (`BlurTransition`, `FadeTransition`, `SlideTransition` and `ExplosionTransition`), and some of them have some customizable options (see auto-completion / online docs).
  * `easingInFunc:Function`
> > This is the easing function which will be applied on the transitionIn animation. You should pass a easing equation from `TweenLite` (like `Strong.easeInOut` or `Elastic.EaseOut`).
  * `easingOutFunc:Function`
> > This is the easing function which will be applied on the transitionOut animation. You should pass a easing equation from `TweenLite` (like `Strong.easeInOut` or `Elastic.EaseOut`).
  * `transitionInSpeed:Number`
> > This is the easing speed which will be applied on the transitionIn animation, which represents the duration of the transitionIn animation. This should not be negative.
  * `transitionOutSpeed:Number`
> > This is the easing speed which will be applied on the transitionOut animation, which represents the duration of the transitionOut animation. This should not be negative.
  * `pageAlignment:String`
> > Alignment of the page to the stage. You can use the `Alignment` class for this settings:
    * `Alignment.LEFT_TOP:String = "left_top";`
    * `Alignment.CENTER_TOP:String = "center_top";`
    * `Alignment.RIGHT_TOP:String = "right_top";`
    * `Alignment.LEFT_MIDDLE:String = "left_middle";`
    * `Alignment.CENTER_MIDDLE:String = "center_middle";`
    * `Alignment.RIGHT_MIDDLE:String = "right_middle";`
    * `Alignment.LEFT_BOTTOM:String = "left_bottom";`
    * `Alignment.CENTER_BOTTOM:String = "center_bottom";`
    * `Alignment.RIGHT_BOTTOM:String = "right_bottom";`
> > Default value: "left\_top"
  * `clipAlignment:String`
> > Alignment of the centerpoint inside the page. Normally you should place the centerpoint to the upperleft, You can use the `Alignment` class for this settings.
> > Default value: "left\_top"


### How to overwrite default page settings ###

Sometimes default settings aren't enough. It is possible to overwrite the settings of all pages. This should be done inside a custom class which extends `Page`, see this example:
```
package  
{
	import flash.events.Event;
	import nl.stroep.flashflowfactory.enum.Alignment;
	import nl.stroep.flashflowfactory.Page;
	
	public class MyCustomPage extends Page
	{
		override protected function onAddedToStage(e:Event):void 
		{
			// overwrite your settings here
			settings.clipAlignment = Alignment.CENTER_TOP;
 			
			// call super to show page
			super.onAddedToStage(e);
		}
	}
}

```

When `autoShow` is `false` (not default) you are a bit more free where to place the custom settings, as long as it is before calling the `show()` function

# Flashflowfactory Transitions #

  * `NoTransition()`
> > Default transition, without options. If you define a speed-value higher than 0, it will use a delay.

  * `SlideTransition( type:String = "from_left", distance:uint = 300, fadeEnabled:Boolean = true )`
> > Transition which slides from a specified distance to a direction.
> > `type` options:
      * `SlideTransition.FROM_TOP:String = "from_top";`
      * `SlideTransition.FROM_RIGHT:String = "from_right";`
      * `SlideTransition.FROM_BOTTOM:String = "from_bottom";`
      * `SlideTransition.FROM_LEFT:String = "from_left";`
      * `SlideTransition.FROM_RANDOM:String = "from_random";`
> > > `distance` the offset/distance (in pixels) to slide from and to.
> > > `fadeEnabled` Enable alpha fade while sliding (default enabled)

  * `Slide3DTransition( type:String = "from_left", distance:uint = 300, fadeEnabled:Boolean = true )`

> > Transition which slides from a specified distance to a direction. Only available if you target FlashPlayer 10 or higher.
> > `type` options:
      * `Slide3DTransition.FROM_TOP:String = "from_top";`
      * `Slide3DTransition.FROM_RIGHT:String = "from_right";`
      * `Slide3DTransition.FROM_BOTTOM:String = "from_bottom";`
      * `Slide3DTransition.FROM_LEFT:String = "from_left";`
      * `Slide3DTransition.FROM_RANDOM:String = "from_random";`
> > > `distance` the offset/distance (in pixels) to slide from and to.
> > > `fadeEnabled` Enable alpha fade while sliding (default enabled)

  * `BlurTransition(quality:uint = 2, blurAmount:Number = 10)`

> > Transition which blurs the page with a specified blur quality and blur amount. Keep in mind blurring could be a CPU heavy task.

  * `FadeTransition()`
> > Transition which fades the page. Without options.

  * `ExplosionTransition(impact:int = 200, levels:int=1)`
> > Transition which explodes the children of the page to random positions. Created for fun.
> > `impact` distance from each child.
> > `levels` levels which indicates how much 'children of children' the effect will apply.

## How to create your own transition ##

When you want to create your own transition, you have to Implement ITransition, This means you have to create 2 functions:
  * `animateIn(page:Page, speed:Number, easing:Function):void`
> > You can build your own in-animation here. This is the animation when you are entering the page. When the animation is done, you should call `page.onShowComplete`.
  * `animateOut(page:Page, speed:Number, easing:Function):void`
> > You can build your own out-animation here. This is the animation when you are leaving the page. When the animation is done, you should call `page.onHideComplete`.

Creating a transition is a bit abstract because you don't have to set the time or easing (just pass the function parameters), but I think this makes it very powerful and dynamic. Think of the `SlideTransition`, you can make it bounce or just slide it in/out very fast with same transition, only with other settings, which are editable on every `Page`.

### Example ###

Take a look at a simple transition, called `FadeTransition`. This one is already included in the transition packs, and this is from the `TweenLite` pack. This should give a clear example of how to setup an own transition:

```
package nl.stroep.flashflowfactory.transitions 
{
	import com.greensock.plugins.AutoAlphaPlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.greensock.TweenLite;
	import nl.stroep.flashflowfactory.Page;
	import nl.stroep.flashflowfactory.transitions.interfaces.ITransition;

	public class FadeTransition implements ITransition
	{
		public function FadeTransition() 
		{
			TweenPlugin.activate([AutoAlphaPlugin]);
		}
		
		public function animateIn(page:Page, speed:Number, easing:Function):void
		{
			page.alpha = 0;
			TweenLite.to( page, speed, { autoAlpha: 1, onComplete: page.onShowComplete, ease: easing } );
		}
		
		public function animateOut(page:Page, speed:Number, easing:Function):void
		{
			TweenLite.to( page,  speed, { autoAlpha: 0, onComplete: page.onHideComplete, ease: easing } );
		}
	}
}
```

# Troubleshooting checklist #
  * Make sure you have chosen and downloaded a transition pack from your tween engine.
  * If you are using the `TweenLite` pack: Make sure you have downloaded the sources from greensock.com and linked it to your project. See online docs. http://www.greensock.com/tweenlite/
  * Make sure `SWFAddress 2.5` is included and linked. When running from browser, the `swfaddress.js` javascript file should be added too, from the same version. See online docs. http://www.asual.com/swfaddress/
  * Events are automatically removed from the Page class. This excludes events which are added to child objects; You have to remove the listeners manually or they could extend `EventManagedSprite` or `EventManagedMovieClip` too.
  * If you use an external code editor which compiles the code, don't forget to build your assets first.
  * If there is video/sound or a `FLVPlayback` component on your page, it will not stop automatically. Please override the `onRemovedFromStage` function and call `player.stop()`. All types of streams should be stopped manually.
  * Always disable 'Automatically declare stage instances' when using a code centered project.
  * When using `EventCenter.getInstance().addEventListener` on a not-`EventManagedSprite`, you should call the `EventCenter.getInstance().removeListeners(this)` on `Event.REMOVED_FROM_STAGE`, since the `EventCenter` is a global object and keeps existing forever. Otherwise you have references to removed objects, which could cause strange behaviors.
```
EventCenter.getInstance().addListener(this, MyCustomEvent.SAY_HELLO, onSayHello);

// listen when clip is removed from the stage
this.addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
function onRemovedFromStage(e:Event):void
{
   EventCenter.getInstance().removeListeners(this);
}

```