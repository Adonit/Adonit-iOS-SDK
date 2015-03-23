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

- (void)pulseStylusSettingsButton
{
    [UIView animateWithDuration:0.5 animations:^{
        self.imageView.transform = CGAffineTransformScale(self.imageView.transform, 0.5, 0.5);
    } completion:^(BOOL finished) {
        if (!finished) { return; }
        
        [UIView animateWithDuration:0.5 animations:^{
            self.imageView.transform = CGAffineTransformScale(self.imageView.transform, 1.0, 1.0);
        }];
    }];
}

@end
