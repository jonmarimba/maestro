
# Maestro

Maestro is a set of patterns and tools that fulfil the following goals:

 - Greatly reduce boilerplate
 - Increase testability
 - Make roku development safer, more fun, and easier to maintain
 - Allow for MVVM development, which is well suited for scenegraph applications
 - Allow for development using [brighterscript](https://github.com/TwitchBronBron/brighterscript/)
 - Be opinionated
 - Produce projects which are highly navigable in a modern brighscript-enabled IDE

# What does Maestro comprise of

 - [Maestro-cli Command Line Tool](#Maestro-cli-Command-Line-tool)
 - [View framework](#View-framework)
 - [MVVM and observable base classes](#MVVM-and-observable-base-classes)
 - [XML bindings](#XML bindings)
 - [Brighterscript support](#Brighterscript-support)
 - IOC framework - Coming soon!


# How much of maestro do I need to use?

There is a lot to maestro. You are welcome to use as much or as little as you like. 

 - If you want you can just use it as a temporary britherscript compiler, while Bronley plumb is busy perfecting the officila brighterscript compiler.
   - you don't have to use all of brighterscript - you can just use the imports, or the classes, or namespace features
  - you can just use the view framework
  - or just use the xml bindings
  - or only the IOC framework

# Getting started with maestro

TBD - in a nutshell, you'll use the maestro-cli to download and install the framework's source into your project

# Maestro is an opinionated framework

Brightscript looks like javacript; but is *extremely* different. It does not have scope binding, for starters, and also has a bizarre virtual-machine like divisoin between threads and nodes, which introduces it's own special set of problems, that can uttlery confuse and confound brightscript developer's intending to engineer quality software, adhering to software engineering best practices.

The framework is my refinement of several projects, which were based on a decade of similar patterns I used on Adobe Flex and Xamarin SDK's. The patterns here have been thoroughly tested, and I solve many of the problems roku developers face, while adhering to brightscript and scenegraph idioms.

I've found it desirable where possible to:

 - use pobo-classes (plain old brightscript classes, i.e. aa-classes)
 - have mixin wrappers around callfunc methods wherever possible
 - have as little code in brs code-behind files (i.e. the brs files directly related to an xml view) as possible
 - place more code in easy to test-view model classes

# Maestro produces brightscript code

There is no special runtime, or any other mechanism. The maestro-cli, simply takes your project and converts it to pure `.brs` and `.xml` files

# Maestro-cli Command Line Tool

Maestro is heavily inspired by angular, Adobe Flex, Xamarin, and other MVVM binding based frameworks. In this manner, maestro has as CLI tool, named [maestro-cli](https://github.com/georgejecook/maestro-cli), to assist in managing your maestro projects.
We use the tool to compile our code (which is written in brighterscript), and to compile the xml bindings in our projects.

The tool is used as part of your build chain. Once you have compiled all of the sources for your project, into a staging folder, you run the tool against the staging folder, which will manipulate your files to:

- compile `.bs` brighterscript files into `.brs` brighterscript files
- wire up bindings in your `.xml` view files

Maestro-cli can be used from both the command line, and from javascript, for example as part of your gulp tool chain

## using maestro-cli

TBD

# View framework

The View framework allows us to generate roku screens and components, which have a known lifecycle. If you've done much roku dev, you know how little of a framework exists for reasoning about a view's lifecycle events, such as being shown, getting focus, keys, etc. The Base view classes allow us to simply override abstract functions to seamlessly get lifecycle hooks for:

 - instantiation and destruction
 - adding to and removal from container views
 - showing and hiding
 - keypresses
 - focusing of views, or their children

In addition the view framework contains many base classes that can be used

## Mixins

Maestro makes use of many different mixin classes, which handle different aspects of view managemnet (e.g. utils, focus, key handling), and then bundles these together in base classes (views and screens).

Aggregate views for tab (i.e. iOS style TabController navigatoin) and stack (i.e. iOS style NavController navigation) are provided

## Main views

### BaseView

This is the base view responsible for mixing in functions for focus management, keyhandling and providing the main framework. It light enough for use as a component; but not recommended for use in rowlists/grids/other aggregate views which are expected to have a large amount of view items.

This view is intended to be extended by Components, which in turn are aggregates of views; but not whole screens.


#### BaseView fields

 - `isInitialized` - indicates if `initialize` has yet been called
 - `isShown`, true if the view is on screen
 - `name`, useful for logging

#### BaseView methods

 - `initialize` - must be called to start the view machinery

#### BaseView abstract methods

You can override these methods to safely drive your application behaviour

- `_applyStyle(styles, localizations, assets)` - will be called when the view is initialized, so it can apply required styles, etc
- `_initialize(args)` - called when the view has been initialized
- `_onFirstShow` - called the first time a view is shown
- `_onShow` - called when a view is shown - note a view cannot be shown if it is not initialized. This method will be called immediately for a visible view, when `initialize` is invoked
- `_onHide` - called when a view is hidden
 
In addition you can override the methods in KeyMixin:

 -  `_isAnyKeyPressLocked()` - returns true if any keypress is locked - defualt impl is to return the value of `m.isKeyPressLocked`
 -  `_isCapturingAnyKeyPress(key)`, return true if the key `key` is captured

Override the following, to return true, if the applicable key is captured

 -  `_onKeyPressDown()`
 -  `_onKeyPressUp()`
 -  `_onKeyPressLeft()`
 -  `_onKeyPressRight()`
 -  `_onKeyPressBack()`
 -  `_onKeyPressOption()`
 -  `_onKeyPressOK()`

Also, BaseView allows entry points for overriding abstract methods from `FocusMixin`

 - `_onGainedFocus(isSelfFocused)`
 - `_onLostFocus()`

### BaseScreen

Extends Baseview and adds additional awareness for selections, loading state, if the user is reloading, and contains utility and application level functions. Application functions proxy main application activity such as playing a video, or showing a screen.

#### BaseScreen fields

 - `content` the content that this screen loaded
 - `selection` selection object for the currently selected content
 - `isLoading`
 - `isUserChangePending`
 - `NavController` - reference to the `NavController` this screen belongs to - this is the navController that will be used for `push`, `pop`, and `resetNavController`

#### BaseScreen functions

 - `getTopScreen` - can be used to ask this screen what it consider's it's top view. Useful if the screen in turn composes other screens (e.g. via nested NavControllers)
 - `push` - pushes passed in screen to the navController
 - `pop` - pops the current navController screen
 - `resetNavController` - resets the navController - passing in a screen or index, will reset to that screen, or back to that index
 - other utility functions implemented for your app
 
#### BaseScreen abstract functions

BaseScreen provides the same lifecycle methods as Baseview; but also provides

 - `_getTopScreen ` - tempalte method used by `getTopScreen`
 - `_baseScreenOnShow` - special hook used to overcome needing more `onShow` overrides (SceneGraph has a limit to super method calls)
 - `_onUserChange` - called when the user changes, so the view can update itself with the latest data

 
### BaseAggregateView

A special BaseScreen subclass, which manages showing, or hiding views. The `currentView` property informs which view is currently active (i.e. the selected tab, or current view on top of a NavController)

Only one screen is ever visible at a time. A screen's lifecycle methods for focus and visibility will all be managed and can be relied upon for ascertaining the proper state of the screen.


### TabController

BaseAggregateView subclass which allows you to swtich various views. The tabController will display a screen which corresponds to the currently selected item. The screen is created lazily, unless it was specified using `addExistingView`

#### TabController fields

 - `menuItems` array of items, which are used to create child screens. The menuItem must have an id, which matches the view passed in with `addExistingView`, or have it's screenType set to the valid type of a `BaseScreen` subclass
 - `currentItem` _readOnly_ the currently selected menuItem

#### TabController functions

 - `addExistingView` - will register the passed in view to be displayed when a menu item with the same id is set as the `currentItem` 
 - `getViewForMenuItemContent`
 - `changeCurrentItem` - will set the `currentItem`


### NavController

NavController controls a stack of views stacked one up on the other. When a BaseScreen is added to a NavController it's `navController` field is set to the navController. In addition the lifecycle methods `onAddedToAggregateView` and `onRemovedFromAggregateView` are invoked in accordance with `pop`, `push` and `reset`

#### NavController fields

 - `numberOfViews` _readonly_ number of Views on the stack 
 - `isLastViewPopped` _readonly_ true, if the last view is popped, can be observed
 - `isAutoFocusEnabled` if true then pushed views receive focus

### NavController functions

 - `push` - pushes the passed in view onto the stack, and initializes it
 - `pop` - pops current view from the stack
 - `reset` - resets the stack
 - `resetToIndex` - resests the stack to the desired index

## Component Lifecycle

To make development easier, and remove boilerplate, a lifecycle is provided, so that all views and screens can override a few methods to get accurate access to their perceived state on screen. the lifecycle methods are invoked as follows:

 - `_initialize` - invoked once, when `initializeView` is called for the view, or the view is created by a TabController, or added to a NavController
 - `_onFirstShow` - invoked once, when the view first becomes visible
 - `_onShow` - can be invoked multiple times
 - `_onHide` - can be invoked multiple times
 - `_onUserChange` - can be invoked multiple times
 - `_onGainedFocus` - called whenever the view or one of it's children gains focus
 - `_onLostFocus` - called whenever the view loses focus

 
# MVVM and observable base classes

Implemented - documentation TBD

# XML bindings

Implemented - documentation TBD

# Brighterscript support

Almost done - rewriting some aspects to better fit the official brighterscript spec.