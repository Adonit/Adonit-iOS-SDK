//
//  PersistantStore.h
//  JotTouchSDK
//
//  Created  on 2/5/13.
//  Copyright (c) 2013 Adonit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JotPreferredStylus.h"

#define DEFAULT_FORCE_THRESHOLD_PERCENTAGE 25

@interface JotPersistantStore : NSObject
+ (id)sharedInstance;

/*! Loads preferred stylus from persistent store.
 * \return loadPreferredStylus The preferred stylus from persistent store
 */
+ (JotPreferredStylus *)loadPreferredStylus;

/*! Determines if persistent store already has user stylus elements.
 * \return Boolean of the existence of dictionary in persistent store.
 */
- (BOOL)hasDictionary;

/*! Returns user stylus elements accessed from the persistent store.
 * \return Dictionary that is persistently stored in the persistent store
 */
- (NSDictionary *)retrieveDictionary;

/*! Saves user stylus elements to persistent store.
 * \param dict Dictionary to save to the persistent store
 */
- (void)saveDictionary:(NSDictionary *)dict;
@end
