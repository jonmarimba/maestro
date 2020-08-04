
# Maestro

Maestro is a set of patterns and tools that fulfil the following goals:

 - Greatly reduce boilerplate
 - Increase testability
 - Make Roku development safer, more fun, and easier to maintain
 - Allow for MVVM development, which is well suited for scenegraph applications
 - Allow for development using [brighterscript](https://github.com/TwitchBronBron/brighterscript/)
 - Produce projects which are highly navigable in a modern brighscript-enabled IDE
 - Be opinionated

# What does Maestro comprise of

 - [Maestro-cli Command Line Tool](#Maestro-cli-Command-Line-tool)
 - [View framework](#View-framework)
 - [MVVM and observable base classes](#MVVM-and-observable-base-classes)
 - [XML bindings](#XML-bindings)
 - [Brighterscript support](#Brighterscript-support)
 - IOC framework - Coming soon!


# How much of maestro do I need to use?

There is a lot to maestro. You are welcome to use as much or as little as you like. 

 - If you prefer, you can use it as a temporary brighterscript compiler, while Bronley Plumb is busy perfecting the official brighterscript compiler.
   - you don't have to use all of brighterscript - you can just use the imports, or the classes, or namespace features
  - you can just use the view framework
  - or just use the xml bindings
  - or only the IOC framework

# Getting started with maestro

TBD - in a nutshell, you'll use the maestro-cli to download and install the framework's source into your project.

# Maestro is an opinionated framework

Brightscript looks like javascript; but is *extremely* different. It does not have scope binding, for starters, and also has a bizarre virtual-machine like division between threads and nodes, which introduces it's own special set of problems that can confuse brightscript developers working to engineer quality software while adhering to software engineering best practices.

This framework is a refinement of several past projects, which were based on a decade of similar patterns I used on Adobe Flex and Xamarin SDK's. The patterns here have been thoroughly tested, and I solve many of the problems Roku developers face, while adhering to brightscript and scenegraph idioms.

I've found it desirable where possible to:

 - use pobo-classes (plain old brightscript classes, i.e. aa-classes)
 - have mixin wrappers around callfunc methods wherever possible
 - have as little code in brs code-behind files (i.e. the brs files directly related to an xml view) as possible
 - place more code in easy-to-test view model classes

# Maestro produces brightscript code

There is no special runtime, or any other mechanism. The maestro-cli, simply takes your project and converts it to pure `.brs` and `.xml` files

# Maestro-cli Command Line Tool

Maestro is heavily inspired by angular, Adobe Flex, Xamarin, and other MVVM binding based frameworks. In this manner, maestro has as CLI tool, named [maestro-cli](https://github.com/georgejecook/maestro-cli), to assist in managing your maestro projects.
We use the tool to compile our code (which is written in brighterscript), and to compile the xml bindings in our projects.

The tool is used as part of your build chain. Once you have compiled all of the sources for your project, into a staging folder, you run the tool against the staging folder, which will manipulate your files to:

- compile `.bs` brighterscript files into `.brs` brightscript files
- wire up bindings in your `.xml` view files

Maestro-cli can be used from both the command line, and from javascript, for example as part of your gulp tool chain

## using maestro-cli
Simply install the `maestro-cli-roku` npm package and use that to install the framework files, and run your tests.

You can even use `maestro-cli` from your npm-compatible build tools, such as gulp.

`maestro-cli` can download and install the maestro framework brighterscript (or brightscript) files for you, or generate classes

Run `maestro-cli --help` for more documentation

### installing maestro framework

   ```
   npm install maestro-cli-roku -g
   maestro-cli i myProjectRootPath #path where your manifest, source and components folders reside
   ```

## Compiling

### From command line

Create a config file, with a config for your project, as such:

*project-maestro-config.json

```
{
  let config = createMaestroConfig({
    "filePattern": [
      "**/*.bs",
      "**/*.brs",
      "**/*.xml",
    ],
    "sourcePath": "src",
    "outputPath": "build",
    "logLevel": 4,
    "nonCheckedImports": ['source/rLog/rLogMixin.brs',
      'source/tests/rooibosDist.brs',
      'source/tests/rooibosFunctionMap.brs'
    ]
  });
  let processor = new MaestroProjectProcessor(config);
  await processor.processFiles();
}
```

and use the following command

```
maestro-cli project-maestro-config.json
```

### From gulp

This repo is full of samples that demonstrate how to compile your maestro projects. Here is a basic example:

```
import { MaestroProjectProcessor, createMaestroConfig } from 'maestro-cli-roku';

async function compile(cb) {
  let config = createMaestroConfig({
    "filePattern": [
      "**/*.bs",
      "**/*.brs",
      "**/*.xml",
    ],
    "sourcePath": "src",
    "outputPath": "build",
    "logLevel": 4,
    "nonCheckedImports": ['source/rLog/rLogMixin.brs',
      'source/tests/rooibosDist.brs',
      'source/tests/rooibosFunctionMap.brs'
    ]
  });
  let processor = new MaestroProjectProcessor(config);
  await processor.processFiles();
}

//example gulp build targets
exports.build = series(clean, createDirectories, compile);
exports.prePublish = series(exports.build, addDevLogs)
```

# View framework

The View framework allows us to generate Roku screens and components, which have a known lifecycle. If you've done much Roku dev, you know how little of a framework exists for reasoning about a view's lifecycle events, such as being shown, getting focus, keys, etc. The Base view classes allow us to simply override abstract functions to seamlessly get lifecycle hooks for:

 - instantiation and destruction
 - adding to and removal from container views
 - showing and hiding
 - key presses
 - focusing of views, or their children

In addition the view framework contains many base classes that can be used

## Mixins

Maestro makes use of many different mixin classes, which handle different aspects of view management (e.g. utils, focus, key handling), and then bundles these together in base classes (views and screens).

Aggregate views for tab (i.e. iOS style TabController navigation) and stack (i.e. iOS style NavController navigation) are provided

## Main views

### BaseView

This is the base view responsible for mixing in functions for focus management, key handling and providing the main framework. It light enough for use as a component; but not recommended for use in rowlists/grids/other aggregate views which are expected to have a large amount of view items.

This view is intended to be extended by Components, which in turn are aggregates of views; but not whole screens.


#### BaseView fields

 - `isInitialized` - indicates if `initialize` has yet been called
 - `isShown`, true if the view is on screen
 - `name`, useful for logging

#### BaseView methods

 - `initialize` - must be called to start the view machinery

#### BaseView abstract methods

You can override these methods to safely drive your application behavior

- `applyStyle(styles, localizations, assets)` - will be called when the view is initialized, so it can apply required styles, etc
- `initialize(args)` - called when the view has been initialized
- `onFirstShow` - called the first time a view is shown
- `onShow` - called when a view is shown 
  - Note that a view cannot be shown if it is not initialized. This method will be called immediately for a visible view, when `initialize` is invoked
- `onHide` - called when a view is hidden
 
In addition you can override the methods in KeyMixin:

 -  `isAnyKeyPressLocked()` - returns true if any key press is locked - the default implementation returns the value of `m.isKeyPressLocked`
 -  `isCapturingAnyKeyPress(key)`, return true if the key `key` is captured

Override the following, to return true, if the applicable key is captured

 -  `onKeyPressDown()`
 -  `onKeyPressUp()`
 -  `onKeyPressLeft()`
 -  `onKeyPressRight()`
 -  `onKeyPressBack()`
 -  `onKeyPressOption()`
 -  `onKeyPressOK()`

Also, BaseView allows entry points for overriding abstract methods from `FocusMixin`

 - `onGainedFocus(isSelfFocused)`
 - `onLostFocus()`

### FocusMixin

The FocusMixin leverages the `FocusManager` node, to allow you to get accurate callbacks. If you use the `FocusMixin` methods for setting focus, you will be able to more easily debug your applications and have more confidence in the focus state of your app, as everything is encapsulated in a well tested mechanism, with accurate events to allow you to make correct assumptions about your app's state

#### FocusMixin methods

- refer to the [api docuementation](https://georgejecook.github.io/maestro/module-FocusMixin.html)
- but in nutshell, use `setFocus(node)` and never use `node.setFocus(true)` again! :)

#### FocusMixin callbacks
  You can override the following methods: 

 - `onGainedFocus` called when your control gets the focus -the `isSelfFocused` boolean parameter indicates if this control has the focus, or one of it's children has the focus.
 - `onLostFocus` called when a control loses focus.

#### using the FocusMixin/FocusManager

You must initialize the focusManger, by using the `initializeFocusManager`
  method, e.g. `initializeFocusManager(m.global)`. You will typically do this in an app controller.

ALWAYS use the FocusMixin's `setFocus` method, so you have a predictable experience with focus management.

#### If you extend BaseView

  - simply override the methods `onGainedFocus` and `onLostFocus`, they will be called at the appropriate times.

#### If you do not extend BaseView
If you do not extend BaseScreen, and want focus callbacks, then:

 - import the FocusMixin into your control
 - initialize your control with `focusMixinInit()`
 - ensure your control has the fields `isFocused` and `isChildFocused`
 i.e.

 ```
     <!-- focus support -->
    <field id="isFocused"  type="boolean" value="false" alwaysNotify="false"/>
    <field id="isChildFocused"  type="boolean" value="false" alwaysNotify="false"/>
 ```

 - override the methods `onGainedFocus` and `onLostFocus`

### BaseScreen

Extends Baseview and adds additional awareness for selections, loading state, if the user is reloading, and contains utility and application level functions. Application functions proxy main application activity such as playing a video, or showing a screen.

#### BaseScreen fields

 - `content` the content that this screen loaded
 - `selection` selection object for the currently selected content
 - `isLoading`
 - `isUserChangePending`
 - `NavController` - reference to the `NavController` this screen belongs to - this is the navController that will be used for `push`, `pop`, and `resetNavController`

#### BaseScreen functions

 - `getTopScreen` - can be used to ask this screen what it considers its top view. This is useful if the screen in turn composes other screens (e.g. via nested NavControllers)
 - `push` - pushes passed in screen to the navController
 - `pop` - pops the current navController screen
 - `resetNavController` - resets the navController - passing in a screen or index, will reset to that screen, or back to that index
 - other utility functions implemented for your app
 
#### BaseScreen abstract functions

BaseScreen provides the same lifecycle methods as Baseview; but also provides

 - `getTopScreen ` - template method used by `getTopScreen`
 - `baseScreenOnShow` - special hook used to overcome needing more `onShow` overrides (SceneGraph has a limit to super method calls)
 - `onUserChange` - called when the user changes, so the view can update itself with the latest data

 
### BaseAggregateView

A special BaseScreen subclass, which manages showing, or hiding views. The `currentView` property informs which view is currently active (i.e. the selected tab, or current view on top of a NavController)

Only one screen is ever visible at a time. A screen's lifecycle methods for focus and visibility will all be managed and can be relied upon for ascertaining the proper state of the screen.


### TabController

BaseAggregateView subclass which allows you to switch various views. The tabController will display a screen which corresponds to the currently selected item. The screen is created lazily, unless it was specified using `addExistingView`

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
 - `resetToIndex` - resets the stack to the desired index

## Component Lifecycle

To make development easier, and remove boilerplate, a lifecycle is provided, so that all views and screens can override a few methods to get accurate access to their perceived state on screen. the lifecycle methods are invoked as follows:

 - `initialize` - invoked once, when `_initializeView` is called for the view, or the view is created by a TabController, or added to a NavController
 - `onFirstShow` - invoked once, when the view first becomes visible
 - `onShow` - can be invoked multiple times
 - `onHide` - can be invoked multiple times
 - `onUserChange` - can be invoked multiple times
 - `onGainedFocus` - called whenever the view or one of it's children gains focus
 - `onLostFocus` - called whenever the view loses focus

 
# MVVM and observable base classes

Maestro is an MVVM (Model View View Model) framework. This pattern is, in the author's opinion, well suited to Roku development: 

 - It allows us to decouple our view logic from the view
 - The resulting view models are highly testable
  - Which means we can write our code using TDD, with rapid turnover
  - While building a regression suite
  - And it's much faster to run a vm class's unit tests, than spin up the app and test our logic there
 - We can more easily stub and mock methods using this pattern 
 - The boilerplate for observables, and other tasks is encapsulated into unit tested framework methods
 - Readers of our code have far more indication as to what code is business logic, and what code is pure view management

The framework base classes also have additional benefits
 - They provide a focus mechanism, making it easy to unit test focus management
 - They provide key listening hooks, making it easy to unit test keyboard interactions
 - They provide hooks for the maestro view lifecycle methods, such as onShow, onFirstShow, onHide, etc

## Observables and ViewModels

### BaseObservable

`BaseObservable` is the class that makes this observable behavior possible. It orchestrates it's responsibilities with the `BaseObservableMixin.bs` script

### BaseViewModel

`BaseViewModel` is a specialized BaseObservable subclass. You will extend this class to create your bindings. These are referred to as _VMs_ or _ViewModels_, which is where Model View View Model pattern gets its name.

We use viewModels like any other class, invoking methods, and setting properties, with one caveat: We must call setField("fieldName", value), for fields we wish to update, so that we can notify any observers of changes

## observers and bindings

These are the 2 forms of observable interaction that the base classes provide:

 - observeField: this will call back a function, when an observable (i.e ViewModel) field is set. This is like `observeField` for brightscript nodes.
 - bindField: this will bind the value of a field to a field on a node.
 - bindNodefield: this will bind the value of a field, to a field on an observer (i.e. ViewModel). The target field can also be a function, in which case it will be invoked with the bound fields' value.

### Binding and observing fields

This is done using mixin methods from the `ObservableMixin.bs` script.

Here is an example of some bindings:

*TodoScreen.vm*
```
function _initialize(args)
  m.vm = TodoScreenVM()
  m.vm.initialize()
  noInitialValueProps = MOM.createBindingProperties(false)
  MOM.bindObservableField(m.vm, "hasItems", m.itemList, "visible")
  MOM.bindObservableField(m.vm, "focusedIndex", m.itemList, "jumpToItem")
  MOM.bindObservableField(m.vm, "hasItems", m.noItemLabel, "visible", MOM.createBindingProperties(true, MOM.transform_invertBoolean))
  MOM.bindObservableField(m.vm, "items", m.itemList, "content")
  MOM.bindObservableField(m.vm, "focusedItem", m.titleLabel, "text", MOM.createBindingProperties(true, getFocusTitle))
  MOM.bindNodeField(m.itemList, "itemFocused", m.vm, "focusItemAtIndex", noInitialValueProps)
  MOM.bindNodeField(m.addButton, "buttonSelected", m.vm, "addTodo", noInitialValueProps)
  MOM.bindNodeField(m.removeButton, "buttonSelected", m.vm, "removeTodo", noInitialValueProps)
  MOM.observeField(m.vm, "focusId", MVVM.onFocusIdChange)
end function
```

Note that we use [brighterscript](https://github.com/TwitchBronBron/brighterscript/) in maestro, so the above calls `MOM.functionName` are _namespace invocations_ on the `MOM` _namespace_ and can just as well be written `MOM_functionName`

It is best to refer to the [API docs](https://georgejecook.github.io/maestro/index.html) for a full explanation; but it's worth noting that each binding supports various properties, which can be created via the `MOM.createBindingProperties` helper.

### Wiring up bindings in code is discouraged

Note however, that we do not generally wire these bindings up ourselves; but prefer xml bindings.

### Removing bindings

All bindings in a given scope (i.e. view or task node) **must** be removed with a call to `MOM.cleanup()`

**You will suffer memory leaks and performance issues if you do not call cleanup, as part of your views destruction code**

# XML bindings

## Overview

Writing bindings and observers is cumbersome, and requires us to mix view and business logic, with boilerplate code.

Maestro allows us to follow MVVM pattern, which in turn means less time spent guessing how things end up in our view : We can see in the xml exactly where field values come from, and what field values will end up doing to our view models.

Here is an example of some bindings in maestro:

```
  <!--One way binding from model.field to node: "oneWaySource"-->
  <Label
      id="titleLabel"
      text="@{vm.titleText}" />

  <!--One way binding from node.field to model.field: "oneWayTarget"-->
  <RowList
      id="rowList"
      focusedIndex="@(m.vm.focusedIndex)" />

  <!--Two Way binding: "twoWay"-->
  <InputBox
      id="nameInput2"
      text="@[vm.name]" />
```

In each of the following examples we can see how we use special binding expressions inside the values of our fields.

When maestro-cli encounters these values it will automatically wire up the code (via the helpers in the previous section) to create the binding.

### Indicating binding mode

The bracket type indicates the binding mode

 - `@{...}` - oneWaySource: from model.field to node.field
 - `@(...)` - oneWayTarget: from node.field to model.field or model.function(value)
 - `@[...]` - twoWay: both of the above
 

### Binding arguments

a binding is as follows:

`@{observable.name, arg1, arg2, ...}`   

 - `observable` is the name of the observable to target, in maestro, this is called `vm`. You should only have one per view; but in fact, any number of any named observables is supported.
 - `name`, the name of the field on the observable. If this is _oneWayTarget_ binding, then you can provide a function name, and even function `()` brackets
 - `args` are as follows:
   - `isSettingInitialValue=true` or `isSettingInitialValue=false` (optional - default to true), will set the value as soon as the binding is created
   - `transform=functionName` (optional) where _functoinName_ of a function *which must be in scope* which transform ths bound field. See `MOM.transform_invertBoolean` for a sample implementation. This is good for allowing us to do view specific transformations without needing multiple vm fields,
   - `isFiringOnce=true` or `isFiringOnce=false` (optional) - will destroy the binding as soon as a value is set
   - `mode=oneWaySource` or `mode=oneWayTarget` or `mode=twoWay` (optional) this specifies the binding mode, it is however preferred you simply use alternate bracket types (`[], {} or ()`)

   

# Brighterscript support

Brighterscript is baked into the `maestro-cli-roku` package, and can be invoked from `maestro-cli`. Development on the official brighterscript project is underway, and once it has feature parity, we will use the official compiler inside of `maestro-cli`.

To get the most out of brighterscript, use the [brighterscript enabled vscode plugin](https://github.com/georgejecook/maestro/releases/download/0.7.0/brightscript-2.4.0-bs.vsix), which will give you language support.

Maestro supports the following brighterscript features (with some limitations):

 - classes
 - namespaces
 - imports

All of these features require that the file have the _brigherscript_ `.bs` extension

 ## namespaces

 - use `namespace [NAME]` and `end namespace` to declare your namespaced code.
 - all functions and subs in the namespace will be prefixed with `[NAME]` so `function foo` will become `function NAME_foo`. This _namespaced_ name will be used in all files to refer to the function
 - the namespace will be made available to other `.bs` files, so they can refer to methods via `[NAME].functionName`

### limitations

Only one namespace per file. All your functions in the file will become namespaced

## classes

  - use `class [NAME] (extends [EXTENDS_NAME]` and `end class` to declare your class:
  - you can extend other classes - `EXTENDS_NAME` must be a valid `.bs` class
  - declare class functions and subs with `public function`, `private function`, `public sub`, `private sub`. These will be merged into your class.
  - declare your constructor with `public function new(args...)`
    - you can call your super constructor (if extending) with `m.super(args...)`
    - if you do not create a constructor, then a zero arg constructor is declared for you
  - declare class fields with `public fieldName = value`
    - you can also use `as` keyword to declare the type: e.g `public name as string` or `public selectedItem as dynamic = invalid`
  - classes must be contained in `.bs` files to be compiled
  - instantiate a class with `new CLASSNAME(args)` - note, class names are NEVER affected by the namespace of the file they are in.
  - be sure to use the `override` keyword, if you override a base class's function or sub. Note, if you are overriding, you can choose whether to call super or not with `m.super`, the compiler will log warnings if you don't call super; but these are verbose, and can be easily quieted by changing your logging level.

### limitations

Only one class per file. the entire file is considered to be the class

## imports

 - use `import "../relativePath/file.brs"` for path imports relative to the source file in which the import statement is
 - use `import "pkg:/source/file.bs"` for an absolute import
 - both `.bs` and `.brs` imports are valid
 - your nodes will automatically have import statements added to the end
 - cascading imports are resolved
 - missing imports are reported, and result in compile error
 - cyclical imports are reported and result in compile error

 
