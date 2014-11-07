# JotTouchSDK 2.6.4 Upgrade Notes

JotTouchSDK version 2.6.4 requires an additional system framework to be linked against your app. This new framework is the SystemConfiguration.framework, and is used by the SDK to detect when it can download updated configuration data for new iPad, iPhone and stylus hardware.

# JotTouchSDK 2.6 Upgrade Notes

Upgrading from any 2.5.x release should require no code changes on your part.

However, there is one new new option on JotStylusManager called reportDiagnosticData. Surfacing this option to your users will help us create better solutions and provide a better customer service experience to both of our customers. To learn more about what data is collected and how its used, please visit http://www.adonit.net/privacy-policy/#sdk.

# JotTouchSDK 2.5 Upgrade Notes

The 2.5 JotTouchSDK includes a few updates that will require changes to your code when moving to this release.

## New Header File

The 2.5 JotTouchSDK includes some cleanup to the header files, and introduces a more standard header file format. You can reference all the JotTouchSDK headers using the following import:

    #import <JotTouchSDK/JotTouchSDK.h>
    
If you see any compilation warnings about unknown class types, you may need to include this import in your files.

## Enabling and Disabling the SDK

The 2.5 JotTouchSDK no longer uses a property to enable or disable itself. Instead of using

    @property (nonatomic) BOOL enabled;

use the new methods

    - (void)enable;
    - (void)disable;

There is also a new method which enables or disables the JotStylusManager based on whether it was enabled or disabled when the application was last run.

    - (void)enableOrDisableBasedOnLastKnownState;

In addition, the SDK also lets you control whether or not the Bluetooth Power On Alert is shown by iOS when the SDK is enabled, but Bluetooth is turned off on the device.

    - (void)enableWithBluetoothPowerOnAlert:(BOOL)powerOnAlert;
    - (void)enableOrDisableBasedOnLastKnownStateWithBluetoothPowerOnAlert:(BOOL)powerOnAlert;

## No More Preferred Stylus

Previous versions of the SDK had a `preferredStylus` that has been removed. The SDK will now automatically reconnect to the last stylus, unless it has been told to forget it with either `disconnectStylus` or `forgetAndTurnOff`. You can access information about the currently connected stylus directly through new properties on the `JotStylusManager`.

## Writing Style NS_ENUM

Our JotWritingStyles have been renamed to be more descriptive. The integer values and how they work internally to our SDK have not changed, but the names better represent the relative stylus position.

    JotWritingStyleRightUp     -> JotWritingStyleRightVertical
    JotWritingStyleRightMiddle -> JotWritingStyleRightAverage
    JotWritingStyleRightDown   -> JotWritingStyleRightHorizontal
    JotWritingStyleLeftUp      -> JotWritingStyleLeftVertical
    JotWritingStyleLeftMiddle  -> JotWritingStyleLeftAverage
    JotWritingStyleLeftDown    -> JotWritingStyleLeftHorizontal

In order to maintain backward compatibility with existing user preferences, we have mapped the enums to the same values they represented before. However, we have rearranged the enumeration so that the entries correlate with the writing style images in the settings screen.

    typedef NS_ENUM(NSUInteger, JotWritingStyle) {
        JotWritingStyleRightHorizontal = 2,
        JotWritingStyleRightAverage = 1,
        JotWritingStyleRightVertical = 0,
    
        JotWritingStyleLeftHorizontal = 5,
        JotWritingStyleLeftAverage = 4,
        JotWritingStyleLeftVertical = 3,
    };

## Connection Style

One of the biggest changes in the 2.5 version of the SDK is the addition of a new press-and-hold connection style. This connection style will be the default going forward. You can set the connection style you wish to use with the `connectionType` property on `JotStylusManager`

    @property (readwrite, nonatomic) JotStylusConnectionType connectionType;

There are two current possible values:

    typedef NS_ENUM(NSUInteger, JotStylusConnectionType) {
        JotStylusConnectionTypeTap = 0,
        JotStylusConnectionTypePressAndHold
    };

`JotStylusConnectionTypeTap` is the legacy connection style where the SDK scans for all Jot Styli in the area, and the user taps the stylus they are using to connect. To use the legacy connection style, set the `connectionType` property before enabling the SDK:

    [JotStylusManager sharedInstance].connectionType = JotStylusConnectionTypeTap;

You can implement press-and-hold in your own application by using two new functions on `JotStylusManager`:

    - (void)startDiscoveryWithCompletionBlock:(JotStylusDiscoveryCompletionBlock)completionBlock;
    - (void)stopDiscovery;
    
Users connect a stylus with the press-and-hold method by pressing the stylus to a target in the application, and then holding it there while the SDK detects the device with pressure and pairs with it. One example of how you might implement this target behavior is by adding actions to a custom `UIView`:

    [self.targetView addTarget:self
                        action:@selector(targetDown:)
              forControlEvents:UIControlEventTouchDown];

    [self.targetView addTarget:self
                        action:@selector(targetUp:)
              forControlEvents:UIControlEventTouchUpInside];

