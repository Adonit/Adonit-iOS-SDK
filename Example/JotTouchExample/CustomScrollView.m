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
}

- (void)layoutSubviews
{
        CGSize frameSize = [self.dataSource viewFrameForCustomScrollView:self].size;

            CGFloat topInset;
            CGFloat bottomInset;
            CGFloat leftInset;
            CGFloat rightInset;
            
            // Vertical Inset Calc
            if (frameSize.height <= self.bounds.size.height)
            {
                 CGFloat heightInsetAdjustment = self.frame.size.height - frameSize.height;
                topInset = heightInsetAdjustment - SCROLLVIEW_INSET_BOTTOM;
                bottomInset = heightInsetAdjustment - SCROLLVIEW_INSET_TOP;
            }
            else
            {
                topInset = SCROLLVIEW_INSET_TOP;
                bottomInset = SCROLLVIEW_INSET_BOTTOM;
            }
    
            // Horizontal Inset Calc
            if (frameSize.width <= self.frame.size.width)
            {
                CGFloat widthInsetAdjustment = self.bounds.size.width - frameSize.width;
                leftInset = widthInsetAdjustment - SCROLLVIEW_INSET_RIGHT;
                rightInset = widthInsetAdjustment - SCROLLVIEW_INSET_LEFT;
            }
            else
            {
                leftInset = SCROLLVIEW_INSET_LEFT;
                rightInset = SCROLLVIEW_INSET_RIGHT;
            }
    

            [self setContentInset:UIEdgeInsetsMake(topInset, leftInset, bottomInset , rightInset)];
    
}

//-(void) pogoManagerDidSuggestDisablingGesturesForRegisteredViews:(T1PogoManager *)manager
//{
//    NSLog(@"Pogo DISABLE Gestures in Scrollview");
//    self.pinchGestureRecognizer.enabled = NO;
//    self.panGestureRecognizer.enabled = NO;
//}
//
//-(void) pogoManagerDidSuggestEnablingGesturesForRegisteredViews:(T1PogoManager *)manager
//{
//    NSLog(@"Pogo ENABLE Gestures in Scrollview");
//    self.pinchGestureRecognizer.enabled = YES;
//    self.panGestureRecognizer.enabled = YES;
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
