//
//  TRNStopDistance+Logic.m
//  Transported
//
//  Created by Luke Stringer on 24/05/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import "TRNStopDistance+Logic.h"

@implementation TRNStopDistance (Logic)

- (TRNStop *)fetchStop {
    return [[self valueForKey:@"stops"] firstObject];
}

+ (NSFetchRequest *)nearbyFetchRequest {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([TRNStopDistance class])];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"distance" ascending:YES]];
    fetchRequest.fetchLimit = TRNNearbyTableViewMaxStops;
    return fetchRequest;
}

@end
