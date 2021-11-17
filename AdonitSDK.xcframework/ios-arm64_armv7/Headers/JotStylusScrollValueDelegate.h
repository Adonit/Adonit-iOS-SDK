//
//  JotStylusScrollValueDelegate.h
//  AdonitSDK
//
//  Created on 2016/6/27.
//  Copyright © 2016年 Adonit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol JotStylusScrollValueDelegate <NSObject>

- (void)scrollValueUpdate:(CGFloat)value;

- (void)scrollShortcutChange;

@end
