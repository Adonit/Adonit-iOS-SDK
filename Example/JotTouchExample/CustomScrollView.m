//
//  CustomScrollView.m
//  JotTouchExample
//
//  Created by Ian on 1/9/14.
//  Copyright (c) 2014 Adonit, LLC. All rights reserved.
//

#import "CustomScrollView.h"
#import "Constants.h"

@implementation CustomScrollView
- (void) setup
{    
    self.panGestureRecognizer.minimumNumberOfTouches = 2;
    self.panGestureRecognizer.maximumNumberOfTouches = 2;
    self.backgroundColor = [UIColor lightGrayColor];
        
    if (!BOUNCE_SCROLLVIEW_ZOOM)
    {
        self.bouncesZoom = NO;
    }
    
}
- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self){
        [self setup];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setup];
    }
    return self;
}

- (void) centerView
{
    CGSize boundsSize = self.bounds.size;
    CGSize frameSize = [self.dataSource viewFrameForCustomScrollView:self].size;
    CGPoint newOffset = self.contentOffset;
    
    // center horizontally
    if (frameSize.width < boundsSize.width)
    {
        newOffset.x = -((boundsSize.width - frameSize.width) / 2.0);
    }
    
    // center vertically
    if (frameSize.height < boundsSize.height)
    {
        newOffset.y =  -((boundsSize.height - frameSize.height) / 2.0);
    }
    
    self.contentOffset = newOffset;
    
    [self layoutSubviews];
}

- (void)layoutSubviews
{
    CGSize frameSize = [self.dataSource viewFrameForCustomScrollView:self].size;

    CGFloat topInset;
    CGFloat bottomInset;
    CGFloat leftInset;
    CGFloat rightInset;
    
    // Vertical Inset Calc
    CGFloat heightInsetAdjustment = self.frame.size.height - frameSize.height;
    topInset = MAX(heightInsetAdjustment - SCROLLVIEW_INSET_BOTTOM, SCROLLVIEW_INSET_TOP);
    bottomInset = MAX(heightInsetAdjustment - SCROLLVIEW_INSET_TOP, SCROLLVIEW_INSET_BOTTOM);

    // Horizontal Inset Calc
    CGFloat widthInsetAdjustment = self.bounds.size.width - frameSize.width;
    leftInset = MAX(widthInsetAdjustment - SCROLLVIEW_INSET_RIGHT, SCROLLVIEW_INSET_LEFT);
    rightInset = MAX(widthInsetAdjustment - SCROLLVIEW_INSET_LEFT, SCROLLVIEW_INSET_RIGHT);
    
    [self setContentInset:UIEdgeInsetsMake(topInset, leftInset, bottomInset , rightInset)];
}

@end
