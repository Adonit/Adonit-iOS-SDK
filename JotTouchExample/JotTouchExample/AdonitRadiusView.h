//
//  AdonitRadiusView.h
//  JotTouchExample
//
//  Created by Ian Busch on 11/30/15.
//  Copyright © 2015 Adonit, USA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AdonitSDK/AdonitSDK.h>

@interface AdonitRadiusView : UIView
- (void)updateViewWithTouch:(UITouch *)touch;
- (void)updateViewWithJotStroke:(JotStroke *)stylusStroke;
@end
