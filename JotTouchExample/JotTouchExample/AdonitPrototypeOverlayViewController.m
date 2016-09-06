//
//  AdonitPrototypeOverlayViewController.m
//  JotTouchExample
//
//  Copyright © 2016 Adonit, USA. All rights reserved.
//

#import "AdonitPrototypeOverlayViewController.h"
#import "AdonitLineWidthView.h"
#import "AdonitColorView.h"
#import "AdonitVerticalSliderView.h"
#import "AdonitSelectionView.h"

@interface AdonitPrototypeOverlayViewController()
@property (weak, nonatomic) IBOutlet AdonitLineWidthView *brushSizeView;
@property (weak, nonatomic) IBOutlet AdonitColorView *brushColorView;
@property (weak, nonatomic) IBOutlet AdonitVerticalSliderView *colorSlider;
@property (weak, nonatomic) IBOutlet AdonitVerticalSliderView *sizeSlider;

@property (weak, nonatomic) IBOutlet UILabel *tapButton1Label;
@property (weak, nonatomic) IBOutlet UILabel *tapButton2Label;

@property AdonitSelectionView *colorSelectionView;
@property AdonitSelectionView *toolSelectionView;

@end

@implementation AdonitPrototypeOverlayViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    self.view.layer.cornerRadius = 5.0;
}

- (void)viewWillAppear:(BOOL)animated
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        self.currentOverlayMode = Overlay_Mode_Selection;
    });
}

- (void)ConfigureView
{
  
}

#pragma mark - Adjustments
- (NSInteger)toolSelectedAfterAdjustingByAmount:(CGFloat)adjustmentAmount
{
    return [self.toolSelectionView idexOfItemSelectedAfterAdjustingByAmount:adjustmentAmount];
}

- (NSInteger)colorSelectedAfterAdjustingByAmount:(CGFloat)adjustmentAmount
{
    return [self.colorSelectionView idexOfItemSelectedAfterAdjustingByAmount:adjustmentAmount];
}

- (void)setSelectedColorIndex:(NSInteger)selectedColorIndex
{
    self.colorSelectionView.selectedViewIndex = selectedColorIndex;
    _selectedColorIndex = selectedColorIndex;
}

- (void)setSelectedToolIndex:(NSInteger)selectedToolIndex
{
    self.toolSelectionView.selectedViewIndex = selectedToolIndex;
    _selectedToolIndex = selectedToolIndex;
}

- (void)setCurrentScrollInteractionFocus:(ScrollInteractionFocus)currentScrollInteractionFocus
{
    _currentScrollInteractionFocus = currentScrollInteractionFocus;
    
    switch (currentScrollInteractionFocus) {
        case Scroll_Interaction_Focus_Color:
        {
            [self showOpacityAdjust:YES];
            [self showSizeAdjust:NO];
            [self showToolSelect:NO];
            [self showColorSelect:NO];
        }
            break;
            
        case Scroll_Interaction_Focus_Size:
        {
            [self showSizeAdjust:YES];
            [self showOpacityAdjust:NO];
            [self showToolSelect:NO];
            [self showColorSelect:NO];
        }
            break;
       
        case Scroll_Interaction_Focus_Tool_Switch:
        {
            [self showToolSelect:YES];
            [self showColorSelect:NO];
            [self showSizeAdjust:NO];
            [self showOpacityAdjust:NO];
         
        }
            break;
            
        case SCroll_Interaction_Focus_Color_Switch:
        {
            [self showColorSelect:YES];
            [self showToolSelect:NO];
            [self showSizeAdjust:NO];
            [self showOpacityAdjust:NO];
        }
            break;
            
        default:
            break;
    }
}

- (void)showOpacityAdjust:(BOOL)show
{
    if (show) {
        self.colorSlider.sliderColor = [UIColor redColor];
        self.tapButton2Label.hidden = NO;
        self.colorSlider.alpha = 1.0;
        self.brushColorView.alpha = 1.0;
    } else {
        self.tapButton2Label.hidden = YES;
        self.colorSlider.alpha = 0.0;
        self.brushColorView.alpha = 0.0;
    }
}

- (void) showSizeAdjust:(BOOL)show
{
    if (show) {
        self.sizeSlider.sliderColor = [UIColor redColor];
        self.tapButton1Label.hidden = NO;
        self.sizeSlider.alpha = 1.0;
        self.brushSizeView.alpha = 1.0;
    } else {
        self.tapButton1Label.hidden = YES;
        self.sizeSlider.alpha = 0.0;
        self.brushSizeView.alpha = 0.0;
    }
}

