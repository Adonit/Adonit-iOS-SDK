//
//  JotTouchStatusHUD.h
//  JotTouchExample
//
//  Created by Ian on 8/12/13.
//  Copyright (c) 2013 Adonit, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface JotTouchStatusHUD : UIView

@property BOOL monoChromeAlert;
@property BOOL textOnly;

@property CGFloat displayDuration; // in Seconds. Default is 2

+ (void) ShowJotHUDInView: (UIView *) viewToDisplayIn isConnected: (BOOL) isConnected modelName: (NSString *) modelName;

@end
