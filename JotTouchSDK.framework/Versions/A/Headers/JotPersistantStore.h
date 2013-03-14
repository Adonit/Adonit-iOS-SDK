//
//  PersistantStore.h
//  JotTouchSDK
//
//  Created  on 2/5/13.
//  Copyright (c) 2013 Adonit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JotPersistantStore : NSObject
+(id)sharedInstance;
-(BOOL)hasDictionary;
-(NSDictionary *)retrieveDictionary;
-(void)saveDictionary:(NSDictionary *)dict;
@end
