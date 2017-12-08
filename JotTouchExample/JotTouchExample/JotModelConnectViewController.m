//
//  JotConnectedViewController.m
//
//  Copyright (c) 2017 Adonit. All rights reserved.
//
#import "JotModelConnectViewController.h"
#import "ShortcutButtonsTableViewController.h"


typedef NS_ENUM(NSUInteger, JotSettingsDetailSection) {
    JotSettingsDetailSectionConnect = 0,
    JotSettingsDetailSectionStylus = 1,
    JotSettingsDetailSectionAccuracyComfort = 2,
    JotSettingsDetailSectionUsageInfo = 3,
    JotSettingsDetailSectionHelp = 4,
    JotSettingsDetailSectionCount
};

typedef NS_ENUM(NSUInteger, JotSettingsDetailStylusRow) {
    JotSettingsDetailStylusStylusRow = 0,
    JotSettingsDetailStylusShortcutARow = 1,
    JotSettingsDetailStylusShortcutBRow = 2,
    JotSettingsDetailStylusRowCount
};

typedef NS_ENUM(NSUInteger, JotSettingsDetailAccuracyAndComfortRow) {
    JotSettingsDetailAccuracyAndComfortRowWritingStyle = 0,
    JotSettingsDetailAccuracyAndComfortRowCount
};

typedef NS_ENUM(NSUInteger, JotSettingsDetailUsageInfoRow) {
    JotSettingsUsageInfoRowEnable = 0,
    JotSettingsUsageInfoRowPrivacy = 1,
    JotSettingsDiagnosticRowCount
};

typedef NS_ENUM(NSUInteger, JotSettingsDetailHelpRow) {
    JotSettingsDetailHelpRowHelp = 0,
    JotSettingsDetailHelpRowCount
};

@interface JotModelConnectViewController () <PressToConnectViewControllerDelegate>

@property (nonatomic) BOOL pressToConnectAttemptInProgress;
@property IBOutlet NSLayoutConstraint *customCellLeftMarginStylus;
@property IBOutlet NSLayoutConstraint *customCellLeftMarginDiagnostics;


@end

@implementation JotModelConnectViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.stylusManager = [JotStylusManager sharedInstance];
//    [self updateViewWithConnectionStatus:self.stylusManager.connectionStatus];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectionChangeNotification:) name:JotStylusManagerDidChangeConnectionStatus object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(friendlyNameChanged:) name:JotStylusManagerDidChangeStylusFriendlyName object:nil];
    
    self.tableView.contentInset = UIEdgeInsetsMake(33 - 18, 0, 0, 0); // add top margin to container view to match spacing between headers.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)updateField {
    [self updateStylusCellWithFriendlyName:self.stylusManager.stylusFriendlyName];
    self.modelNameLabel.text = self.stylusManager.stylusModelFriendlyName;
    self.serialNumberLabel.text = self.stylusManager.serialNumber;
    self.firmwareVersionLabel.text = self.stylusManager.firmwareVersion;
    self.hardwareVersionLabel.text = self.stylusManager.hardwareVersion;
    self.adonitSDKVersionLabel.text = [NSString stringWithFormat:@" %@ (%@)",self.stylusManager.SDKVersion,self.stylusManager.SDKBuildVersion];
    self.configVersionLabel.text = self.stylusManager.ConfigVersion;
    self.batteryLabel.text = [[@(self.stylusManager.batteryLevel) stringValue] stringByAppendingString:@"%"];
    
    if ([self.stylusManager stylusShortcutButtonCount] > 0) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            JotShortcut *shortcutA = self.stylusManager.button1Shortcut;
            if (shortcutA) {
                self.shortcutALabel.text = shortcutA.descriptiveText;
            }

            JotShortcut *shortcutB = self.stylusManager.button2Shortcut;
            if (shortcutB) {
                self.shortcutBLabel.text = shortcutB.descriptiveText;
            }
        });
    }
    
    
    
    switch (self.stylusManager.writingStyle) {
        case JotWritingStyleRightAverage:
            self.writingStyleLabel.text = NSLocalizedString(@"Right Average", @"Right Average Writing Style");
            break;
        case JotWritingStyleRightHorizontal:
            self.writingStyleLabel.text = NSLocalizedString(@"Right Horizontal", @"Right Horizontal Writing Style");
            break;
        case JotWritingStyleRightVertical:
            self.writingStyleLabel.text = NSLocalizedString(@"Right Vertical", @"Right Veritcal Writing Style");
            break;
        case JotWritingStyleLeftAverage:
            self.writingStyleLabel.text = NSLocalizedString(@"Left Average", @"Left Average Writing Style");
            break;
        case JotWritingStyleLeftHorizontal:
            self.writingStyleLabel.text = NSLocalizedString(@"Left Horizontal", @"Left Horizontal Writing Style");
            break;
        case JotWritingStyleLeftVertical:
            self.writingStyleLabel.text = NSLocalizedString(@"Left Vertical", @"Left Vertical Writing Style");
            break;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.stylusManager.isStylusConnected) {
        [self updateField];
    }
}

