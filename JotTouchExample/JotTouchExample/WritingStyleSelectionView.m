//
//  WritingStyleSelectionView.m
//
//  Copyright (c) 2017 Adonit. All rights reserved.
//

#import "WritingStyleSelectionView.h"

@interface WritingStyleSelectionView ()

@end

const static CGFloat ImageViewInsetPercentage = 0.08;

@implementation WritingStyleSelectionView

- (void)awakeFromNib
{
    self.image = [self.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.selected = NO;
}

- (void)setSelected:(BOOL)selected
{
    _selected = selected;
    if (selected) {
        self.tintColor = self.selectedColor;
     } else {
        self.tintColor = self.unSelectedColor;
    }
}

- (void)setSelectedColor:(UIColor *)selectedColor
{
    _selectedColor = selectedColor;
    self.selected = self.selected;
}

- (void)setUnSelectedColor:(UIColor *)unSelectedColor
{
    _unSelectedColor = unSelectedColor;
    self.selected = self.selected;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self setImageViewInset];
}

- (void)setImageViewInset
{
    // Reset contents first so that changes are not progressive
    self.layer.contentsRect = CGRectMake(0, 0, 1, 1);
    
    // Inset Image View;
    CGFloat horizontalInset = self.layer.contentsRect.size.width * ImageViewInsetPercentage;
    CGFloat verticalInset = self.layer.contentsRect.size.height * ImageViewInsetPercentage;
    self.layer.contentsRect = CGRectInset(self.layer.contentsRect, -horizontalInset, -verticalInset);
}

@end
