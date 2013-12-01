//
//  MapViewController.h
//  whereareyou
//
//  Created by Saravana vijaya kumar Amirthalingam on 30/11/13.
//  Copyright (c) 2013 hackatron13. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CLLocationManager.h>
#import <CoreLocation/CLLocationManagerDelegate.h>



@interface MapViewController : UIViewController<PTPusherDelegate,CLLocationManagerDelegate,UITextFieldDelegate,UIAlertViewDelegate>

@property (nonatomic, readonly) PTPusher *pusher;
@property (nonatomic) PTPusherChannel *channel;
@property (nonatomic) PTPusherAPI *pusherAPI;
- (void)receiveMessagesFromChannel:(PTPusherEvent *)channelEvent;

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *startLocation;
@end
