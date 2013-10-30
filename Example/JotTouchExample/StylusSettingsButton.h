//
//  StylusSettingsButton.h
//  JotTouchExample
//
//  A custom button with built in animation and state toggle
//
//  Created by Ian on 8/9/13.
//  Copyright (c) 2013 Adonit, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface StylusSettingsButton : UIButton

- (void) stylusIsConnected: (BOOL) connectedStylus;
- (void) animateStylusSettingButton: (BOOL) animate;


@end