- (void)friendlyNameChanged:(NSNotification *)notification
{
    NSString *friendlyName = notification.userInfo[JotStylusManagerDidChangeStylusFriendlyNameNameKey];
    [self updateStylusCellWithFriendlyName:friendlyName];
}

- (void)updateStylusCellWithFriendlyName:(NSString *)friendlyName
{
    self.stylusLabel.text = friendlyName;
}

#pragma mark - Table view data source

- (IBAction)openPrivacyPolicy:(id)sender
{
    [self.stylusManager launchPrivacyPolicyPage];
}

- (IBAction)launchHelp:(id)sender
{
    [self.stylusManager launchHelpAndShowAlertOnError:YES];
}

- (IBAction)disconnectButtonPressed:(id)sender
{
    if ([sender isKindOfClass:[UITapGestureRecognizer class]]) {
       
        // Let's highlight the disconnect cell to at least let people know they have successfully started a disconnect.
        UITapGestureRecognizer *tapGesture = sender;
        if ([tapGesture.view.superview isKindOfClass:[UITableViewCell class]]) {
            // gesture on contentView on TableviewCell
            UITableViewCell *cell = (UITableViewCell *) tapGesture.view.superview;
            
            [cell setHighlighted:YES];
        }
    }
    
    [self.stylusManager disconnectStylus];
}

