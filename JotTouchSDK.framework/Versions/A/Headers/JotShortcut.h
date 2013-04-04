//
//  Shortcut.h
//  JotSDKLibrary
//
//  Created  on 11/19/12.
//  Copyright (c) 2012 Adonit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JotShortcut : NSObject
@property (readwrite) NSString *shortDescription;
@property (readwrite) NSString *key;
@property (readwrite) SEL selector;
@property (readwrite,assign) id target;
@property (readwrite) BOOL repeat;
@property (readwrite) NSTimeInterval repeatRate;
@property (readwrite) BOOL usableWhenStylusDepressed;
-(id)initWithShortDescription:(NSString *)shortDescription key:(NSString *)key target:(id)target selector:(SEL)selector;
-(id)initWithShortDescription:(NSString *)shortDescription key:(NSString *)key target:(id)target selector:(SEL)selector repeatRate:(NSTimeInterval)repeatRate;

-(id)initWithShortDescription:(NSString *)shortDescription key:(NSString *)key target:(id)target selector:(SEL)selector usableWithStylusDepressed:(BOOL)usableWhenStylusDepressed;
-(id)initWithShortDescription:(NSString *)shortDescription key:(NSString *)key target:(id)target selector:(SEL)selector repeatRate:(NSTimeInterval)repeatRate usableWithStylusDepressed:(BOOL)usableWhenStylusDepressed;;
-(void)start;
-(void)stop;
@end
