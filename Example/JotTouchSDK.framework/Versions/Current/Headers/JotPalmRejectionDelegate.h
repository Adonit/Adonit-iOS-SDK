//
//  PalmRejectionDelegate.h
//  PalmRejectionExampleApp
//
//  Created by UM on 9/14/12.
//  Copyright (c) 2012 Adonit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "JotTouch.h"
#import "JotPalmGestureRecognizer.h"

@protocol JotPalmRejectionDelegate <NSObject>
-(void)jotStylusTouchBegan:(NSSet *) touches;
-(void)jotStylusTouchMoved:(NSSet *) touches;
-(void)jotStylusTouchEnded:(NSSet *) touches;
-(void)jotStylusTouchCancelled:(NSSet *) touches;
-(void)jotSuggestsToDisableGestures;
-(void)jotSuggestsToEnableGestures;
@end