- (IBAction)cancelButtonPressed:(UIBarButtonItem *)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    if (![self.stylusManager isStylusConnected]) {
        return 1;
    }
    return [super numberOfSectionsInTableView:tableView];
}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == JotSettingsDetailSectionStylus) {
        return self.stylusManager.stylusShortcutButtonCount + 8;
    }
    if (section == JotSettingsDetailSectionConnect) {
        if ([self.stylusManager isEnabled]) {
            return 2;
        } else {
            return 1;
        }
    }
  
    return [super tableView:tableView numberOfRowsInSection:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    NSString *title = [super tableView:tableView titleForHeaderInSection:section];
    return (title.length > 0) ? 33 : 0.0f;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == JotSettingsDetailSectionConnect) {
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        if (indexPath.row == 0) {
            UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
            cell.accessoryView = switchView;
            if ([self.stylusManager isEnabled]) {
                [switchView setOn:YES animated:NO];
            } else {
                [switchView setOn:NO animated:NO];
            }
            [switchView addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
        }
    }
    else if (indexPath.section == JotSettingsDetailSectionStylus) {
        if ([cell.textLabel.text isEqualToString:@"Button 1"]) {
            if (self.stylusManager.shortcuts.count == 0) {
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                cell.accessoryType = UITableViewCellAccessoryNone;
                self.shortcutALabel.text = @"Disabled";
            } else {
                [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.detailTextLabel.textColor = [UIColor jotDetailTextColor];
            }
        } else if ([cell.textLabel.text isEqualToString:@"Button 2"]) {
            if (self.stylusManager.shortcuts.count == 0) {
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                cell.accessoryType = UITableViewCellAccessoryNone;
                self.shortcutBLabel.text = @"Disabled";
            } else {
                [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.detailTextLabel.textColor = [UIColor jotDetailTextColor];
            }
        }
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [super prepareForSegue:segue sender:sender];
    
    if ([segue.identifier isEqualToString:@"ButtonAShortcutSettingsSegue"]) {
        ShortcutButtonsTableViewController *shortcutController = (ShortcutButtonsTableViewController*)segue.destinationViewController;
        shortcutController.buttonNumber = 1;
    } else if ([segue.identifier isEqualToString:@"ButtonBShortcutSettingsSegue"]) {
        ShortcutButtonsTableViewController *shortcutController = (ShortcutButtonsTableViewController*)segue.destinationViewController;
        shortcutController.buttonNumber = 2;
    } else if ([segue.identifier isEqualToString:@"EmbedPressToConnectHeaderSegue"]) {
        PressToConnectViewController *viewController = segue.destinationViewController;
        viewController.delegate = self;
    }
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    if ([identifier isEqualToString:@"ButtonAShortcutSettingsSegue"]) {
        if (self.stylusManager.shortcuts.count == 0) {
            return NO;
        }
    } else if ([identifier isEqualToString:@"ButtonBShortcutSettingsSegue"]) {
        if (self.stylusManager.shortcuts.count == 0) {
            return NO;
        }
    }
    return YES;
}

#pragma mark - state updates

- (IBAction)enableDiagnosticsSwitchValueDidChange:(id)sender
{
    if (self.enableDiagnosticsSwitch.isOn == self.stylusManager.reportDiagnosticData) {
        return;
    }
    self.stylusManager.reportDiagnosticData = self.enableDiagnosticsSwitch.isOn;
}

- (void)connectionChangeNotification:(NSNotification *)notification
{
    JotConnectionStatus connectionStatus = [notification.userInfo[JotStylusManagerDidChangeConnectionStatusStatusKey] unsignedIntegerValue];
    [self updateViewWithConnectionStatus:connectionStatus];
}

- (void)updateViewWithConnectionStatus:(JotConnectionStatus)connectionStatus
{
    if (connectionStatus == JotConnectionStatusConnected || connectionStatus == JotConnectionStatusSwapStylusNotSupportThePlatform) {
        [self updateHelpLabelWithModelName:self.stylusManager.stylusModelFriendlyName];
        [self updateField];
        if (connectionStatus == JotConnectionStatusConnected) {
            [self.tableView reloadData];
        }
    } else if (!self.pressToConnectAttemptInProgress) {
        [self.tableView reloadData];
    }
}

- (void)updateHelpLabelWithModelName:(NSString *)modelName
{
    self.helpLabel.text = [modelName stringByAppendingString:@" Help"];
}

- (void)applyColorSchemeToCell:(UITableViewCell *)cell
{
    
    if ([cell.contentView.subviews containsObject:self.disconnectLabel]) {
        self.disconnectLabel.textColor = [UIColor jotPrimaryColor];
    }
    
    if ([self.tableView respondsToSelector:@selector(layoutMargins)]) {
        self.customCellLeftMarginStylus.constant = self.tableView.layoutMargins.left;
        self.customCellLeftMarginDiagnostics.constant = self.tableView.layoutMargins.left;
    }
}

- (void)switchChanged:(id)sender {
    UISwitch *switchControl = sender;
    if (switchControl.on) {
        [self.stylusManager enable];
    } else {
        [self.stylusManager disable];
    }
    [self.tableView reloadData];
}

#pragma mark - JotPressToDisconnectViewControllerDelegate

- (void)pressToConnectControllerDidBeginConnectionAttempt:(PressToConnectViewController *)controller
{
    self.pressToConnectAttemptInProgress = YES;
}

- (void)pressToConnectControllerDidEndConnectionAttempt:(PressToConnectViewController *)controller
{
    self.pressToConnectAttemptInProgress = NO;
}

@end

