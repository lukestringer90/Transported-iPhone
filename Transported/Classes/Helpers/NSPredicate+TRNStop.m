//
//  NSPredicate+TRNStop.m
//  Transport
//
//  Created by Luke Stringer on 14/04/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import "NSPredicate+TRNStop.h"
#import <CoreLocation/CoreLocation.h>

@implementation NSPredicate (TRNStop)

+ (NSPredicate *)trn_favouritedPredicate {
    return [NSPredicate predicateWithFormat:@"favourited == 1"];
}

+ (NSPredicate *)trn_recentPredicate{
    return [NSPredicate predicateWithFormat:@"lastViewDate != nil"];
}

+ (NSPredicate *)trn_tramsPredicate {
    return [NSPredicate predicateWithFormat:@"stopType == 'PLT'"];
}

+ (NSPredicate *)trn_busesPredicate {
    return [NSPredicate predicateWithFormat:@"stopType != 'PLT'"];
}

+ (NSPredicate *)trn_predicateForMaxDistance:(CGFloat)maxDistance location:(CLLocation *)location {
    /**
     *  Implementation from http://www.objc.io/issue-4/core-data-fetch-requests.html
     *  Formula:
             D = R * sqrt( (deltaLatitude * deltaLatitude) +
             (cos(meanLatitidue) * deltaLongitude) * (cos(meanLatitidue) * deltaLongitude))
     */
    double D = maxDistance * 1.1;
    double const R = 6371009.; // Earth readius in meters
    double meanLatitidue = location.coordinate.latitude * M_PI / 180.;
    double deltaLatitude = D / R * 180. / M_PI;
    double deltaLongitude = D / (R * cos(meanLatitidue)) * 180. / M_PI;
    double minLatitude = location.coordinate.latitude - deltaLatitude;
    double maxLatitude = location.coordinate.latitude + deltaLatitude;
    double minLongitude = location.coordinate.longitude - deltaLongitude;
    double maxLongitude = location.coordinate.longitude + deltaLongitude;
    
    return [NSPredicate predicateWithFormat:
            @"(%@ <= longitude) AND (longitude <= %@)"
            @"AND (%@ <= latitude) AND (latitude <= %@)",
            @(minLongitude), @(maxLongitude), @(minLatitude), @(maxLatitude)];
    
}

@end
