//
//  Annotation.m
//  whereareyou
//
//  Created by Saravana vijaya kumar Amirthalingam on 30/11/13.
//  Copyright (c) 2013 hackatron13. All rights reserved.
//

#import "Annotation.h"

@implementation Annotation

@synthesize username;

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
    [self setTitle:nil];
    [self setSubtitle:nil];
}

#pragma mark -
#pragma mark Getters and setters

- (NSString *)title {
    return _title;
}

- (NSString *)subtitle {
    return _subtitle;
}

- (void)setTitle:(NSString *)title {
    if (_title != title) {
        _title = title;
    }
}

- (void)setSubtitle:(NSString *)subtitle {
    if (_subtitle != subtitle) {
        _subtitle = subtitle;
    }
}

- (CLLocationCoordinate2D)coordinate {
    return _coordinate;
}

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate {
    _coordinate = newCoordinate;
}

@end