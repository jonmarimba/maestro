# 0.4.0 

### Added 
  - adds base view debug helper util
  - adds Mlabel, and some other fixes

### Changed
  - order of unbinding when binding a node field in fire-once only mode

### Fixed
  - various small fixes related to typos in the bindings 
  - fixes issue that can cause the same observable to fire, when a new observable is created in the callback of a fiew once observable

# 0.3.0 

### Added
  - new sample project for showing how deep linking can be managed with a controller, having it's own stack of views, independent of the rest of the app
  - wip logo
  - documentation with setup info for all samples

### Changed

  - Improves samples, to better match my preferred patterns for application bootstrapping, and handling deep linking
  - Moves responsibilities out of the BaseScreen, and instead mixes in methods for communicating with the main app
  - sample naming : views to screens
  - sample naming : MainView to AppController

### Fixed
  - Various small framework bugs

# 0.2.0

### Added

  - xml binding processing
  - sample project: todo with View Model
  - sample project: todo with View Model and XML bindings
  - more documentation

### Fixed

  - various build issues
  - minor bugs relating to observables and viewmodels


# 0.1.0

#### Features

 - View framework
 - Navigation containers
 - Observable base classes
 - MVVM framework
 - Utility functions
 - Screen lifecycle, and keyhandling mixins
 - WIP release - still in active development
