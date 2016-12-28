//
//  TRNStop+MKAnnotation.m
//  Transported
//
//  Created by Luke Stringer on 05/07/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import "TRNStop+MKAnnotation.h"
#import "TRNStop+Logic.h"

@implementation TRNStop (MKAnnotation)

- (CLLocationCoordinate2D)coordinate {
    return CLLocationCoordinate2DMake([self.latitude floatValue], [self.longitude floatValue]);
}

- (NSString *)title {
    return self.cleanTitle;
}

- (NSString *)subtitle {
    
    if ([self type] == TRNStopTypeTram && self.indicator.length > 0) {
        return self.indicator;
        return nil;
    }
    else if (self.bearing.length > 0){
        return [NSString stringWithFormat:@"Heading %@", self.bearing];
    }
    
    return nil;
}


@end
