//
//  ConnectionStatusViewController.h
//
//  Copyright (c) 2017 Adonit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConnectionStatusViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *connectionImageView;

- (IBAction)connectionImageViewTapped:(UITapGestureRecognizer *)sender;

- (IBAction)connectionImageViewLongPress:(UILongPressGestureRecognizer *)sender;

- (void)connectionStatusChanged:(NSNotification *)notification;

@end
