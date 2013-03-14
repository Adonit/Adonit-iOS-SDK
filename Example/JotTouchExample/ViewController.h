//
//  ViewController.h
//  JotTouchExample
//
//  Created by Adam Wulf on 12/8/12.
//  Copyright (c) 2012 Adonit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JotTouchSDK/JotStylusManager.h>
#import "CanvasView.h"

@interface ViewController : UIViewController<UIPopoverControllerDelegate>{
    
    IBOutlet CanvasView* canvasView;

    IBOutlet UIButton* settingsButton;
    
    IBOutlet UIView* logView;
    
    IBOutlet UITextView* logTextView;
    
    UIPopoverController* popoverController;
}

-(IBAction) toggleLogView;
-(IBAction) clear;
-(void)jotSuggestsToDisableGestures;
-(void)jotSuggestsToEnableGestures;

@end
