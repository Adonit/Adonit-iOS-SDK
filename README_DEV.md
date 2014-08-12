## Developer Documentation

## [[JotStylusManager sharedInstance] setOptionValue:(id)value forKey:(NSString *)key]
This call is used to enable/disable some hidden stuff in the SDK
### net.adonit.enablePenDataNotification
- Defaults to NO.
- When set with a value of [NSNumber numberWithBool:YES] will cause each instance of stylus data to send a notification called "NewDataFromPen".  
- For the JT4 the value sent is a string of numbers delineated by \_'s.  The format is stylusPressure_pressureThreshold_stylusTipStatus.
- For the Jot Script the value sent has 4 values and is a string of numbers delineated by \_'s.  The format is stylusPressure_rawPressure_stylusTipStatus_txStatus (transmitter status on/off).

This notification is currently used in the PalmVisualizer utility app to power the sparklines and transmitter status box.
### net.adonit.enableTurnOffStylus
- Defaults to YES.
- When set with a value of [NSNumber numberWithBool:NO] will cause hte call to [[JotStylusManager sharedInstance] forgetAndTurnOffStylus] to not turn the stylus off.

### net.adonit.logAllOfTheTouchThings
- Defaults to NO.
- When set with a value of [NSNumber numberWithBool:YES] will cause EXTREMELY verbose logging from the sdk on all events that happen to a given UITouch event.

### net.adonit.logAllOfTheBTThings
- Defaults to NO.
- When set with a value of [NSNumber numberWithBool:YES] will cause EXTREMELY verbose logging from the sdk on all events that happen in the bluetooth and stylus stack.

### net.adonit.logAllOfTheThings
- Defaults to NO.
- When set with a value of [NSNumber numberWithBool:YES] will cause both BT and Touch logs to be logged.

## net.adonit.enableConsoleLogging
- Defaults to NO.
- see [JotDebugManager sharedInstance] for details
- When set with a value of [NSNumber numberWithBool:YES] will cause logs to go to the console as well as internal log.

## [JotDebugManager sharedInstance]
- All logs will be logged to a string called [JotDebugManager sharedInstance].verboseLogs.  Pause the execution with a breakpoint or hitting pause and you can print this out to the console.  
- [JotDebugManager sharedInstance].verboseLogs is limited to the last 100 log entries
- When verboseLogs fills up it is put into the array called [JotDebugManager sharedInstance].logFrames.  To see a particular frame of logs print out [JotDebugManager sharedInstance].logFrames[indexOfLogYouCareAbout].
- If you want all logs since execution started use [[JotDebugManager sharedInstance] getAllLogs] to get everything
- Use [[JotDebugManager sharedInstance] getLast:numberOfLogFramesBackYouWant]
