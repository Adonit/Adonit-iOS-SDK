
#import <UIKit/UIKit.h>
#import <AdonitSDK/AdonitSDK.h>

@interface StylusDetailTableViewController : UITableViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *stylusNameTextField;
@property (weak, nonatomic) IBOutlet UILabel *modelNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *serialNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *firmwareVersionLabel;
@property (weak, nonatomic) IBOutlet UILabel *hardwareVersionLabel;
@property (weak, nonatomic) IBOutlet UILabel *adonitSDKVersionLabel;
@property (weak, nonatomic) IBOutlet UILabel *configVersionLabel;
@property (weak, nonatomic) IBOutlet UILabel *batteryLabel;
@property (weak, nonatomic) IBOutlet UILabel *helpLabel;

- (IBAction)disconnectTapped:(UITapGestureRecognizer *)sender;
@end
