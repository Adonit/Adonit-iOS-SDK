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
    self.scrollsToTop = NO;
    self.backgroundColor = [[UIColor lightGrayColor]colorWithAlphaComponent:0.25];
    
    if (!JotExampleBounceScrollViewZoom)
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

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize boundsSize = self.bounds.size;
    UIView *viewToCenter = [self.dataSource contentViewForCustomScrollView:self];
    CGRect frameToCenter = viewToCenter.frame;
    
    // center horizontally
    if (frameToCenter.size.width < boundsSize.width){
        frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2;
    } else {
        frameToCenter.origin.x = 0;
    }
    // center vertically
    if (frameToCenter.size.height < boundsSize.height){
        frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2;
    } else {
        frameToCenter.origin.y = 0;
    }
    
    viewToCenter.frame = frameToCenter;
}

@end
