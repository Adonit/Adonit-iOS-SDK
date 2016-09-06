//
//  AdonitSelectionView.m
//  JotTouchExample
//
//  Copyright © 2016 Adonit, USA. All rights reserved.
//

#import "AdonitSelectionView.h"

const CGFloat SelectionViewPadding = 2.0;
const CGFloat SelectionReticalThickness = 2.0;
const CGFloat SelectionAnimateTimer = 0.6;
const CGFloat LabelHeight = 22.0;
const CGFloat labelBottomPadding = 8.0;

@interface AdonitSelectionView()
@property NSArray *selectedViews;
@property NSArray *unselectedViews;
@property (nonatomic) UIView *retical;
@property (nonatomic) NSTimer *animateSelectionTimer;

@end

@implementation AdonitSelectionView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (CGSize)selectionViewSizeForNumberOfItems:(NSInteger)numberOfItems;
{
    CGFloat paddingSubtractor = 0.0;
    CGFloat selectionRecticalSubtractor = SelectionReticalThickness;
    if (numberOfItems > 1) {
        paddingSubtractor = (numberOfItems - 1) * SelectionViewPadding;
        selectionRecticalSubtractor = ((numberOfItems + 1) * SelectionReticalThickness);
    }
    
    return CGSizeMake((((SelectionSizeWidth - selectionRecticalSubtractor) - paddingSubtractor) / (CGFloat) numberOfItems), SelectionSizeHeight - (SelectionReticalThickness * 2.0)- LabelHeight);
}

- (instancetype)initWithUnselectedViews:(NSArray *)unselectedViews selectedViews:(NSArray *)selectedViews
{
    self = [super initWithFrame:CGRectMake(0, 0, SelectionSizeWidth, SelectionSizeHeight)];
    if (self) {
        _selectedViews = selectedViews;
        _unselectedViews = unselectedViews;
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SelectionSizeWidth, LabelHeight - labelBottomPadding)];
        [self configureTitleLabel];
        [self addSubview:_titleLabel];
        [self placeUnSelectionViews];
        [self placeSelectionViews];
        self.selectedViewIndex = 1;
        self.retical.frame = [self recticalFrameForSelection];
    }
    return self;
}

- (void)configureTitleLabel
{
    self.titleLabel.text = @"SELECTION VIEW TITLE";
    self.titleLabel.textColor = [UIColor whiteColor];
    [self.titleLabel setFont:[UIFont boldSystemFontOfSize:18.0]];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}

- (UIView *)retical
{
    if (!_retical) {
        _retical = [[UIView alloc]initWithFrame:CGRectMake(0, LabelHeight, (SelectionSizeWidth / (CGFloat) self.selectedViews.count), SelectionSizeHeight - LabelHeight)];
        _retical.layer.borderColor = [UIColor redColor].CGColor;
        _retical.layer.borderWidth = SelectionReticalThickness;
        _retical.layer.cornerRadius = SelectionReticalThickness;
        [self addSubview:_retical];
    }
    return _retical;
}

- (CGRect)recticalFrameForSelection
{
    CGFloat recticalWidth = SelectionSizeWidth / (CGFloat) self.selectedViews.count;
    return CGRectMake(recticalWidth * (CGFloat) self.selectedViewIndex, LabelHeight, recticalWidth, SelectionSizeHeight - LabelHeight);
}

- (void)placeSelectionViews
{
    NSInteger counter = 0;
    for (UIView *selectedView in self.selectedViews) {
        CGRect viewFrame = [self rectForViewAtIndex:counter withNumberOfViews:self.selectedViews.count];
        selectedView.frame = viewFrame;
        selectedView.hidden  = YES;
        [self addSubview:selectedView];
        counter++;
    }
}

- (void)placeUnSelectionViews
{
    NSInteger counter = 0;
    for (UIView *unselectedView in self.unselectedViews) {
        CGRect viewFrame = [self rectForViewAtIndex:counter withNumberOfViews:self.unselectedViews.count];
        unselectedView.frame = viewFrame;
        [self addSubview:unselectedView];
        counter++;
    }
}

- (void)setSelectedViewIndex:(NSInteger)selectedViewIndex
{
    [self unSelectViewAtIndex:_selectedViewIndex];
    _selectedViewIndex = selectedViewIndex;
    [self selectViewAtIndex:selectedViewIndex];
}

- (void)selectViewAtIndex:(NSInteger)index
{
    if (index < self.selectedViews.count && index < self.unselectedViews.count) {
        // hide unselection state
        UIView *unselectedView = self.unselectedViews[index];
        unselectedView.hidden = YES;
        
        // show selection state
        UIView *selectedView = self.selectedViews[index];
        selectedView.hidden = NO;
    }
}

