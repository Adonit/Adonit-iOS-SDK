//
//  JotStatusIndicatorView.m
//  JotTouchExample
//
//  Created by Ian Busch on 8/5/14.
//  Copyright (c) 2014 Adonit, LLC. All rights reserved.
//

#import "JotStatusIndicatorView.h"
#import <JotTouchSDK/JotTouchSDK.h>

@interface JotStatusIndicatorView ()

@property (nonatomic, weak) IBOutlet UILabel* jotActivityLabel;
@property (nonatomic, weak) IBOutlet UILabel* aButtonLabel;
@property (nonatomic, weak) IBOutlet UILabel* bButtonLabel;
@property (nonatomic, weak) IBOutlet UILabel* friendlyNameLabel;

@end

@implementation JotStatusIndicatorView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupShortCutButtonLabels];
    }
    return self;
}

#pragma mark - Button Label Setup

/**
 * We are setting up the buttons states to trigger labels so that a developer can see how a stylus reacts once connected to an app. An app could also use these notifications as a way to add more advanced behaviors to the up and down state of stylus buttons.
 */
- (void) setupShortCutButtonLabels
{
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector:@selector(jotButton1Down)
                                                 name: JotStylusButton1Down
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector:@selector(jotButton1Up)
                                                 name: JotStylusButton1Up
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector:@selector(jotButton2Down)
                                                 name: JotStylusButton2Down
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector:@selector(jotButton2Up)
                                                 name: JotStylusButton2Up
                                               object:nil];
}

- (void) jotButton1Down
{
    self.aButtonLabel.text = @"PRESSED";
}

- (void) jotButton1Up
{
    self.aButtonLabel.text = @"A";
}

- (void) jotButton2Down
{
    self.bButtonLabel.text = @"PRESSED";
}

- (void) jotButton2Up
{
   self.bButtonLabel.text = @"B";
}

- (void) setActivityMessage:(NSString *)activityMessage
{
    self.jotActivityLabel.text = activityMessage;
}

- (void) setConnectedStylusModel:(NSString *)stylusModelName
{
    self.friendlyNameLabel.text = stylusModelName;
}

#pragma mark - Cleanup
- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
