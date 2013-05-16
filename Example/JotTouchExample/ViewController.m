//
//  ViewController.m
//  JotTouchExample
//
//  Created by Adam Wulf on 12/8/12.
//  Copyright (c) 2012 Adonit. All rights reserved.
//

#import "ViewController.h"


@interface ViewController(){
    JotStylusManager* jotManager;
    UIPinchGestureRecognizer* pinchGesture;
}

@end


@implementation ViewController

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
        
    jotManager = [JotStylusManager sharedInstance];
    
    [jotManager addShortcutOptionButton1Default: [[JotShortcut alloc]
                                    initWithShortDescription:@"Undo"
                                    key:@"undo"
                                    target:canvasView selector:@selector(undo)
                                    repeatRate:100]];
    
    [jotManager addShortcutOptionButton2Default: [[JotShortcut alloc]
                                    initWithShortDescription:@"Redo"
                                    key:@"redo"
                                    target:canvasView selector:@selector(redo)
                                    repeatRate:100]];
    
    [jotManager addShortcutOption: [[JotShortcut alloc]
                                    initWithShortDescription:@"No Action"
                                    key:@"noaction"
                                    target:nil selector:@selector(decreaseStrokeWidth)
                                    repeatRate:100]];
    

    
    jotManager.unconnectedPressure = 0;
    jotManager.palmRejectorDelegate = canvasView;
    
    jotManager.rejectMode = NO;
    jotManager.enabled = YES;
    
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector:@selector(connectionChange:)
                                                 name: JotStylusManagerDidChangeConnectionStatus
                                               object:nil];
    
    //
    // This gesture tests to see how the Jot SDK handles
    // gestures that are added to the drawing view
    //
    // We'll test a pinch gesture, which could be used for
    // pinch to zoom
    
    pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinch:)];
    [canvasView addGestureRecognizer:pinchGesture];
    
}

-(void)connectionChange:(NSNotification *) note
{
    NSString *text;
    switch(jotManager.connectionStatus)
    {
        case JotConnectionStatusOff:
            text = @"Off";
            break;
        case JotConnectionStatusScanning:
            text = @"Scanning";
            break;
        case JotConnectionStatusPairing:
            text = @"Pairing";
            break;
        case JotConnectionStatusConnected:
            text = @"Connected";
            break;
        case JotConnectionStatusDisconnected:
            text = @"Disconnected";
            break;
        default:
            text = @"";
            break;
    }
    [settingsButton setTitle: text forState:UIControlStateNormal];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - IBAction

-(IBAction) showSettings:(id)sender{
    JotSettingsViewController* settings = [[JotSettingsViewController alloc] initWithOnOffSwitch: NO];
    if(popoverController){
        [popoverController dismissPopoverAnimated:NO];
    }
    popoverController = [[UIPopoverController alloc] initWithContentViewController:settings];
    [popoverController presentPopoverFromRect:[sender frame] inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    [popoverController setPopoverContentSize:CGSizeMake(300, 400) animated:NO];
}

#pragma mark - UIPopoverControllerDelegate

-(void) popoverControllerDidDismissPopover:(UIPopoverController *)_popoverController{
    popoverController = nil;
}


#pragma mark - Gesture Logs

-(IBAction) clear{
    logTextView.text = @"";
    [canvasView clear];
}

-(IBAction) toggleLogView{
    logView.hidden = !logView.hidden;
}

-(void) log:(NSString*) logLine{
    logTextView.text = [logTextView.text stringByAppendingFormat:@"%@\n", logLine];
    
    if(logTextView.contentSize.height > logTextView.bounds.size.height){
        logTextView.contentOffset = CGPointMake(0, logTextView.contentSize.height - logTextView.bounds.size.height);
    }
}

-(void)jotSuggestsToDisableGestures{
    // disable any other gestures, like a pinch to zoom
    [self log:@"Jot suggests to DISABLE gestures"];
    pinchGesture.enabled = NO;
}
-(void)jotSuggestsToEnableGestures{
    // enable any other gestures, like a pinch to zoom
    [self log:@"Jot suggests to ENABLE gestures"];
    pinchGesture.enabled = YES;
}
-(void) pinch:(UIPinchGestureRecognizer*)_pinchGesture{
    if(pinchGesture.state == UIGestureRecognizerStateBegan){
        [self log:@"Pinch Gesture Began"];
    }else if(pinchGesture.state == UIGestureRecognizerStateEnded){
        [self log:@"Pinch Gesture Ended"];
    }else if(pinchGesture.state == UIGestureRecognizerStateCancelled){
        [self log:@"Pinch Gesture Cancelled"];
    }
}

@end
