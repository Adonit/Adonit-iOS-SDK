#JotTouchSDK Change Log

# V2.6.1
- fix a possible conflict with popular UIColor category that added red/green/blue methods
- fix caching issue with pen commands
- fix a tableview inconsistency crash when showing the settings detail view and switching apps

# V2.6
- Added the ability to report diagnostic and usage data
- Fixed pressure curve issues with some Jot Touch Pixel Points
- Allow suggestionToEnableGestureDelay to be zero
- Miscellaneous bug fixes and improvements

# V2.5.3
- Added the ability to turn line smoothing on or off

# V2.5.2
- Press-and-Hold Settings View controller now works on iOS 6
- Fixed an issue where palm rejection setting switch was not working for script

# V2.5.1
- update the shortcut screen in settings UI to include JTPP
- fix alignment issue when selecting shortcut button

# V2.5 Public Release
- see UPDATE.md for a rundown of API changes in this release
- fixed numerous bugs when running on legacy iOS 6 devices
- added ability for SDK to update configuration settings. 
  this will allow us to support future iOS devices without
  requiring apps to distribute new builds.
- updated example app to support new API changes

# V2.1.0.844 Beta 1
- see UPDATE.md for a rundown of API changes in this release
- better offset calculations based on writing style and stylus angle
- improved behavior of JotTouch events when other gestures cancel touches
- only enable JotTouches when stylus connected
- add gesture recognizers to view instead of window
- allow user to control whether BT warning dialog appears
- misc bug fixes and cleanup


# V2.1.0.832 Alpha 4
- fix to forgetAndTurnOffStylus
- new press-and-hold connection settings view controller.
- JotShortcut now has a shortText property
- renamed the gesture enable delay property to suggestToEnableGestureDelay

# V2.1.0.827 Alpha 3
- fix connection issue with tap style when BT is not initialized
- fix example app to use legacy connection style

# V2.1.0.823 Alpha 2
- update for new JTPP and Adobe Ink models
- new writing style enums
- switch to standard #import <JotTouchSDK/JotTouchSDK.h> header style
- new press-and-hold connection style support
- new JotPalmGestureRecognizer interaction model to avoid spurious gestures
- many bugfixes and improvements


# V2.0.6.497
- fix issue where enabling the SDK can cause disconnects from pens

# V2.0.5.472
- fix possible bluetooth issue when app goes to background

# V2.0.4.469
- fix issue disconnecting and disabling stylus manager causing scanning

# V2.0.3.438
- improvements to palm rejection code, especially when using light pressure
- improvements to multi-device connection when there are multiple Jots and iPads in the same vicinity
- misc bug fixes

# V2.0.2.410
- 64bit support in framework
- Unconnected Pressure now properly set in touch events for Jot Script

# V2.0.0.342 GM
- Fixed pen button notifications that were showing up on a background thread.  They are now dispatched on the main thread.

# V2.0.0.334 RC2
- Fixed Palm rejection fixes to handle corner cases
- Fixed bug with disabling the SDK followed by forgetAndTurnOffStylus causing the SDK to be in a bad state

# V2.0.0.315 RC1
- Fixed palm rejection to be more reliable in all writing styles
- Slowed down offset change with Jot Script when writing quickly
- Fixed connection bug on second stylus connection registering initial pressure
- Fixed duplicate jotTouchMoved events
- Fixed probem where battery status was not updating

# V2.0.0.251 Beta 1
- Fixed issue with stylus connection coming out from app being backgrounded
- Added PreferredJotModel to JotStylusManager

# V2.0.0.248 Beta 1
- Added public firmwareVersion property on JotStylusManager
- Added public hardwareVersion property on JotStylusManager
- Removed issue that caused the  "<CBCentralManager: 0x14dc25c0> is disabling duplicate filtering, but is using the default queue (main thread) for delegate events" warning.
- Fixed delay in pen connection status notification

# V2.0.0.246 Beta 1
- Fixed JotConstants.h compile problem.  Made Header public.
- Cleaned up public header list to only needed headers

# V2.0.0.236 Beta 1
- Added support for new Adonit Jot Script stylus
- Added iOS7 Support
- Added iOS7 Look and feel to Settings UI views
- Added CoreMotion.framework dependency
- Added new JotStylusManager.palmDetectionTouchDelay for better tuning of palm rejection timeout window
- Added new JotStylusManager.palmDetectionTouchDelayNoPressure for better tuning of palm rejection timeout window
- Added new jotStylusManagerDidPairWithStylus notification to inform when a stylus is paired
- Added new notification events to defaultCenter for button presses
-- jotStylusButton1Down
-- jotStylusButton1Up
-- jotStylusButton2Down
-- jotStylusButton2Up
- Added JotStylusManager.writingStyle to add more flexibility to writing angle and orientation
- Renamed the JotShortcut.shortcutDescription to .descriptiveText to remove app store submission warnings
- Renamed JotShortcut initWithShortcutDescription to initWithDescriptiveText to remove app store submission warnings
- Deprecated JotStylusManager.preferredStylusType
- Deprecated JotStylusManager.palmRejectionOrientation
- Removed AVFoundation.framework
- Removed -all_load linker flag requirement
- Removed support and loading of Bluetooth 2.1 Jot Stylus to eliminate app store submission problems and iOS7 microphone access prompt

##JotTouchSDK V1.0.4
- Fixes additional compatibly issues/warnings for non ARC apps
- JotSettingsViewController no longer shows the shortcut buttons list item if no shortcuts have been registered.

##JotTouchSDK V1.0.3
- Removed a leftover NSLog 

##JotTouchSDK V1.0.2
- Added an unregisterView: method
- Fixed a memory leak with the touch gestures


##JotTouchSDK V1.0.1
- Fixes compatibly issues/warnings for non ARC apps.
- Fixes compatibly issues with apps that do not use "shortVersion" entry in the application plist.
- JotSettingsViewController disabled when run on iOS5.0, no longer crashing because of the missing NSLayoutConstraint


##JotTouchSDK V1.0.0
- Initial release

