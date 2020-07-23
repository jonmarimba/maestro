#### 0.7.1 (2020-07-23)

##### Bug Fixes

* **core:**
  *  Fix bad syntax on override in BaseView ([fc8fdd80](https://github.com/georgejecook/maestro/commit/fc8fdd8067bd68cebdd12c895eeab79377a5c521))
  *  Some minor tweaks and fixes ([fa1bbba9](https://github.com/georgejecook/maestro/commit/fa1bbba99685bc39e0c1009fd63de41010578eb8))
* **sample:**  update binding sample to latest syntax ([87de700a](https://github.com/georgejecook/maestro/commit/87de700acb3b83456a0f5b723464b8adb84bf747))
* **docs:**  fixes link to vsix ([eca0ee19](https://github.com/georgejecook/maestro/commit/eca0ee19c9bb2b21dfc4dede1caa3c047358dd4e))

#### 0.7.0 (2020-05-05)

##### New Features

* **core:**
  *  adds modern @. syntax ([fab33f5a](https://github.com/georgejecook/maestro/commit/fab33f5a07dd7f23107a2d4de151da8f7a11d485))
  *  adds dynamic container, and various bug fixes ([a1521700](https://github.com/georgejecook/maestro/commit/a15217007cbbc7a602369f9dd6b7f2137f860aba))

#### 0.6.0 (2020-04-22)

##### New Features

* **Maestro-cli:** Includes a ton of new improvements to maestro-cli-roku's brighterscript compiler, and better aligns compilation with the official, soon to be released, compiler

* **VScode support:** Improves support in vscode for nested namespaces, and other fixes

* **MultiContainer:**  Improvements to multi container ([27553609](https://github.com/georgejecook/maestro/commit/27553609c5f7528834163b9309ff4fbd87f99851))

##### Bug Fixes

* **core:**  various logging optimizations and minor fixes ([37812faf](https://github.com/georgejecook/maestro/commit/37812faffa29f843e9625b013ca21e2eff08da86))
* **build:**  forces travis to build with node 9.9.0, which doesn't blow up jsdoc ([f9cccd5a](https://github.com/georgejecook/maestro/commit/f9cccd5a98207cb7534e0e9025e9b4eddfdbad46))

#### 0.5.0 (2020-04-22)

##### New Features

* **MultiContainer:**  Improvements to multi container ([27553609](https://github.com/georgejecook/maestro/commit/27553609c5f7528834163b9309ff4fbd87f99851))

##### Bug Fixes

* **core:**  various logging optimizations and minor fixes ([37812faf](https://github.com/georgejecook/maestro/commit/37812faffa29f843e9625b013ca21e2eff08da86))
* **build:**  forces travis to build with node 9.9.0, which doesn't blow up jsdoc ([f9cccd5a](https://github.com/georgejecook/maestro/commit/f9cccd5a98207cb7534e0e9025e9b4eddfdbad46))

#### 0.5.0 (2020-01-23)

##### Chores

* **docs:**
  *  doc update ([780ac70b](https://github.com/georgejecook/maestro/commit/780ac70be0fcb7b2b13f5092b1ce49cf7bdf9966))
  *  updates docs, and adds vsix for debugging ([51a78f86](https://github.com/georgejecook/maestro/commit/51a78f86fad1f6057aebd6838c1a3d75ec3b8ba0))
* **build:**  attempts to remove jsdoc footer (didnt' work though :()) ([0e9f77f3](https://github.com/georgejecook/maestro/commit/0e9f77f3aa21968705fa5821b93592db9306fdb5))
*  update version txt ([c94fc1a9](https://github.com/georgejecook/maestro/commit/c94fc1a962b19b352befc533f1d591418ae2a880))

##### New Features

* **MultiContainer:**  adds fields for size, and mechanism to change children after initial creation, and new field for controlling animation speed ([117c3c12](https://github.com/georgejecook/maestro/commit/117c3c122a1adc8b5f3d6f654735e309e2358572))
* **core:**  improves focus management, by creating a new node called FocusManager, and changing the focus api. We now simply set isFocused, and isChildrenFocused on a node, and the mixing observes these values. this stops the seriously chatty focus mangement situation we had when relying on the SG framework for focus guidance. As long as you use focusMixin's setFocus method, you are going to have a good time, and know what is going on :) ([8de1b5f5](https://github.com/georgejecook/maestro/commit/8de1b5f542b9678f08e020f14aed2840d01d74ad))
* **controls:**  adds multi container component, which allows for one to stack multiple controls in one view, and navigate via an index property ([d93e4142](https://github.com/georgejecook/maestro/commit/d93e4142e4eb48b674bebe228ca2a03b40d47ab9))

##### Bug Fixes

* **bindings:**  minor fixes for run time errors ([73c17bbf](https://github.com/georgejecook/maestro/commit/73c17bbf96340b7ea656e046faeca03d5639aae4))

#### 0.4/3 (2019-10-24)

##### Bug Fixes

*  fixes issues with super call in BaseViewModel and some vm observer bindings which were faling ([3bc74e80](https://github.com/georgejecook/maestro/commit/3bc74e8042ef26ef6008f8b8989d8960f89bffdf))

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
