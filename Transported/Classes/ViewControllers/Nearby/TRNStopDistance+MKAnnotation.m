//
//  TRNStop+MKAnnotation.m
//  Transported
//
//  Created by Luke Stringer on 26/05/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import "TRNStopDistance+MKAnnotation.h"
#import "TRNStopDistance+Logic.h"
#import "TRNStop+MKAnnotation.h"

@implementation TRNStopDistance (MKAnnotation)

- (CLLocationCoordinate2D)coordinate {
    return [[self fetchStop] coordinate];
}

- (NSString *)title {
    return [[self fetchStop] title];
}

- (NSString *)subtitle {
    return  [[self fetchStop] subtitle];
}


@end
