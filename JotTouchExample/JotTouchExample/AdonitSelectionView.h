//
//  AdonitSelectionView.h
//  JotTouchExample
//
//  Copyright © 2016 Adonit, USA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AdonitSelectionView : UIView

@property (nonatomic) NSInteger selectedViewIndex;
@property (nonatomic) UILabel *titleLabel;

+ (CGSize)selectionViewSizeForNumberOfItems:(NSInteger)numberOfItems;
- (instancetype)initWithUnselectedViews:(NSArray *)unselectedViews selectedViews:(NSArray *)selectedViews;
- (NSInteger)idexOfItemSelectedAfterAdjustingByAmount:(CGFloat)adjustmentAmount;
- (void)highlightCurrentlySelectedItem;
@end
