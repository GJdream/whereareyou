//
//  Annotation.h
//  whereareyou
//
//  Created by Saravana vijaya kumar Amirthalingam on 30/11/13.
//  Copyright (c) 2013 hackatron13. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <MapKit/MKAnnotation.h>

@interface Annotation : NSObject <MKAnnotation> {
    NSString *_title;
    NSString *_subtitle;
    NSString *_username;
    
    CLLocationCoordinate2D _coordinate;
}

// Getters and setters
- (void)setTitle:(NSString *)title;
- (void)setSubtitle:(NSString *)subtitle;

@property (nonatomic) NSString* username;
@end
