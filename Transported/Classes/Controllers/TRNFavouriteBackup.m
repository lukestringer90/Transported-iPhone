//
//  TRNUserStopRestorer.m
//  Transported
//
//  Created by Luke Stringer on 24/11/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import "TRNFavouriteBackup.h"
#import "TRNUserStop.h"
#import "NSPredicate+TRNStop.h"
#import <SQKDataKit/NSManagedObject+SQKAdditions.h>
#import "TRNCoreDataManager.h"

static NSString * const NaptanKey       = @"NaptanKey";
static NSString * const OrderIndexKey   = @"OrderIndexKey";

@interface TRNFavouriteBackup ()
@property (nonatomic, strong) NSArray *favouritesBackup;
@end

@implementation TRNFavouriteBackup

- (void)createBackup
{
    NSManagedObjectContext *legacyContext = [self legacyContext];
    
    NSFetchRequest *fetchRequest = [TRNUserStop sqk_fetchRequest];
    fetchRequest.predicate = [NSPredicate trn_favouritedPredicate];
    fetchRequest.returnsObjectsAsFaults = NO;
    fetchRequest.propertiesToFetch = @[
                                       [TRNUserStop sqk_propertyDescriptionForName:@"naptanCode" context:legacyContext],
                                       [TRNUserStop sqk_propertyDescriptionForName:@"orderIndex" context:legacyContext]
                                       ];
    
    NSError *error = nil;
    NSArray *favourites = [legacyContext executeFetchRequest:fetchRequest error:&error];
    NSMutableArray *backup = [NSMutableArray array];
    
    for (TRNUserStop *fave in favourites) {
        [backup addObject:@{
                            NaptanKey : fave.naptanCode,
                            OrderIndexKey : fave.orderIndex
                            }];
    }
    self.favouritesBackup = backup;
}

- (void)restoreBackup
{
    NSManagedObjectContext *currentContext = [self currentContext];
    for (NSDictionary *userStopDict in self.favouritesBackup) {
        TRNUserStop *userStop = [TRNUserStop sqk_insertInContext:currentContext];
        userStop.naptanCode = userStopDict[NaptanKey];
        userStop.orderIndex = userStopDict[OrderIndexKey];
        userStop.favourited = @YES;
    }
    [currentContext save:NULL];
}

#pragma mark - Managed Object Context

// Legacy context as the user store sqlite file was named incorrectly in build 1.0.0
// So we need to get data from here and put it in thr new one.
- (NSManagedObjectContext *)legacyContext
{
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    context.persistentStoreCoordinator = [TRNCoreDataManager legacyPersistentStoreCoordinator];
    return context;
}

- (NSManagedObjectContext *)currentContext
{
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    context.persistentStoreCoordinator = [TRNCoreDataManager persistentStoreCoordinator];
    return context;
}

@end
