//
//  AdonitVerticalSliderView.m
//  JotTouchExample
//
//  Copyright © 2016 Adonit, USA. All rights reserved.
//

#import "AdonitVerticalSliderView.h"

@interface AdonitVerticalSliderView()
@property NSDictionary *textFontAttributes;

@end

@implementation AdonitVerticalSliderView

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

- (NSDictionary *)textDictionary
{
    if (!_textFontAttributes) {
        NSMutableParagraphStyle* textStyle = NSMutableParagraphStyle.defaultParagraphStyle.mutableCopy;
        textStyle.alignment = NSTextAlignmentCenter;
        _textFontAttributes = @{NSFontAttributeName: [UIFont fontWithName: @"Helvetica" size:6.0], NSForegroundColorAttributeName: UIColor.blackColor, NSParagraphStyleAttributeName: textStyle};
    }
    
    return _textFontAttributes;
}

- (void)setMaxSliderValue:(CGFloat)maxSliderValue
{
    _maxSliderValue = maxSliderValue;
    [self setNeedsDisplay];
}

- (void)setMinSliderValue:(CGFloat)minSliderValue
{
    _minSliderValue = minSliderValue;
    [self setNeedsDisplay];
}

- (void)setCurrentSliderValue:(CGFloat)currentSliderValue
{
    _currentSliderValue = currentSliderValue;
    [self setNeedsDisplay];
}

- (void)setSliderColor:(UIColor *)sliderColor
{
    _sliderColor = sliderColor;
    [self setNeedsDisplay];
}

- (CGFloat)dyamicDampeningForMinValue:(CGFloat)minValue MaxValue:(CGFloat)maxValue
{
    CGFloat rangeOfScrollSensor = 255.0;
    CGFloat adjustmentRange = maxValue - minValue;
    CGFloat speedAdjustment = 0.75; // lower the less movement needed.
    
    CGFloat dampeningAmount = ((adjustmentRange * speedAdjustment)/ rangeOfScrollSensor);
    return dampeningAmount;
}

- (CGFloat)itemValueAfternAdjustingByAmount:(CGFloat)adjustmentAmount
{
    adjustmentAmount = adjustmentAmount * [self dyamicDampeningForMinValue:self.minSliderValue MaxValue:self.maxSliderValue];
    
    CGFloat newValue = self.currentSliderValue;
    newValue += adjustmentAmount;

    newValue = MAX(newValue, self.minSliderValue);
    newValue = MIN(newValue, self.maxSliderValue);
    
    self.currentSliderValue = newValue;
    
    return newValue;
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Draw Vertical Track
    CGContextSetFillColorWithColor(context, self.verticalColor.CGColor);
    CGRect verticalTrackRect = CGRectMake(CGRectGetMidX(self.bounds) - (self.sliderTrackThickness / 2.0), self.bounds.origin.y, self.sliderTrackThickness, self.bounds.size.height);
    CGContextFillRect(context, verticalTrackRect);
    
    // Draw Horizontal Slider
    CGFloat currentHeightPercentage = (self.currentSliderValue - self.minSliderValue) / ( self.maxSliderValue - self.minSliderValue);
    CGFloat sliderHeight = self.bounds.origin.y + (self.bounds.size.height * (1.0 - currentHeightPercentage));
    CGRect sliderRect = CGRectMake(CGRectGetMidX(self.bounds) - (self.verticalSliderWidth / 2.0), sliderHeight - (self.verticalSliderHeight / 2.0), self.verticalSliderWidth, self.verticalSliderHeight);
    CGContextSetFillColorWithColor(context, self.sliderColor.CGColor);
    CGContextFillRect(context, sliderRect);
    
    // Write current value
    NSString *text = [NSString stringWithFormat:@"%.3g", self.currentSliderValue];
    CGFloat textHeight = 10.0;
    CGFloat yTextOrigin = CGRectGetMinY(sliderRect) - (sliderRect.size.height + textHeight);
    if (sliderHeight < (textHeight + 4.0)) {
        yTextOrigin = yTextOrigin + textHeight + sliderRect.size.height + 3.0;
    }
    
    CGRect textRect = CGRectMake(self.bounds.origin.x, yTextOrigin, self.bounds.size.width, textHeight);
    [text drawInRect:textRect withAttributes:self.textFontAttributes];
}


@end
