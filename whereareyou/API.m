//
//  API.m
//  whereareyou
//
//  Created by Saravana vijaya kumar Amirthalingam on 30/11/13.
//  Copyright (c) 2013 hackatron13. All rights reserved.
//

#import "API.h"
#define DEF_BASE_URL @"http://192.168.0.101:8080/"

@implementation API

+(API*)sharedInstance
{
    static API *sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        sharedInstance = [[self alloc] init];// initWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",DEF_BASE_URL,kAPIHost]]];
        
    });
    return sharedInstance;
}
-(void)commandWithParams:(NSMutableDictionary *)params :(NSString*)command onCompletion:(JSONResponseBlock)completionBlock
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager POST:[NSString stringWithFormat:@"%@%@",DEF_BASE_URL,command] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", responseObject);
        completionBlock(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       // NSLog(@"error:%@",error);
    }] ;
}
-(void)getcommandWithParams:(NSMutableDictionary *)params :(NSString*)command onCompletion:(JSONResponseBlock)completionBlock
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager GET:[NSString stringWithFormat:@"%@%@",DEF_BASE_URL,command] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", responseObject);
        completionBlock(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       /// NSLog(@"error:%@",error);
    }] ;
}
@end
