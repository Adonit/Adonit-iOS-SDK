# Adonit iOS SDK 3.1 Upgrade Notes

## New Pressure API
Pressure has been given a more simple 0.0 to 1.0 float value range with an Adonit calibrated pressure curve for simplicity and convenience. The raw pressure can still be accessed for creating custom pressure curves if needed. 
```
/*! A float between 0 and 1 indicating the pressure associated with the jotStroke, calculated from the raw pressure.
 */
@property (nonatomic, readonly) CGFloat pressure;

/*! The raw pressure associated with the jotStroke.
 */
@property (nonatomic, readonly) NSUInteger rawPressure;
```

## Altitude Angle with JotStrokes

Check with the JotStylusManager to see if what allitude capabilities the connected stylus has with the `stylusSupportsAltitudeAngle` and `minimumAltitudeAngleSupported` properties.
```
/**
 * Indicates whether the connected stylus supports a variable altitude angle.
 */
@property (readonly) BOOL stylusSupportsAltitudeAngle;

/**
 * The minimum achievable altitude angle of stylus. Lower angles can cause the styluses pressure sensor to no longer touch the screen. Use this measurement to map tilt effects across the styluses useable range, or as a way to determine if stylus can be used in a "tilt-to-shade" mode.
 */
@property (readonly) CGFloat minimumAltitudeAngleSupported;
```
Fetch the current `altitudeAngle` form a JotStroke object.

```
/*! A value of 0 radians indicates that the stylus is parallel to the surface; when the stylus is perpendicular to the surface, altitudeAngle is Pi/2.
    Styluses that do not support altitude angle (Such as Jot Script and Jot Touch 4) will return a value of Pi/4.
 */
@property (nonatomic, readonly) CGFloat altitudeAngle;
```

## Predictive JotStrokes

Enable and adjust predictive JotStrokes in the JotStylusManager using the `predictedJotStrokesEnabled` and `predictedJotStrokeLagMulitplier` properties.
```
/**
* Turn this on to enable predictedJotStrokes similar to predictedUITouches. Only available in iOS 9 and later. See JotStroke.h for more information.
*/
@property (readwrite) BOOL predictedJotStrokesEnabled;

/**
* Since the purpose of predicted strokes is to eliminate lag, this multiplier can be tweaked to apply the appropriate amount of prediction tuned to an apps specific drawing engine. The higher the number, the further out a predicted stroke will go. Ideally the prediction will get a stroke very close to the tip of a fast moving stylus without overshooting it. Default value is 1.75.
*/
@property (nonatomic, readwrite) CGFloat predictedJotStrokeLagMulitplier;
```

Retreive JotStrokes from the `predictedJotStrokes` property of a JotStroke object.
```

/*! An array of auxiliary JotStrokes for stroke events that are predicted to occur for a given main JotStroke. These predictions may not exactly match the real behavior of the stroke as the stylus moves, so they should be interpreted as an estimate. To enable predictedJotStrokes turn on "predictedJotStrokesEnabled" on an instance of JotStylusManager.
*/
@property (nonatomic, readonly) NSArray *predictedJotStrokes;
```

### DebugStatusViewController

We now offer a debug controller for diagnostic information on the connected stylus. While this is not intended to be used in a shipping app, it can help trouble shoot issues, and provide insight into how the hardware works.

```
//A view controller that can be used to show the hardware status for debugging purposes
extern NSString * const AdonitViewControllerDebugStatusIdentifier;
```

# Adonit iOS SDK 3.0 Upgrade Notes

Step 1: **Sending Events**  
Step 2: **Hook up Stylus Events**  

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