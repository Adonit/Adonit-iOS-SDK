//
//  BT21Connection.h
//  PalmRejectionExampleApp
//
//  Created by UM on 9/14/12.
//  Copyright (c) 2012 Adonit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "jotStylusConnection.h"
@interface JotBT21Connection : NSObject <JotStylusConnection>
@property (readonly) BOOL isConnected;
@end
