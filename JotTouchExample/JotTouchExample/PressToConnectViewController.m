//
//  PressToConnectViewController.m
//
//  Copyright (c) 2017 Adonit. All rights reserved.
//

#import "PressToConnectViewController.h"
#import <AdonitSDK/AdonitSDK.h>

@interface PressToConnectViewController ()
@property (nonatomic, strong) JotStylusManager *jotManager;

@end

@implementation PressToConnectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor jotPrimaryColor];
    UIViewController<JotModelController> *connectionStatusViewController = [UIStoryboard instantiateJotViewControllerWithIdentifier:JotViewControllerPressToConnectIdentifier];
    connectionStatusViewController.view.frame = self.pressToConnectView.bounds;
    NSArray *viewsToRemove = [self.pressToConnectView subviews];
    for (UIView *v in viewsToRemove) {
        [v removeFromSuperview];
    }
    [self.pressToConnectView addSubview:connectionStatusViewController.view];
    [self addChildViewController:connectionStatusViewController];
    self.jotManager = [JotStylusManager sharedInstance];
    
    // Register for jotStylus notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectionChanged:) name:JotStylusManagerDidChangeConnectionStatus object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(friendlyNameChanged:) name:JotStylusManagerDidChangeStylusFriendlyName object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showRecommendString:) name:JotStylusNotificationRecommend object:nil];
    [self.pressToConnectView setBackgroundColor:[UIColor clearColor]];
    
    [self updateInstructionsForConnectionStatus:self.jotManager.connectionStatus];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)connectionChanged:(NSNotification *)note
{
    JotConnectionStatus status = [note.userInfo[JotStylusManagerDidChangeConnectionStatusStatusKey] unsignedIntegerValue];
    [self updateViewWithConnectionStatus:status friendleyName:self.jotManager.stylusFriendlyName];
}

- (void)friendlyNameChanged:(NSNotification *)note
{
    NSString *friendlyName = note.userInfo[JotStylusManagerDidChangeStylusFriendlyNameNameKey];
    [self updateViewWithConnectionStatus:self.jotManager.connectionStatus friendleyName:friendlyName];
}

- (void)updateInstructionsForConnectionStatus:(JotConnectionStatus)status {
    switch(status)
    {
        case JotConnectionStatusConnected:
        {
            self.connectionInstructionLabel.text = @"Stylus Connected";
            break;
        }
        case JotConnectionStatusDisconnected:
        {
            
            self.connectionInstructionLabel.text = @"Hold Tip Here";
            break;
        }
        case JotConnectionStatusPairing:
        {
            self.connectionInstructionLabel.text = @"Connecting...";
            break;
        }
        case JotConnectionStatusScanning:
        {
            self.connectionInstructionLabel.text = @"Searching...";
            break;
        }
        case JotConnectionStatusStylusNotSupportThePlatform:
        case JotConnectionStatusSwapStylusNotSupportThePlatform:
            self.connectionInstructionLabel.text = @"This stylus is compatible with iPad Pro only.";
            break;
        case JotConnectionStatusOff:
        default:
            break;
    }
}

- (void)showRecommendString:(NSNotification *)note
{
    NSString *recommend = note.userInfo[JotStylusNotificationRecommendKey];
    self.connectionInstructionLabel.text = recommend;
}


/*
 * Update the state of your app with the connection change and also alert the user to changes. An example being displaying a on screen HUD showing that their stylus has connected, disconnected, etc.
 */
- (void)updateViewWithConnectionStatus:(JotConnectionStatus)status friendleyName:(NSString *)friendlyName
{
    [self updateInstructionsForConnectionStatus:status];
}

@end
