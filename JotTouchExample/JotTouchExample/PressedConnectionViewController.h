#import <UIKit/UIKit.h>

@interface PressedConnectionViewController : UIViewController<UIPopoverPresentationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *connectionImageView;

- (IBAction)connectionImageViewTapped:(UITapGestureRecognizer *)sender;

- (IBAction)connectionImageViewLongPress:(UILongPressGestureRecognizer *)sender;

- (void)connectionStatusChanged:(NSNotification *)notification;

@end
