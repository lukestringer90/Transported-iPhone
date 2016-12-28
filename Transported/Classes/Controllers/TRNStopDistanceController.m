//
//  TRNStopDistanceController.m
//  Transport
//
//  Created by Luke Stringer on 20/04/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import "TRNStopDistanceController.h"
#import "TRNStop.h"
#import "TRNStopDistance.h"
#import "NSPredicate+TRNStop.h"
#import <CoreLocation/CoreLocation.h>
#import <SQKDataKit/SQKContextManager.h>

@interface TRNStopDistanceController ()
@property (nonatomic, strong, readwrite) SQKContextManager *contextManager;
@property (nonatomic, strong, readwrite) NSManagedObjectContext *privateContext;
@end

@implementation TRNStopDistanceController

- (instancetype)initWithContextManager:(SQKContextManager *)contextManager {
    if (self = [super init]) {
        _contextManager = contextManager;
    }
    return self;
}

- (void)asyncGenerateStopDistancesForLocation:(CLLocation *)location maxDistance:(CGFloat)maxDistance {
    self.privateContext = [self.contextManager newPrivateContext];
    [self.privateContext performBlock:^{
        [self removeAllStopDistancesInContext:self.privateContext save:NO];
        
        NSArray *nearbyStops = [self nearbyStopsFormLocation:location maxDistance:maxDistance];
        for (TRNStop *stop in nearbyStops) {
            [self insertStopDistanceForStop:stop location:location];
        }
        
        [self.privateContext save:NULL];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([self.delegate respondsToSelector:@selector(finishedGeneratingStopDistances:)]) {
                [self.delegate finishedGeneratingStopDistances:self];
            }
        });
        
    }];
    
}


- (void)removeAllStopDistancesInContext:(NSManagedObjectContext *)managedObjectContex save:(BOOL)saveContext {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([TRNStopDistance class])];
    fetchRequest.returnsObjectsAsFaults = YES;
    for (TRNStopDistance *stopDistance in [managedObjectContex executeFetchRequest:fetchRequest error:NULL]) {
        [managedObjectContex deleteObject:stopDistance];
    }
    if (saveContext) {
        [managedObjectContex save:NULL];
    }
}


- (void)insertStopDistanceForStop:(TRNStop *)stop location:(CLLocation *)location {
    CLLocation *stopLocation = [[CLLocation alloc] initWithLatitude:[stop.latitude floatValue]
                                                          longitude:[stop.longitude floatValue]];
    CLLocationDistance distance = [location distanceFromLocation:stopLocation];
    TRNStopDistance *stopDistance = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([TRNStopDistance class])
                                                                  inManagedObjectContext:self.privateContext];
    stopDistance.distance = @(distance);
    stopDistance.naptanCode = stop.naptanCode;
}

- (NSArray *)nearbyStopsFormLocation:(CLLocation *)location maxDistance:(CGFloat)maxDistance {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([TRNStop class])];
    fetchRequest.predicate = [NSPredicate trn_predicateForMaxDistance:maxDistance location:location];
    return [self.privateContext executeFetchRequest:fetchRequest error:nil];
}


@end