- (void)showToolSelect:(BOOL)show
{
    if (show) {
        [self.toolSelectionView highlightCurrentlySelectedItem];
        self.toolSelectionView.hidden = NO;
    } else {
        self.toolSelectionView.hidden = YES;
    }
}

- (void)showColorSelect:(BOOL)show
{
    if (show) {
        [self.colorSelectionView highlightCurrentlySelectedItem];
        self.colorSelectionView.hidden = NO;
    } else {
        self.colorSelectionView.hidden = YES;
    }
}

- (void)setCurrentOverlayMode:(OverlayMode)currentOverlayMode
{
    _currentOverlayMode = currentOverlayMode;
    switch (currentOverlayMode) {
        case Overlay_Mode_Adjustment:
        {
            [self configureForAdjustment];
        }
            break;
            
        case Overlay_Mode_Selection:
        {
            [self configureForSelection];
        }
            break;
            
        default:
            break;
    }
}

- (void)HideAdjustment
{
    self.brushSizeView.hidden = YES;
    self.brushColorView.hidden = YES;
    self.colorSlider.hidden = YES;
    self.sizeSlider.hidden = YES;
    self.tapButton1Label.hidden = YES;
    self.tapButton2Label.hidden = YES;
 }

+ (CGSize)selectionViewSizeForNumberOfItems:(NSInteger)numberOfItems
{
    return [AdonitSelectionView selectionViewSizeForNumberOfItems:numberOfItems];
}

- (void)setToolUnselectedViews:(NSArray *)unselectedViews selectedViews:(NSArray *)selectedViews
{
    if (self.toolSelectionView) {
        [self.toolSelectionView removeFromSuperview];
        self.toolSelectionView = nil;
    }
    
    self.toolSelectionView = [[AdonitSelectionView alloc]initWithUnselectedViews:unselectedViews selectedViews:selectedViews];
    self.toolSelectionView.titleLabel.text = @"QUICK TOOL SELECT";
    self.toolSelectionView.center = self.view.center;
    
    [self.view addSubview:self.toolSelectionView];
}

- (void)setColorUnselectedViews:(NSArray *)unselectedViews selectedViews:(NSArray *)selectedViews
{
    if (self.colorSelectionView) {
        [self.colorSelectionView removeFromSuperview];
        self.colorSelectionView = nil;
    }
    
    self.colorSelectionView = [[AdonitSelectionView alloc]initWithUnselectedViews:unselectedViews selectedViews:selectedViews];
    self.colorSelectionView.titleLabel.text = @"QUICK COLOR SELECT";
    self.colorSelectionView.center = self.view.center;
    
    [self.view addSubview:self.colorSelectionView];
}

- (void)configureForSelection
{
    self.currentScrollInteractionFocus = Scroll_Interaction_Focus_Tool_Switch;
}

- (void)configureForAdjustment
{
    
}

- (void)setBrushColor:(UIColor *)color currentOpacity:(CGFloat)currentOpacity minValue:(CGFloat)minValue maxValue:(CGFloat)maxValue
{
    self.brushSizeView.lineColor = color;
    
    self.brushColorView.fillColor = color;
    self.colorSlider.minSliderValue = minValue;
    self.colorSlider.maxSliderValue = maxValue;
    self.colorSlider.currentSliderValue = currentOpacity;
}

- (CGFloat)brushOpacityAfterAdjustingByAmount:(CGFloat)adjustmentAmount
{
    CGFloat brushOpacityAmount = [self.colorSlider itemValueAfternAdjustingByAmount:adjustmentAmount];
    self.brushColorView.opacity = brushOpacityAmount;
    return brushOpacityAmount;
}

- (CGFloat)brushSizeAfternAdjustingByAmount:(CGFloat)adjustmentAmount
{
    CGFloat brushSizeAmount = [self.sizeSlider itemValueAfternAdjustingByAmount:adjustmentAmount];
    self.brushSizeView.lineSize = brushSizeAmount;
    return brushSizeAmount;
}

- (void)setBrushSize:(CGFloat)size minSize:(CGFloat)minSize maxSize:(CGFloat)maxSize
{
    self.sizeSlider.minSliderValue = minSize;
    self.sizeSlider.maxSliderValue = maxSize;
    self.sizeSlider.currentSliderValue = size;
    self.brushSizeView.lineSize = size;
}

@end
