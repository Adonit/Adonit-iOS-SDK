//
//  StylusSettingsButton.m
//  JotTouchExample
//
//  Created by Ian on 8/9/13.
//  Copyright (c) 2013 Adonit, LLC. All rights reserved.
//

#import "StylusSettingsButton.h"

@interface StylusSettingsButton ()
@property BOOL animationActive;
@end

@implementation StylusSettingsButton

-(void) setupStylusButton
{
    // Properties to support rotate animation
    self.imageView.clipsToBounds = NO;
    self.imageView.contentMode = UIViewContentModeCenter;
    
    // set default background image
    [self stylusIsConnected:NO];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setupStylusButton];
    }
    return self;
}

-(void) stylusIsConnected:(BOOL)connectedStylus
{
    NSString *backgroundName;
    
    if (connectedStylus) backgroundName = @"button-StylusConnected.png";
    else backgroundName = @"button-StylusDisconnected.png";
    
    [self setBackgroundImage:[UIImage imageNamed:backgroundName] forState:UIControlStateNormal];
}

-(void) animateStylusSettingButton:(BOOL)animate
{
    if (animate && !self.animationActive)
    {
        self.animationActive = YES;
        
        [UIView animateWithDuration:8.0
                              delay:0.0
                            options:UIViewAnimationOptionRepeat | UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveLinear
                         animations:^{ self.imageView.transform = CGAffineTransformRotate(self.imageView.transform, M_PI - 0.001);}
                         completion:^(BOOL finished){ if(! finished) return;
                         }];
        
           }
    
    if (!animate)
    {
        self.animationActive = NO;
        [self.imageView.layer removeAllAnimations];
    }
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
