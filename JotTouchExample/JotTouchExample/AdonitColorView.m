//
//  AdonitColorView.m
//  JotTouchExample
//
//  Copyright © 2016 Adonit, USA. All rights reserved.
//

#import "AdonitColorView.h"

@implementation AdonitColorView

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
    }
    return self;
}

- (void)setFillColor:(UIColor *)fillColor
{
    _fillColor = fillColor;
    [self setNeedsDisplay];
}

- (void)setOpacity:(CGFloat)opacity
{
    _opacity = opacity;
    [self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGFloat LineStrokeSize = 2.5;
    CGContextSetLineWidth(context, LineStrokeSize);
    CGRect strokeRect = CGRectInset(self.bounds, (LineStrokeSize / 2.0) - 0.5, (LineStrokeSize / 2.0) - 0.5);
    
    // Fill
    CGContextSetFillColorWithColor(context, [self.fillColor colorWithAlphaComponent:self.opacity].CGColor);
    CGRect fillRect = CGRectInset(strokeRect, (LineStrokeSize / 2.0), (LineStrokeSize / 2.0));
    CGContextFillRect(context, fillRect);
    
    //Stroke
    CGContextSetStrokeColorWithColor(context, self.tintColor.CGColor);
    CGContextStrokeRect(context, strokeRect);
}

@end
