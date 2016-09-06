//
//  AdonitPrototypeOverlayViewController.h
//  JotTouchExample
//
//  Copyright © 2016 Adonit, USA. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    Overlay_Mode_Adjustment,
    Overlay_Mode_Selection
} OverlayMode;

typedef enum {
    Scroll_Interaction_Focus_Size,
    Scroll_Interaction_Focus_Color,
    Scroll_Interaction_Focus_Tool_Switch,
    SCroll_Interaction_Focus_Color_Switch
}ScrollInteractionFocus;

@interface AdonitPrototypeOverlayViewController : UIViewController

@property (nonatomic) OverlayMode currentOverlayMode;
@property (nonatomic) ScrollInteractionFocus currentScrollInteractionFocus;

@property (nonatomic) NSInteger selectedColorIndex;
@property (nonatomic) NSInteger selectedToolIndex;

// Brush size and Color

- (void)setBrushSize:(CGFloat)size minSize:(CGFloat)minSize maxSize:(CGFloat)maxSize;
- (void)setBrushColor:(UIColor *)color currentOpacity:(CGFloat)currentOpacity minValue:(CGFloat)minValue maxValue:(CGFloat)maxValue;

- (CGFloat)brushSizeAfternAdjustingByAmount:(CGFloat)adjustmentAmount;
- (CGFloat)brushOpacityAfterAdjustingByAmount:(CGFloat)adjustmentAmount;

// Tool and Color Select
+ (CGSize)selectionViewSizeForNumberOfItems:(NSInteger)numberOfItems;
- (void)setToolUnselectedViews:(NSArray *)unselectedViews selectedViews:(NSArray *)selectedViews;
- (void)setColorUnselectedViews:(NSArray *)unselectedViews selectedViews:(NSArray *)selectedViews;

- (NSInteger)toolSelectedAfterAdjustingByAmount:(CGFloat)adjustmentAmount;
- (NSInteger)colorSelectedAfterAdjustingByAmount:(CGFloat)adjustmentAmount;

@end
