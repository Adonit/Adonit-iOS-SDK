//
//  UITouch+JotStylus.h
//  JotTouchSDK
//
//  Created by Timothy Ritchey on 3/3/14.
//  Copyright (c) 2014 Adonit. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, JotTouchIdentificationType) {
    JotTouchIdentificationTypeUnknown,
    JotTouchIdentificationTypeStylus,
    JotTouchIdentificationTypeNotStylus
};

@interface UITouch (JotStylus)

/**
 * Experimental property identifying whether or not SDK thinks touch belongs to a stylus.
 */
@property (assign, nonatomic) JotTouchIdentificationType jotTouchIdentification;
@end