- (void)unSelectViewAtIndex:(NSInteger)index
{
    if (index < self.unselectedViews.count && index < self.selectedViews.count) {
        // show unselection state
        UIView *unselectedView = self.unselectedViews[index];
        unselectedView.hidden = NO;
        
        // hide selection state
        UIView *selectedView = self.selectedViews[index];
        selectedView.hidden = YES;
    }
}

- (CGRect)rectForViewAtIndex:(NSInteger)index withNumberOfViews:(NSInteger)numberOfViews
{
    CGSize size = [AdonitSelectionView selectionViewSizeForNumberOfItems:numberOfViews];
    return CGRectMake((((size.width)  * (CGFloat)index) + (SelectionViewPadding * (CGFloat)index)) + SelectionReticalThickness * ((CGFloat)index + 1.0), SelectionReticalThickness + LabelHeight, size.width, size.height);
}

- (CGFloat)dynamicDampeningAmount
{
    
    // dyamic dampening based on width of frame
//    CGFloat rangeOfScrollSensor = 255.0;
//    CGFloat adjustmentRange = self.bounds.size.width;
//    CGFloat speedAdjustment = 0.75; // lower the less movement needed.
//    
//    CGFloat dampeningAmount = ((adjustmentRange * speedAdjustment)/ rangeOfScrollSensor);
//    return dampeningAmount;

    // dynamic dampening based on number of items.
    CGFloat rangeOfScrollSensor = 255.0;
    CGFloat frameSizeWidth = self.bounds.size.width;
    CGFloat numberOfItems = (CGFloat) self.selectedViews.count;
    CGFloat speedAdjustment = 1.05; // lower the less movement needed.
    
    CGFloat dampeningAmount = ((rangeOfScrollSensor * numberOfItems) / (frameSizeWidth * (numberOfItems * speedAdjustment)));
    return dampeningAmount;
}

- (NSInteger)idexOfItemSelectedAfterAdjustingByAmount:(CGFloat)adjustmentAmount
{
    if (self.animateSelectionTimer.valid) {
        [self.animateSelectionTimer invalidate];
    }
        
    adjustmentAmount = adjustmentAmount * [self dynamicDampeningAmount];
    
    CGRect frameOfItems = self.bounds;
    NSInteger numberOfItems = self.selectedViews.count;
    
    CGFloat widthOfItem = frameOfItems.size.width / (CGFloat) numberOfItems;
    CGRect minFrame = CGRectMake(frameOfItems.origin.x, frameOfItems.origin.y +LabelHeight, widthOfItem, self.frame.size.height - LabelHeight);
    CGRect maxFrame = CGRectMake(frameOfItems.origin.x + (widthOfItem * (CGFloat) (numberOfItems - 1)), frameOfItems.origin.y + LabelHeight, widthOfItem, self.bounds.size.height - LabelHeight);
    
    CGRect currentRawSelectionFrame = CGRectMake(self.retical.frame.origin.x + adjustmentAmount, self.bounds.origin.y + LabelHeight, widthOfItem, self.bounds.size.height  - LabelHeight);
    if (currentRawSelectionFrame.origin.x < minFrame.origin.x) {
        currentRawSelectionFrame = minFrame;
    } else if (currentRawSelectionFrame.origin.x > maxFrame.origin.x) {
        currentRawSelectionFrame = maxFrame;
    }
    
    CGFloat rawXOrigin = currentRawSelectionFrame.origin.x;
    
    // relative comparison
    CGFloat itemIncrement = widthOfItem;
    CGFloat relativeRawXOrigin = rawXOrigin - minFrame.origin.x;
    CGFloat closestRelativeSelectedXOrigin = round (relativeRawXOrigin * (1.0 / itemIncrement)) / (1.0 / itemIncrement);
    
    [UIView animateWithDuration:0.25 delay: 0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.retical.alpha = 1.0;
        self.retical.frame = currentRawSelectionFrame;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5 delay: 1.0 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
            //self.retical.alpha = 0.0;
        } completion:nil];
    }];
    
    NSInteger closestSelectedColorIndex = closestRelativeSelectedXOrigin / itemIncrement;
    
    self.animateSelectionTimer = [NSTimer scheduledTimerWithTimeInterval:SelectionAnimateTimer target:self selector:@selector(animateToSelection:) userInfo:nil repeats:NO];
    return closestSelectedColorIndex;
}

- (void)animateToSelection:(NSTimer *)timer
{
    [UIView animateWithDuration:0.35 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
        [self highlightCurrentlySelectedItem];
    } completion:^(BOOL finished) {
        // cleanup
    }];
}

- (void)highlightCurrentlySelectedItem;
{
    NSInteger numberOfItems = self.selectedViews.count;
    CGFloat widthOfItem = self.bounds.size.width / (CGFloat) numberOfItems;
    self.retical.frame = CGRectMake(widthOfItem * self.selectedViewIndex, LabelHeight, self.retical.bounds.size.width, self.retical.bounds.size.height);
}


@end
