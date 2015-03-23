//
//  CustomScrollView.h
//  JotTouchExample
//
//  Created by Ian on 1/9/14.
//  Copyright (c) 2014 Adonit, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CustomScrollView;

@protocol CustomScrollViewDataSource
- (UIView *) contentViewForCustomScrollView: (CustomScrollView *)sender;
@end

@interface CustomScrollView : UIScrollView

@property (nonatomic, weak) IBOutlet id <CustomScrollViewDataSource> dataSource;

@end
