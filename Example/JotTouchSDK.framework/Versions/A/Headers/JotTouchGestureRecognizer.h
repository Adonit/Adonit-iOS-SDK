//
//  JotTouchGestureRecognizer.h
//  JotTouchSDK
//
//  Created by Adam Wulf on 2/1/13.
//  Copyright (c) 2013 Adonit. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JotIgnoredTouchGestureRecognizer;

@interface JotTouchGestureRecognizer : UIGestureRecognizer{
    NSMutableArray* touchesBegan;
    
    __strong JotIgnoredTouchGestureRecognizer* otherJotGesture;
}


@property (nonatomic, strong) JotIgnoredTouchGestureRecognizer* otherJotGesture;

@end
