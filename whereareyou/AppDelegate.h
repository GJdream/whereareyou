//
//  AppDelegate.h
//  whereareyou
//
//  Created by Saravana vijaya kumar Amirthalingam on 30/11/13.
//  Copyright (c) 2013 hackatron13. All rights reserved.
//



#import <UIKit/UIKit.h>
#import "MapViewController.h"
#import "Annotation.h"

#define SharedAppDelegate ((AppDelegate *)[[UIApplication sharedApplication] delegate])

@interface AppDelegate : UIResponder <UIApplicationDelegate,PTPusherDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) UIStoryboard* storyboard ;
@property (nonatomic) MapViewController* mapViewController;
@property (nonatomic) PTPusher *pusher;

@property (nonatomic) NSString *username;

@end
