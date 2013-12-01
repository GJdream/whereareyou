//
//  API.h
//  whereareyou
//
//  Created by Saravana vijaya kumar Amirthalingam on 30/11/13.
//  Copyright (c) 2013 hackatron13. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"

typedef void (^JSONResponseBlock)(NSDictionary* json);

@interface API : NSObject
+(API*)sharedInstance;

-(void)commandWithParams:(NSMutableDictionary *)params :(NSString*)command onCompletion:(JSONResponseBlock)completionBlock;
-(void)getcommandWithParams:(NSMutableDictionary *)params :(NSString*)command onCompletion:(JSONResponseBlock)completionBlock;
@end
