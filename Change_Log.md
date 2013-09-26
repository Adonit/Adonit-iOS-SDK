#JotTouchSDK Change Log

# V2.0 Beta 1 Release Notes
- Added support for new Adonit Jot Script stylus
- Added iOS7 Support
- Added iOS7 Look and feel to Settings UI views
- Added CoreMotion.framework dependency
- Added new JotStylusManagerisStylusDown property to simplify checking if stylus type is currently pressed
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