and then implement those methods as follows:

    - (void)targetDown:(id)selector
    {
        [[JotStylusManager sharedInstance] startDiscoveryWithCompletionBlock:^(BOOL success, NSError *error) {
            NSLog(@"Stylus Connected");
        }];
    }

    - (void)targetUp:(id)selector
    {
        [[JotStylusManager sharedInstance] stopDiscovery];
    }

You need to make sure that you call the `stopDiscovery` method when you no longer want the SDK to scan for styli. When a stylus has been discovered, the callback will be invoked. If there is a problem with the discovery process, you may receive an error. For example, if you attempt to start discovery when the SDK is disabled.

## Smoothing Options

The `JotStylusManager` now has two optional settings to control whether the SDK does any line smoothing to correct for distorted points when using certain stylus and iOS device combinations. By default, the SDK will try to smooth points to correct for this distortion. You can disable this smoothing by using the following property on `JotStylusManager`:

    @property (nonatomic) BOOL lineSmoothingEnabled;

You can also control how much smoothing is applied using the property:

@property (nonatomic) double lineSmoothingStrength;

This takes a value from 0.0 to 1.0 and indicates how strongly the engine should try and smooth the lines. Higher values result in smoother lines, at the expense of detail when making sharp curves.

## New Settings View Controller

Along with the new default press-and-hold connection style, the SDK has a new settings view controller you can use in your own application. The prevous controller has been renamed, and is still available as `JotTapToConnectSettingsViewController`. Unlike previous versions, the new `JotSettingsViewController` is not in a `UINavigationController`. This allows you to embed the view controller in your own settings menu more easily. If you are using the `JotSettingsViewController` on its own, you will need to put it in a `UINavigationController` before showing it. For example:

    JotSettingsViewController *settings = [JotSettingsViewController settingsViewController];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:settings];
    popoverController = [[UIPopoverController alloc] initWithContentViewController:navController];
    [popoverController presentPopoverFromRect:[sender frame] inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];

In addition to the available `init...` methods, you can use the `settingsViewController` class method to create a new view controller, and set the on/off switch and palm rejection options using their respective properties on on `JotSettingsViewController`

    @property BOOL showOnOffSwitch;
    @property BOOL showPalmRejectionSwitch;
    
You can get a legacy settings view controller by using the `JotTapToConnectSettingsViewController`.

## JotPalmGestureRecognizer Integration [EXPERIMENTAL]

Previous versions of the SDK used the `JotPalmRejectionDelegate` in order to send updates to your application about when it was safe to allow gesture recognition. While we still send those notifications, in addition, we now support the Apple-supplied methods for chaining gesture recognizers together. The internal `JotPalmGestureRecognizer` will now attempt to disable other gesture recognizers if it detects a palm or stylus on the screen. It does this using the method:

    - (BOOL)shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer

You should not have to make any changes in your application. However, we have exposed the `JotPalmGestureRecognizer` class to framework clients so you can override the default behavior in your own gesture recognizers using the methods:

    - (BOOL)shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer;
    - (BOOL)shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer;
    - (BOOL)canBePreventedByGestureRecognizer:(UIGestureRecognizer *)preventingGestureRecognizer;
    - (BOOL)canPreventGestureRecognizer:(UIGestureRecognizer *)preventedGestureRecognizer;

Please let us know if you run into any issues with app-level gesture recognizers and this new interaction model.

## JotShortcut

The `JotShortcut` repeatRate has been changed to use the standard NSTimeInterval period of seconds. Previous versions used milliseconds. There is also a new property called `shortText` for storing a shortcut name appropriate for smaller labels.

## Accelerometer Data

There is a new `JotStylusMotionManager` class that provides accelerometer data from styli that support this capability (currently the Jot Script and forthcoming Jot Touch Pixel Point). You can access this object on the `JotStylusManager`:

    @property (readonly) JotStylusMotionManager *jotStylusMotionManager

You can check to see whether accelerometer data is available from the current device with the `isAccelerometerAvailable` property:

    @property (readonly, nonatomic, getter=isAccelerometerAvailable) BOOL accelerometerAvailable;
    
The `JotStylusMotionManager` closely follows the CoreMotion API design where possible. You can receive accelerometer updates using the methods:

    - (void)startAccelerometerUpdatesToQueue:(NSOperationQueue *)queue withHandler:(JotStylusAccelerometerHandler)handler;
    - (void)stopAccelerometerUpdates;
      
When accelerometer updates come in from a stylus, the handler will be called using the provided queue with the latest accelerometer data. You can limit how fast these updates are called using the `accelerometerUpdateInterval` property:

    @property (nonatomic) NSTimeInterval accelerometerUpdateInterval;
    
Setting this to a time interval shorter than the rate at which accelerometer data is updated from the device has no effect.
