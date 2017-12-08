//
//  JotModelConnectViewController.h
//
//  Copyright (c) 2017 Adonit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AdonitSDK/AdonitSDK.h>
#import "PressToConnectViewController.h"

@interface JotModelConnectViewController : UITableViewController <PressToConnectViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *helpLabel;
@property (nonatomic, weak) IBOutlet UISwitch *enableDiagnosticsSwitch;
@property (nonatomic, weak) IBOutlet UILabel *shortcutALabel;
@property (nonatomic, weak) IBOutlet UILabel *shortcutBLabel;


@property (nonatomic, weak) IBOutlet UILabel *writingStyleLabel;
@property (nonatomic, weak) IBOutlet UILabel *stylusLabel;
@property (nonatomic, weak) IBOutlet UILabel *disconnectLabel;
@property (weak, nonatomic) IBOutlet UILabel *modelNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *serialNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *firmwareVersionLabel;
@property (weak, nonatomic) IBOutlet UILabel *hardwareVersionLabel;
@property (weak, nonatomic) IBOutlet UILabel *adonitSDKVersionLabel;
@property (weak, nonatomic) IBOutlet UILabel *configVersionLabel;
@property (weak, nonatomic) IBOutlet UILabel *batteryLabel;

@property (nonatomic) JotStylusManager *stylusManager;

@property (nonatomic) UIApplication *sharedApplication;

- (IBAction)disconnectButtonPressed:(id)sender;
- (IBAction)cancelButtonPressed:(UIBarButtonItem *)sender;

- (void)connectionChangeNotification:(NSNotification *)notification;
- (void)friendlyNameChanged:(NSNotification *)notification;

@end
