//
//  JotTouchStatusHUD.m
//  JotTouchExample
//
//  Copyright (c) 2013 Adonit, LLC. All rights reserved.
//

#import "JotTouchStatusHUD.h"

#define HUD_DISPLAY_DURATION 2.0
#define HUD_WIDTH 178
#define HUD_HEIGHT 85
#define LABEL_HEIGHT HUD_HEIGHT
#define LABEL_FONT_SIZE 18
#define LABEL_PADDING 8

#ifdef __IPHONE_6_0
# define ALIGN_CENTER NSTextAlignmentCenter
#else
# define ALIGN_CENTER UITextAlignmentCenter
#endif

@implementation JotTouchStatusHUD

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        self.layer.cornerRadius = 6.0;
        self.layer.borderWidth = 2.0;
        self.layer.borderColor = [UIColor blackColor].CGColor;
        
        // Background View
        UIView *backgroundView = [[UIView alloc]initWithFrame:frame];
        backgroundView.backgroundColor = [UIColor blackColor];
        backgroundView.alpha = 0.80;
        backgroundView.layer.cornerRadius = 6.0;
        [self addSubview:backgroundView];
        
        self.userInteractionEnabled = NO;
    }
    return self;
}

+ (void)showJotHUDInView:(UIView *)viewToDisplayIn isConnected:(BOOL) isConnected modelName:(NSString *) modelName
{
    // First check to see if there is an old HUD to remove so that new message does not overlap
    for (JotTouchStatusHUD *HUDtoRemove in viewToDisplayIn.subviews)
    {
        // Make sure it is a JotTouchStatusHUD we remove
        if ([HUDtoRemove isKindOfClass:[JotTouchStatusHUD class]])
        {
            [[JotTouchStatusHUD class] removeJotStatusHUD:HUDtoRemove];
        }
    }

    JotTouchStatusHUD *HUDToDisplay = [self returnJotTouchStatusHUDWithConnection:isConnected modelName:modelName];
    CGSize MainFrame = viewToDisplayIn.bounds.size;
    CGPoint center = CGPointMake((MainFrame.width / 2 - (HUD_WIDTH / 2)) , (MainFrame.height / 2) - (HUD_HEIGHT / 2));

    HUDToDisplay.frame = CGRectMake(center.x, center.y, HUDToDisplay.frame.size.width, HUDToDisplay.frame.size.height);

    [viewToDisplayIn addSubview:HUDToDisplay];

    double delayInSeconds = HUD_DISPLAY_DURATION;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [[JotTouchStatusHUD class]removeJotStatusHUD:HUDToDisplay];
    });

}

+ (void)showJotHUDInView:(UIView *)viewToDisplayIn topLineMessage:(NSString *)topLineMessage bottomeLineMessage:(NSString *)bottomLineMessage
{
    // First check to see if there is an old HUD to remove so that new message does not overlap
    for (JotTouchStatusHUD *HUDtoRemove in viewToDisplayIn.subviews)
    {
        // Make sure it is a JotTouchStatusHUD we remove
        if ([HUDtoRemove isKindOfClass:[JotTouchStatusHUD class]])
        {
            [[JotTouchStatusHUD class] removeJotStatusHUD:HUDtoRemove];
        }
    }

    JotTouchStatusHUD *HUDToDisplay = [self returnJotTouchStatusHUDWithTopLineMessage:topLineMessage bottomeLineMessage:bottomLineMessage];

//    [viewToDisplayIn addSubview:HUDToDisplay];
//    
//    [self AddCenterConstraintsForHUDView:HUDToDisplay superView:viewToDisplayIn];
//    
//    
//    double delayInSeconds = HUD_DISPLAY_DURATION;
//    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
//    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//        [[JotTouchStatusHUD class]removeJotStatusHUD:HUDToDisplay];
//    });
    CGSize MainFrame = viewToDisplayIn.bounds.size;
    CGPoint center = CGPointMake((MainFrame.width / 2 - (HUD_WIDTH / 2)) , (MainFrame.height / 2) - (HUD_HEIGHT / 2));

    HUDToDisplay.frame = CGRectMake(center.x, center.y, HUDToDisplay.frame.size.width, HUDToDisplay.frame.size.height);

    [viewToDisplayIn addSubview:HUDToDisplay];

    double delayInSeconds = HUD_DISPLAY_DURATION;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [[JotTouchStatusHUD class]removeJotStatusHUD:HUDToDisplay];
    });


}

