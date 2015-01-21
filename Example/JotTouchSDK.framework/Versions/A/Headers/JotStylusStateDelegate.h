//
//  StylusStateDelegate.h
//  PalmRejectionExampleApp
//
//  Created  on 10/14/12.
//
//

#import <Foundation/Foundation.h>

@protocol JotStylusStateDelegate<NSObject>
-(void)jotStylusPressed;
-(void)jotStylusReleased;
-(void)jotStylusButton1Pressed;
-(void)jotStylusButton1Released;
-(void)jotStylusButton2Pressed;
-(void)jotStylusButton2Released;
-(void)jotStylusPressureUpdate:(uint)pressure;
-(void)jotStylusBatteryUpdate:(uint)battery;
@end
