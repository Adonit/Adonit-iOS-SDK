//
//  JotTouchStatusHUD.m
//  JotTouchExample
//
//  Created by Ian on 8/12/13.
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

+ (void) ShowJotHUDInView: (UIView *) viewToDisplayIn isConnected: (BOOL) isConnected modelName: (NSString *) modelName
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

+(void) removeJotStatusHUD: (JotTouchStatusHUD *) HUDtoRemove;
{
    [HUDtoRemove removeFromSuperview];
    HUDtoRemove = nil;
}

+ (JotTouchStatusHUD *) returnJotTouchStatusHUDWithConnection: (BOOL) isConnected modelName: (NSString *) modeName
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


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