+ (void)AddCenterConstraintsForHUDView:(JotTouchStatusHUD *)HUD superView:(UIView *)superView
{
    [HUD setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSLayoutConstraint* cn = [NSLayoutConstraint constraintWithItem:HUD
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:superView
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.0
                                                           constant:0];
    [superView addConstraint:cn];

    cn = [NSLayoutConstraint constraintWithItem:HUD
                                      attribute:NSLayoutAttributeCenterY
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:superView
                                      attribute:NSLayoutAttributeCenterY
                                     multiplier:1.0 / 3.0
                                       constant:0];
    [superView addConstraint:cn];

    cn = [NSLayoutConstraint constraintWithItem:HUD
                                      attribute:NSLayoutAttributeHeight
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:nil
                                      attribute:NSLayoutAttributeNotAnAttribute
                                     multiplier:1
                                       constant:HUD_HEIGHT];
    [HUD addConstraint:cn];

    cn = [NSLayoutConstraint constraintWithItem:HUD
                                      attribute:NSLayoutAttributeWidth
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:nil
                                      attribute:NSLayoutAttributeNotAnAttribute
                                     multiplier:1
                                       constant:HUD_WIDTH];
    [HUD addConstraint: cn];
}

+ (void)removeJotStatusHUD:(JotTouchStatusHUD *)HUDtoRemove;
{
    [HUDtoRemove removeFromSuperview];
    HUDtoRemove = nil;
}

+ (JotTouchStatusHUD *)returnJotTouchStatusHUDWithTopLineMessage:(NSString *)topLineMessage bottomeLineMessage:(NSString *)bottomLineMessage
{
    CGRect HUDframe = CGRectMake(0, 0, HUD_WIDTH, HUD_HEIGHT);
    JotTouchStatusHUD *theHUD = [[JotTouchStatusHUD alloc]initWithFrame:HUDframe];

    NSInteger numberOfLines = 2;
    NSString *statusText;

    if (bottomLineMessage && ![bottomLineMessage isEqualToString:@""]) {
        statusText = [NSString stringWithFormat:@"%@\n%@", topLineMessage, bottomLineMessage];
    } else {
        numberOfLines = 1;
        statusText = [NSString stringWithFormat:@"%@", topLineMessage];
    }

    // HUD Title Text
    CGRect bottomLabelFrame = CGRectMake(LABEL_PADDING, LABEL_PADDING, HUD_WIDTH - LABEL_PADDING * 2.0, LABEL_HEIGHT - LABEL_PADDING * 2.0);
    UILabel *connectionLabel = [[UILabel alloc]initWithFrame:bottomLabelFrame];
    connectionLabel.text = statusText;
    [connectionLabel setTextAlignment: ALIGN_CENTER];
    connectionLabel.font = [UIFont boldSystemFontOfSize:LABEL_FONT_SIZE];
    connectionLabel.textColor = [UIColor whiteColor];
    connectionLabel.adjustsFontSizeToFitWidth = YES;
    connectionLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    connectionLabel.shadowColor = [UIColor blackColor];
    connectionLabel.shadowOffset = CGSizeMake(0, -1);
    connectionLabel.numberOfLines = numberOfLines;
    connectionLabel.backgroundColor = [UIColor clearColor];

    [theHUD addSubview:connectionLabel];

    return theHUD;
}

+ (JotTouchStatusHUD *)returnJotTouchStatusHUDWithConnection:(BOOL)isConnected modelName:(NSString *)modeName
{
    CGRect HUDframe = CGRectMake(0, 0, HUD_WIDTH, HUD_HEIGHT);
    JotTouchStatusHUD *theHUD = [[JotTouchStatusHUD alloc]initWithFrame:HUDframe];

    // Connection Status Variables
    NSString *connectionStatusText;
    //NSString *connectionStatusImageName;

    if (isConnected) {
        connectionStatusText = [NSString stringWithFormat:@"%@\nConnected", modeName];
        //connectionStatusImageName = @"JotConnected";
    }
    else {
        connectionStatusText = [NSString stringWithFormat: @"%@\nDisconnected", modeName];
        //connectionStatusImageName = @"JotDisconnected";
    }

    // HUD Title Text
    CGRect bottomLabelFrame = CGRectMake(LABEL_PADDING, LABEL_PADDING, HUD_WIDTH - LABEL_PADDING * 2.0, LABEL_HEIGHT - LABEL_PADDING * 2.0);
    UILabel *connectionLabel = [[UILabel alloc]initWithFrame:bottomLabelFrame];
    connectionLabel.text = connectionStatusText;
    [connectionLabel setTextAlignment: ALIGN_CENTER];
    connectionLabel.font = [UIFont boldSystemFontOfSize:LABEL_FONT_SIZE];
    connectionLabel.textColor = [UIColor whiteColor];
    connectionLabel.adjustsFontSizeToFitWidth = YES;
    connectionLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    connectionLabel.shadowColor = [UIColor blackColor];
    connectionLabel.shadowOffset = CGSizeMake(0, -1);
    connectionLabel.numberOfLines = 2;
    connectionLabel.backgroundColor = [UIColor clearColor];

    [theHUD addSubview:connectionLabel];

    return theHUD;
}

@end
