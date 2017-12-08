
#import "StylusDetailTableViewController.h"
#import "ShortcutButtonsTableViewController.h"


@interface StylusDetailTableViewController ()

@property IBOutlet NSLayoutConstraint *customCellLeftMarginName;
@property IBOutlet NSLayoutConstraint *customCellLeftMarginBattery;
@property (weak, nonatomic) IBOutlet UILabel *shortcutALabel;
@property (weak, nonatomic) IBOutlet UILabel *shortcutBLabel;
@property (weak, nonatomic) IBOutlet UILabel *writingStyleLabel;

@end

@implementation StylusDetailTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectionChangeNotification:) name:JotStylusManagerDidChangeConnectionStatus object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)connectionChangeNotification:(NSNotification *)notification
{
    JotConnectionStatus connectionStatus = [notification.userInfo[JotStylusManagerDidChangeConnectionStatusStatusKey] unsignedIntegerValue];
    if (connectionStatus == JotConnectionStatusDisconnected) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (void)applyColorSchemeToCell:(UITableViewCell *)cell
{
    if ([self.tableView respondsToSelector:@selector(layoutMargins)]) {
        self.customCellLeftMarginName.constant = self.tableView.layoutMargins.left;
        self.customCellLeftMarginBattery.constant = self.tableView.layoutMargins.left;
    }
}

- (void)updateViewWithAppearanceSettings
{
    
}

- (IBAction)disconnectTapped:(UITapGestureRecognizer *)sender
{
    [[JotStylusManager sharedInstance] disconnectStylus];
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ButtonAShortcutSettingsSegue"]) {
        ShortcutButtonsTableViewController *shortcutController = (ShortcutButtonsTableViewController*)segue.destinationViewController;
        shortcutController.buttonNumber = 1;
    } else if ([segue.identifier isEqualToString:@"ButtonBShortcutSettingsSegue"]) {
        ShortcutButtonsTableViewController *shortcutController = (ShortcutButtonsTableViewController*)segue.destinationViewController;
        shortcutController.buttonNumber = 2;
    }
}

- (IBAction)openPrivacyPolicy:(id)sender
{
    [[JotStylusManager sharedInstance] launchPrivacyPolicyPage];
}

- (IBAction)launchHelp:(id)sender
{
    [[JotStylusManager sharedInstance] launchHelpAndShowAlertOnError:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.stylusNameTextField.text = [JotStylusManager sharedInstance].stylusFriendlyName;
    self.modelNameLabel.text = [JotStylusManager sharedInstance].stylusModelFriendlyName;
    self.serialNumberLabel.text = [JotStylusManager sharedInstance].serialNumber;
    self.firmwareVersionLabel.text = [JotStylusManager sharedInstance].firmwareVersion;
    self.hardwareVersionLabel.text = [JotStylusManager sharedInstance].hardwareVersion;
    self.adonitSDKVersionLabel.text = [NSString stringWithFormat:@" %@ (%@)",[JotStylusManager sharedInstance].SDKVersion,[JotStylusManager sharedInstance].SDKBuildVersion];
    self.configVersionLabel.text = [JotStylusManager sharedInstance].ConfigVersion;
    self.batteryLabel.text = [[@([JotStylusManager sharedInstance].batteryLevel) stringValue] stringByAppendingString:@"%"];
    self.shortcutALabel.text = [JotStylusManager sharedInstance].button1Shortcut.descriptiveText;
    self.shortcutBLabel.text = [JotStylusManager sharedInstance].button2Shortcut.descriptiveText;
    
    self.helpLabel.text = [[[JotStylusManager sharedInstance] stylusModelFriendlyName] stringByAppendingString:@" Help"];
    
    switch ([JotStylusManager sharedInstance].writingStyle) {
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

@end
