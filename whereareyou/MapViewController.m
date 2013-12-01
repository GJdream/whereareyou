//
//  MapViewController.m
//  whereareyou
//
//  Created by Saravana vijaya kumar Amirthalingam on 30/11/13.
//  Copyright (c) 2013 hackatron13. All rights reserved.
//
#define ChannelName @"test_channel"
#define EventName @"my_event"
#define METERS_PER_MILE 1609.344

#import "MapViewController.h"
#import <MapKit/MapKit.h>


@interface MapViewController ()
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (weak, nonatomic) IBOutlet UIButton *btnUpdateLocation;
- (IBAction)btnClick:(id)sender;
@end

@implementation MapViewController
@synthesize channel;
@synthesize pusherAPI;
@synthesize mapView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
    
    
}
- (PTPusher *)pusher {
    return [SharedAppDelegate pusher];
}

- (void)subscribeChannels {
    if (!pusherAPI) {
        pusherAPI = [[PTPusherAPI alloc] initWithKey:@"a3b9815a5a174314966b" appID:@"60589" secretKey:@"08db0f27a3aa31072ebe"];
    }
    
    if (![self.pusher.connection isConnected]) {
        self.pusher.reconnectDelay = 5;
        [self.pusher connect];
    }
    
    channel = [self.pusher channelNamed:ChannelName];
    if (!channel) {
        channel = [self.pusher subscribeToChannelNamed:ChannelName];
    }
    [channel removeAllBindings];
    [channel bindToEventNamed:EventName handleWithBlock:^(PTPusherEvent *channelEvent) {
        [self receiveMessagesFromChannel:channelEvent];
    }];
}

- (void)unsubscribeChannels {
    
    if (![self.pusher.connection isConnected]) {
        self.pusher.reconnectDelay = 5;
        [self.pusher connect];
    }
    
    channel = [self.pusher channelNamed:ChannelName];
    if (!channel) {
        channel = [self.pusher subscribeToChannelNamed:ChannelName];
    }
    [channel removeAllBindings];
}
- (void)receiveMessagesFromChannel:(PTPusherEvent *)channelEvent {
    NSLog(@"receive messages");
    if (!channelEvent || !channelEvent.channel || ![channelEvent.channel length]) {
        return;
    }
    NSLog(@"%@",channelEvent.data);
    
    NSString *strCoor =[channelEvent.data objectForKey:@"message"];
    NSLog(@"%@",strCoor);
    NSArray* strArray = [strCoor componentsSeparatedByString: @","];
    float la = [[strArray objectAtIndex: 0] floatValue];
    float lo = [[strArray objectAtIndex: 1] floatValue];
    NSString* un =[strArray objectAtIndex: 2];
    
    [self updateAnnotationswithUserName:un latitude:la longitude:lo time:@"online"];
    
}
-(void)updateAnnotationswithUserName:(NSString *)username latitude:(float)lat longitude:(float)longitude time:(NSString *)time{
    CLLocationCoordinate2D coord = {.latitude =  lat, .longitude =  longitude};
    
    NSArray *annotations = [mapView annotations];
    
    for (Annotation *ann in annotations) {
        if ([ann.username isEqualToString:username]) {
            [mapView removeAnnotation:ann];
        }
    }
    
    Annotation *annotation = [[Annotation alloc] init];
    annotation.title = username;
    annotation.username= username;
    annotation.subtitle=time;
    [annotation setCoordinate:coord];
    // [mapView removeAnnotations:mapView.annotations];
    [mapView addAnnotation:annotation];
    [mapView selectAnnotation:annotation animated:NO];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"Login" message:@"Enter User Name" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    av.alertViewStyle = UIAlertViewStylePlainTextInput;
    av.delegate = self;
    [av textFieldAtIndex:0].delegate = self;
    [av show];
    
    [[API sharedInstance] getcommandWithParams:nil :@"users" onCompletion:^(NSDictionary *json) {
        NSLog(@"result:%@",json);
        
        for (NSDictionary *dict in json) {
            NSString *un = [dict objectForKey:@"username"];
            NSString *strCoor =[dict objectForKey:@"last_seen_location"];
            NSLog(@"%@",strCoor);
            NSArray* strArray = [strCoor componentsSeparatedByString: @","];
            float la = [[strArray objectAtIndex: 0] floatValue];
            float lo = [[strArray objectAtIndex: 1] floatValue];
            //float la = [[dict objectForKey:@"latitude"] floatValue];
            //float lo = [[dict objectForKey:@"longitude"] floatValue];
            NSString *time = [dict objectForKey:@"last_seen_time"];
            
            [self updateAnnotationswithUserName:un latitude:la longitude:lo time:time];
        }
    }];
    
    [self subscribeChannels];
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        NSLog(@"text value : %@", [alertView textFieldAtIndex:0].text);
        SharedAppDelegate.username =[alertView textFieldAtIndex:0].text;
        
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        
        [NSTimer scheduledTimerWithTimeInterval:1.0
                                         target:self
                                       selector:@selector(startUpdateLocation)
                                       userInfo:nil
                                        repeats:YES];
        
        _startLocation = nil;
        
        CLLocationCoordinate2D zoomLocation;
        zoomLocation.latitude = 12.96667077;
        zoomLocation.longitude= 77.58102894;
        MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 10.5*METERS_PER_MILE, 10.5*METERS_PER_MILE);
        [mapView setRegion:viewRegion];
    }
    else
    {
        
    }
}
-(void)startUpdateLocation{
    [_locationManager startUpdatingLocation];
}
-(void)triggerPusher{
    CLLocationCoordinate2D coord = {.latitude =  12.96667077, .longitude =  77.58102894};
    [self.pusherAPI triggerEvent:EventName onChannel:ChannelName data:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%f,%f",coord.latitude,coord.longitude] forKey:@"message"] socketID:nil];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView_ viewForAnnotation:(id <MKAnnotation>)annotation {
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    
    static NSString* ShopAnnotationIdentifier = @"shopAnnotationIdentifier";
    MKPinAnnotationView *pinView = (MKPinAnnotationView *)[mapView_ dequeueReusableAnnotationViewWithIdentifier:ShopAnnotationIdentifier];
    if (!pinView) {
        pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:ShopAnnotationIdentifier];
        pinView.pinColor = MKPinAnnotationColorRed;
        pinView.animatesDrop = YES;
    }
    return pinView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnClick:(id)sender {
    
}
-(void)locationManager:(CLLocationManager *)manager
   didUpdateToLocation:(CLLocation *)newLocation
          fromLocation:(CLLocation *)oldLocation
{
    [_locationManager stopUpdatingLocation];
    //CLLocationCoordinate2D there =  oldLocation.coordinate;
   // NSLog(@"OLD Location: %f  %f ", there.latitude, there.longitude);
    
    CLLocationCoordinate2D here =  newLocation.coordinate;
   // NSLog(@"NEW Location: %f  %f ", here.latitude, here.longitude);
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[NSString stringWithFormat:@"%f,%f",here.latitude,here.longitude] forKey:@"latlong"];
    [params setObject:[SharedAppDelegate username] forKey:@"username"];
    
    [[API sharedInstance] commandWithParams:params :@"location" onCompletion:^(NSDictionary *json) {
        NSLog(@"result:%@",json);
    }];
    [self.pusherAPI triggerEvent:EventName onChannel:ChannelName data:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%f,%f,%@",here.latitude,here.longitude,[SharedAppDelegate username]] forKey:@"message"] socketID:nil];
}
@end
