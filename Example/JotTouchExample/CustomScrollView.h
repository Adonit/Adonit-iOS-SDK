//
//  CustomScrollView.h
//  JotTouchExample
//
//  Created by Ian on 1/9/14.
//  Copyright (c) 2014 Adonit, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "T1PogoManager.h"

@class CustomScrollView;

@protocol CustomScrollViewDataSource
- (CGRect) viewFrameForCustomScrollView: (CustomScrollView *) sender;
@end

@interface CustomScrollView : UIScrollView //<T1PogoDelegate>

@property (nonatomic, weak) IBOutlet id <CustomScrollViewDataSource> dataSource;
//@property (nonatomic, weak) T1PogoManager *pogoManagerPointer;

-(void) layoutSubviews;
- (void) centerView;

@end
