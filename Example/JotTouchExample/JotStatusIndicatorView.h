//
//  JotStatusIndicatorView.h
//  JotTouchExample
//
//  Created by Ian Busch on 8/5/14.
//  Copyright (c) 2014 Adonit, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JotStatusIndicatorView : UIView

@property (nonatomic, weak) IBOutlet UILabel* pressureLabel;

- (void) setActivityMessage:(NSString *)activityMessage;
- (void) setConnectedStylusModel:(NSString *)stylusModelName;

@end
