//
//  JotStatusIndicatorView.h
//  JotTouchExample
//
//  Copyright (c) 2014 Adonit, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JotStatusIndicatorView : UIView

@property (nonatomic,weak) IBOutlet UILabel* pressureLabel;
@property (nonatomic,weak) IBOutlet UISlider *scrollValue;
@property (nonatomic,weak) IBOutlet UILabel* stylusTapLabel;
@property (nonatomic,weak) IBOutlet UILabel* scrollValueLabel;
@property (nonatomic, weak) IBOutlet UILabel* aTapLabel;
@property (nonatomic, weak) IBOutlet UILabel* bTapLabel;
@property (nonatomic, weak) IBOutlet UILabel* scrollData;
@property (nonatomic, weak) IBOutlet UISwitch* altitudeAngleEnable;
@property (nonatomic, weak) IBOutlet UILabel* altitudeAngleLabel;
@property (nonatomic, weak) IBOutlet UILabel* platformLabel;
- (void) setActivityMessage:(NSString *)activityMessage;
- (void) setConnectedStylusModel:(NSString *)stylusModelName;
- (void) jotScrollUpdate:(float)value;
- (void) jotButton1Tap:(NSString *)text;
- (void) jotButton2Tap:(NSString *)text;
- (void) setPlatformLabel:(UILabel *)platformLabel;
@end
