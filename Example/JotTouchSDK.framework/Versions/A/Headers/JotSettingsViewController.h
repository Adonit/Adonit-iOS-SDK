//
//  SettingsViewController.h
//  JotTouchSDK
//
//  Created  on 3/3/13.
//  Copyright (c) 2013 Adonit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JotSettingsViewController : UINavigationController
-(id)initWithOnOffSwitch:(BOOL)showSwitch;
-(id)initWithOnOffSwitch:(BOOL)showSwitch andShowPalmRejection:(BOOL)showPalmRejection;
@end
