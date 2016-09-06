//
//  AdonitLIneWidthView.m
//  JotTouchExample
//
//  Copyright © 2016 Adonit, USA. All rights reserved.
//

#import "AdonitLineWidthView.h"

@implementation AdonitLineWidthView

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
    }
    return self;
}

- (void)setLineColor:(UIColor *)lineColor
{
    _lineColor = lineColor;
    [self setNeedsDisplay];
}

- (void)setLineSize:(CGFloat)lineSize
{
    _lineSize = lineSize;
    [self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGFloat LineStrokeSize = 2.0;
    CGContextSetLineWidth(context, LineStrokeSize);
    
    // inner circle
    CGContextSetFillColorWithColor(context, self.lineColor.CGColor);
    CGRect innerCircle = CGRectMake((self.bounds.size.width / 2.0) - (self.lineSize / 2.0), (self.bounds.size.height / 2.0) - (self.lineSize / 2.0), self.lineSize, self.lineSize);
    CGContextFillEllipseInRect(context, innerCircle);
    
    // outer circle
    CGContextSetStrokeColorWithColor(context, self.tintColor.CGColor);
    CGRect strokeRect = CGRectInset(self.bounds, (LineStrokeSize / 2.0) + 0.5, (LineStrokeSize / 2.0) + 0.5);
    CGContextStrokeEllipseInRect(context, strokeRect);
}

@end
