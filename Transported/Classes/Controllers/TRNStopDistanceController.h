//
//  TRNStopDistanceController.h
//  Transport
//
//  Created by Luke Stringer on 20/04/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TRNStopDistanceController;
@protocol TRNStopDistanceControllerDelegate <NSObject>

- (void)finishedGeneratingStopDistances:(TRNStopDistanceController *)controller;

@end

@class CLLocation, SQKContextManager;
@interface TRNStopDistanceController : NSObject

@property (nonatomic, weak) id<TRNStopDistanceControllerDelegate> delegate;

- (instancetype)initWithContextManager:(SQKContextManager *)contextManager;

- (void)removeAllStopDistancesInContext:(NSManagedObjectContext *)managedObjectContex save:(BOOL)saveContext;
- (void)asyncGenerateStopDistancesForLocation:(CLLocation *)location maxDistance:(CGFloat)maxDistance;

@end
