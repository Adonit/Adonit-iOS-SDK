//
//  AdonitVerticalSliderView.h
//  JotTouchExample
//
//  Copyright © 2016 Adonit, USA. All rights reserved.
//

#import <UIKit/UIKit.h>
IB_DESIGNABLE

@interface AdonitVerticalSliderView : UIView

@property IBInspectable UIColor *verticalColor;
@property IBInspectable (nonatomic) UIColor *sliderColor;
@property IBInspectable CGFloat sliderTrackThickness;
@property IBInspectable CGFloat verticalSliderHeight;
@property IBInspectable CGFloat verticalSliderWidth;

@property IBInspectable (nonatomic) CGFloat maxSliderValue;
@property IBInspectable (nonatomic) CGFloat minSliderValue;
@property IBInspectable (nonatomic) CGFloat currentSliderValue;

- (CGFloat)itemValueAfternAdjustingByAmount:(CGFloat)adjustmentAmount;

@end
