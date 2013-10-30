#JotTouchSDK Change Log
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

