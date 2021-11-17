//
//  AdonitRadiusView.m
//  JotTouchExample
//
//  Created by Ian Busch on 11/30/15.
//  Copyright © 2015 Adonit, USA. All rights reserved.
//

#import "AdonitRadiusView.h"
#import "AdonitSDK.h"

@interface AdonitRadiusView()
@property UILabel *radiusSizeLabel;
@property UILabel *pressureLabel;
@property CGFloat radiusSize;
@end

@implementation AdonitRadiusView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.radiusSizeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, -20, 280, 20)];
        self.pressureLabel = [[UILabel alloc]initWithFrame:CGRectMake(-30, -70, 280, 20)];
        [self addSubview:self.radiusSizeLabel];
        [self addSubview:self.pressureLabel];
        [self.radiusSizeLabel setFont:[UIFont systemFontOfSize:10]];
        [self.pressureLabel setFont:[UIFont systemFontOfSize:10]];
        self.layer.borderWidth = 1.0;
        [self setColor:[[UIColor lightGrayColor] colorWithAlphaComponent:0.25]];
        self.clipsToBounds = NO;
        self.userInteractionEnabled = NO;
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setColor:(UIColor *)color
{
    self.layer.borderColor = color.CGColor;
    [self.radiusSizeLabel setTextColor:color];
    [self.pressureLabel setTextColor:color];
}

- (UIColor *)colorForTouch:(UITouch *)touch
{
    UIColor *colorToReturn;
    
    switch (touch.adonitTouchIdentification) {
        case AdonitTouchIdentificationTypeUnknown:
        colorToReturn = [[UIColor darkGrayColor]colorWithAlphaComponent:0.35];
        break;
        
        case AdonitTouchIdentificationTypePotentialDevice:
        colorToReturn = [[UIColor orangeColor]colorWithAlphaComponent:0.80];
        break;
        
        case AdonitTouchIdentificationTypeStylus:
        colorToReturn = [[UIColor redColor]colorWithAlphaComponent:0.75];
        break;
        
        case AdonitTouchIdentificationTypeNotDevice:
        colorToReturn = [[UIColor blueColor]colorWithAlphaComponent:0.5];
        break;
        
        case AdonitTouchIdentificationTypeDebugPlaceholder:
        colorToReturn = [[UIColor purpleColor]colorWithAlphaComponent:0.5];
        break;
        
        default:
        colorToReturn = [[UIColor lightGrayColor]colorWithAlphaComponent:0.25];
        break;
    }
    return colorToReturn;
}

- (void)updateViewWithTouch:(UITouch *)touch
{
    CGFloat radiusSizeMultiplier = 10.0;
    [self setColor:[self colorForTouch:touch]];
    
    if (touch.phase != UITouchPhaseEnded && touch.phase != UITouchPhaseCancelled) {
        CGFloat tolerance = touch.majorRadiusTolerance;
        if (tolerance == 0) { tolerance = 1.0; }
        self.radiusSize = touch.majorRadius / tolerance;
        self.radiusSizeLabel.text = [NSString stringWithFormat:@"R/T: %.4g , timestamp: %f", self.radiusSize,touch.timestamp];
        
        [UIView animateWithDuration:0.05 animations:^{
            self.frame = self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.radiusSize * radiusSizeMultiplier, self.radiusSize * radiusSizeMultiplier);
            self.layer.cornerRadius = (self.radiusSize * radiusSizeMultiplier) / 2.0;
        }];

    }
   
    self.center = [touch locationInView:self.superview];
}

- (void)updateViewWithJotStroke:(JotStroke *)stylusStroke
{
    for (JotStroke *coalescedJotStroke in stylusStroke.coalescedJotStrokes) {
        CGFloat radiusSizeMultiplier = 10.0;
        [self setColor:[[UIColor redColor]colorWithAlphaComponent:0.75]];

        self.pressureLabel.text = [NSString stringWithFormat:@"rawPressure: %4lu , timpstamp: %f", (unsigned long)coalescedJotStroke.rawPressure, coalescedJotStroke.timestamp];

        [UIView animateWithDuration:0.05 animations:^{
            self.frame = self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.radiusSize * radiusSizeMultiplier, self.radiusSize * radiusSizeMultiplier);
            self.layer.cornerRadius = (self.radiusSize * radiusSizeMultiplier) / 2.0;
        }];

        self.center = [coalescedJotStroke locationInView:self.superview];

    }
}

@end
