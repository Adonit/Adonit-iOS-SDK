//
//  PressToConnectViewController.h
//
//  Copyright (c) 2017 Adonit. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PressToConnectViewController;
@protocol PressToConnectViewControllerDelegate <NSObject>

@optional

- (void)pressToConnectControllerDidBeginConnectionAttempt:(PressToConnectViewController *)controller;
- (void)pressToConnectControllerDidEndConnectionAttempt:(PressToConnectViewController *)controller;

@end

@interface PressToConnectViewController : UIViewController




@property (weak, nonatomic) IBOutlet UIView *pressToConnectView;
@property (weak, nonatomic) IBOutlet UILabel *connectionInstructionLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *targetToLabelHorizontalSpaceConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelWidthConstraint;
@property (weak, nonatomic) id<PressToConnectViewControllerDelegate> delegate;

@end
