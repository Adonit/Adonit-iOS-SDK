# Adonit iOS SDK 3.0 Upgrade Notes

step 1: Sending Events

step 2: Hook up Stylus Events

## Sending Events

The first integration point is to make sure events are being delivered to the new `AdonitTouchTypeIdentifier` engine, which is used to detect stylus as early in the event delivery flow as possible. The easiest way to do this is to subclass `JotDrawingApplication`, which includes built-in support for this event delivery. In your `main.m`, replace the normal call to `UIApplicationMain` with:

```
#import <AdonitSDK/AdonitSDK.h>

int main(int argc, char *argv[])
{
	@autoreleasepool {
		return UIApplicationMain(argc, argv, NSStringFromClass([JotDrawingApplication class]), NSStringFromClass([AppDelegate class]));
	}
}
```
If you do not want to subclass `JotDrawingApplication`, you can implement your own event delivery in your own `UIApplication` subclass by overriding the `sendEvent` method. Below is the code used in `JotDrawingApplication`.

```
#import "JotDrawingApplication.h"
#import "AdonitTouchTypeIdentifier.h"
#import "JotStylusManager.h"

@interface JotDrawingApplication ()

@property (nonatomic) AdonitTouchTypeIdentifier *touchTypeIdentifier;

@end

@implementation JotDrawingApplication

- (AdonitTouchTypeIdentifier *)touchTypeIdentifier
{
	if (!_touchTypeIdentifier) {
		_touchTypeIdentifier = [JotStylusManager sharedInstance].touchTypeIdentifier;
	}

	return _touchTypeIdentifier;
}

- (void)sendEvent:(UIEvent *)event
{
	[self.touchTypeIdentifier classifyAdonitDeviceIdentificationForEvent:event];
	[super sendEvent:event];
}

@end
```
The critical code is to make sure you call `classifyAdonitDeviceIdentificationForEvent:` before `super`'s `sendEvent:`.

## Hookup Stylus Events

`[[JotStylusManager sharedInstance] enable];`

Most of the stylus integration from this point on is similar to 2.7 of our SDK, but we have changed some names to more closely reflect the purpose and function of our SDK.

`JotPalmRejectionDelegate` ->                                 `jotStrokeDelegate`

`[JotStylusManager sharedInstance].palmRejectorDelegate` ->   `[JotStylusManager sharedInstance].jotStrokeDelegate`

`JotTouch` object ->                                          `JotStroke` object

Similar to the renaming to `JotStroke` Objects and a `JotStrokeDelegate`, the delegate events with stylus information have also been renamed.

`jotStylusTouchBegan:` ->                                     `jotStylusStrokeBegan:`
`jotStylusTouchMoved:` ->                                     `jotStylusStrokeMoved:`
`jotStylusTouchEnded:` ->                                     `jotStylusStrokeEnded:`
`jotStylusTouchCancelled:` ->                                 `jotStylusStrokeCancelled:`

Also note, that these stylus events now directly provide the stroke object, instead of embedding them within an `NSSet` object.

`- (void)jotStylusStrokeBegan:(nonnull JotStroke *)stylusStroke;`
`- (void)jotStylusStrokeMoved:(nonnull JotStroke *)stylusStroke;`
`- (void)jotStylusStrokeEnded:(nonnull JotStroke *)stylusStroke;`
`- (void)jotStylusStrokeCancelled:(nonnull JotStroke *)stylusStroke;`

# JotTouchSDK 2.7 Upgrade Notes

The Settings UI is now more modular and customizable than ever. See the [Connection and Settings UI Guide](https://github.com/Adonit/JotTouchSDK/wiki/Connection-and-Settings-UI-Guide) for more information on how to take advantage of this new settings UI.

The Tap to Connect connection style has been removed. All applications should use the Press to Connect connection style.

Several parts of JotTouch have been deprecated. See the inline deprecation suggestions on how to migrate away from those pieces of API.

# JotTouchSDK 2.6.5 Upgrade Notes

For applications that were previously turning off our wavy-line correction by setting the lineSmoothingEnabled property to NO, please consider trying this correction method again. We've made substantial improvements to writing and drawing clarity with the wavy-line correction on.

Also note that the Tap To Connect connection style will be removed in future versions of the SDK. Please transition to the Press To Connect connection style.

# JotTouchSDK 2.6.4 Upgrade Notes

JotTouchSDK version 2.6.4 requires an additional system framework to be linked against your app. This new framework is the SystemConfiguration.framework, and is used by the SDK to detect when it can download updated configuration data for new iPad, iPhone and stylus hardware.

# JotTouchSDK 2.6 Upgrade Notes

Upgrading from any 2.5.x release should require no code changes on your part.

However, there is one new new option on JotStylusManager called reportDiagnosticData. Surfacing this option to your users will help us create better solutions and provide a better customer service experience to both of our customers. To learn more about what data is collected and how its used, please visit http://www.adonit.net/privacy-policy/#sdk.