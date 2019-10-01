#### 0.4.2 (2019-10-01)

##### Chores

*  docs update ([4b185645](https://github.com/georgejecook/maestro/commit/4b1856456c4456079ed570c539861c2252e786c9))

##### Bug Fixes

*  fixes focus issues when pushing tab views ([cc853271](https://github.com/georgejecook/maestro/commit/cc8532711516b520467c4e1dcb2227eead6b7da7))
*  fixes issue that prevents screens being created ([e1c6e880](https://github.com/georgejecook/maestro/commit/e1c6e880cd79cdcf5bba9f9745c95df8e8829ef0))

#### 0.4.1 (2019-09-30)

##### Chores

*  update gulpfile to get rid of absolute path ([ea84aa87](https://github.com/georgejecook/maestro/commit/ea84aa878b0e197ac91905cfd21db844e7d4c552))
*  normalize all naming with underscores, which goes across all base classes, not just the vm ones. ([04b8cc46](https://github.com/georgejecook/maestro/commit/04b8cc46fe5785c325cd1247d6d7e216e0e47929))
*  remove vm view map ([6c271273](https://github.com/georgejecook/maestro/commit/6c2712733db663d86d3df155751551ac11098653))
*  removes underscores for vm onkey methods ([157cfa4b](https://github.com/georgejecook/maestro/commit/157cfa4b6774dd77fad3f1f9e3c1b6aef6ae199b))

##### New Features

*  disable multiple observables per view, so that noobies can't cause themselves debugging nightmares ([6555f2c2](https://github.com/georgejecook/maestro/commit/6555f2c29a1591ca09fba3504f46691fbb585c11))

##### Bug Fixes

*  minor fixes to ObservableMixin and BaseViewModels ([6dac2735](https://github.com/georgejecook/maestro/commit/6dac27352bbc26a16f93777aa737aed2b0ae4acc))
*  clutch of small tweaks to naming/fixes ([d9cc6ef6](https://github.com/georgejecook/maestro/commit/d9cc6ef648bd0073b330cb5e81108e3e1c93c67f))

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
