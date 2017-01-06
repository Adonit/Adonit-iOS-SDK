#Change Log for AdonitSDK (iOS)

#v3.3

**SDK**

- optimize correction algorithms for better writing experience of the [Adonit Pixel](http://www.adonit.net/jot/pixel/) on iPad Pro (9.7/12.9), IP6/IP6+ and IP7/IP7+.
- show SDK and Configuration versions in Adonit "Press-To-Connect" UI
- fix issue that sometimes show opaque or invisible UI components
- fix issue that shows wrong information when no shortcut button is set on first run
- fix issue that resets shortcut button settings after a reconnection or force close
- fix issue that resets stylus settings after an app update

**Jot Workshop**
- show host device model name in UI
- removed unused UI element (Gestures)

#v3.2
- Added support for Adonit Pixel-only features: double tap & scroll.
- Removed option to “Send Diagnostics to Adonit” found in connections UI.
- Fixed broken link to the “Help” page found in connections UI.
- Implemented a new mechanism to adjust stroke correction parameters from an online config file

#v3.1.4
- Fix app crash issue when open JotPressToConnectView during bt turn off
- Fix repetitively connect/disconnect different stylus crash issue

#v3.1.3
- New 3x Assets for all images for better fidelity on iPhone 6 Plus and iPhone 6s Plus.
- New pixel assets for shortcut buttons when an Adonit Pixel is connected.
- By optimizing assets and some occasional programatic drawing, we’ve reduced the bundle size by 50% despite adding in pixel assets.
- Minor Performance increase of offset correction when palms are detected on screen.
- Improved coalescing of coalescedJotStrokes at the beginning of a stroke.
- Removed Support for iOS 7.

#v3.1.2
- Fixed issue that prevented online configuration file from persisting or appropriately updating.

#v3.1.1
- Improved responsiveness of altitudeAngle on jotStroke with compatible styluses.
- Updated default primaryColor of JotSettings UI to match Adonit Branding. (Can still be changed to match your apps palette.)

#v3.1 
- Support for upcoming Adonit Stylus
- Predictive jotStrokes.
- JotStroke pressure is now an adonit calibrated pressure curve that returns a float value beween 0.0 and 1.0
- Added "rawPressure" property to JotStroke for access to NSUInteger raw pressure value. (Similar to pressure in previous versions of the SDK).
- Added allitutde angle to JotStroke on supported styluses.
- Added "stylusSupportsAltitudeAngle" property to JotStylusManager.
- Added "minimumAltitudeAngleSupported" property to JotStylusManager.
- New "AdonitViewControllerDebugStatusIdentifier" JotModelController for debug information on a connected stylus.

# v3.0.4
- Fixed an issue that could cause JotStroke ended events to have a nil view property.
- Fixed an issue that could cause JotStroke ended events to have an incorrect location.
- Minor performance and stability updates.

# v3.0.3
- Fixed an issue where repeatedly connecting and disconnecting a stylus could cause a crash.
- Fixed an issue where quick multiple strokes could cause a crash.
- Fixed an issue where an end stroke could jump down to a users onscreen palm.

# v3.0.2
- Fixed an issue with the "Done" button not always appearing with our Settings UI on iPhone or in iOS 9 multi-tasking.

# V3.0.1
- Fixed an issue that could cause a crash in the iOS Simulator.

# V3.0 
- Fixed a crash around switching in and out of an app in iOS 9 with a connected Stylus.

#V3.0 Beta 4 / Release Canidate
- Renamed JotTouchSDK to AdonitSDK
- Added Coalesced JotStrokes for iOS 9.
- Added Bitcode.
- Changed the configuration file server location to comply with HTTPS
- Fixed bug where asking to disconnect stylus multiple times could cause crash.
- Done button automatically added to Settings UI during sizeclass change.

#JotTouchSDK Change Log
# V3.0 Beta 3
- Registering a view with the SDK will limit jotStroke event delivery to strokes that began in registered views.
- More consistent naming. Shortcut buttons now labeled Button 1 & Button 2 in settings UI.
- More customization. New innerPressToConnectIconColor property for when using a transparent background in a pressToConnect view.
- New stylusSupportsPressureSensitivity property on JotStylusManager to query if the connected stylus supports pressure sensitivity.

# V3.0 Beta 2
- Improved compatibility in APIs for apps written in swift.
- Cleanup and organization of JotStylusManager.h

# V3.0 Beta 1
- Improved palm rejection and stroke syncing on iOS devices running iOS 8 or later.
- Switch to JotStroke object and JotStrokeDelegate from JotTouch object and JotPalmRejectionDelegate.

# V2.7
- added settings and connection UI
- improved wavy line correction
- improved dropped stroke connections
- removed the tap to connect connection style
- removed support for iOS 6
- other miscellaneous bug fixes and improvements

# V2.6.5
- fixes issues with dropped strokes
- improved rejection of palm touches
- improved palm rejection performance (less latency)
- increased small detail and writing clarity in correction of wavy-line
- improved stylus support for iPad Air 2
- deprecated the tap to connect connection style
- other miscellaneous bug fixes and improvements

# V2.6.4
- NOTE: JotTouchSDK now requires SytemConfiguration.framework to be added to apps
- SDK uses reachability to detect when it can download updated configuration file
- fixes issues with iPad Air 2 and wavy-lines
- fixes issues with iPad mini 3 and wavy-lines
- improved wavy-line correction for older iPads
- fixes excessive failed battery check logging
- fixes crash when app goes into the background
- other miscellaneous bug fixes and improvements

# V2.6.3
- fixes issue where SDK might disconnect from a stylus that goes off screen
- fixes issue with sending commands to already disconnected stylii during connection process

# V2.6.2
- fixes offset and palm rejection issues when compiled against iOS 8 SDK with Xcode 6
- fixes issues around registering/unregistering views that could cause a leak
- fixes a crash when switching between different Jot stylii
- fixes issues where JotTouch events could arrive out of order or multiple times
- fixes issues where stylii could disconnect unexpectedly
- fixes issues where palm rejection could interfere with gesture recognizers
- other miscellaneous bug fixes and improvements

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
- switch to standard #import <AdonitSDK/AdonitSDK.h> header style
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
- Fixed problem where battery status was not updating

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
