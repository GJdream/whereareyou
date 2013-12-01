//
//  AppDelegate.m
//  whereareyou
//
//  Created by Saravana vijaya kumar Amirthalingam on 30/11/13.
//  Copyright (c) 2013 hackatron13. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate
@synthesize pusher;
@synthesize storyboard;
@synthesize mapViewController;
@synthesize username;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
     storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    self.mapViewController = [storyboard instantiateInitialViewController];
    
    [self initPusher];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = self.mapViewController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma -- mark -- Pusher

- (void)initPusher {
    pusher = [PTPusher pusherWithKey:@"a3b9815a5a174314966b" connectAutomatically:NO encrypted:YES];
    pusher.delegate = self;
    pusher.reconnectAutomatically = YES;
    [pusher connect];
}

- (void)pusher:(PTPusher *)_pusher connectionDidConnect:(PTPusherConnection *)connection {
    NSLog(@"success");
}

- (void)pusher:(PTPusher *)pusher connection:(PTPusherConnection *)connection failedWithError:(NSError *)error {
    NSLog(@"error : %@",error);
}

- (void)pusher:(PTPusher *)pusher connection:(PTPusherConnection *)connection didDisconnectWithError:(NSError *)error {
    NSLog(@"disconnect");
}

- (void)pusher:(PTPusher *)pusher willAuthorizeChannelWithRequest:(NSMutableURLRequest *)request {
}

- (void)pusher:(PTPusher *)_pusher didFailToSubscribeToChannel:(PTPusherChannel *)channel withError:(NSError *)error {
        NSLog(@"didFailToSubscribeToChannel = %@ ; error = %@",channel,error);
    
    _pusher.reconnectDelay = 120;
    [_pusher disconnect];
}

- (void)pusher:(PTPusher *)pusher didSubscribeToChannel:(PTPusherChannel *)channel {
        NSLog(@"didSubscribeToChannel = %@",channel);
}

@end
