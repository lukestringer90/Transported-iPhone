//
//  TRNUserStop+Logic.m
//  Transport
//
//  Created by Luke Stringer on 17/05/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import "TRNUserStop+Logic.h"
#import "NSPredicate+TRNStop.h"

@implementation TRNUserStop (Logic)

- (TRNStop *)fetchStop {
    return [[self valueForKey:@"stops"] firstObject];
}

+ (TRNUserStop *)trn_insertOrFetchUserStopWithNaPTANCode:(NSString *)naptanCode managedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    NSString *entityName = NSStringFromClass([TRNUserStop class]);
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:entityName];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"naptanCode == %@", naptanCode];
    fetchRequest.fetchLimit = 1;
    
    NSError *error = nil;
    NSArray *entities = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    NSAssert(error == nil, @"should be no error");
    NSAssert(entities.count <= 1, @"should be either 0 or 1 matching TRNUserStops");
    
    TRNUserStop *userStop = [entities firstObject];
    if (!userStop) {
        userStop = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:managedObjectContext];
        userStop.naptanCode = naptanCode;
    }
    
    return userStop;
}

- (void)adjustOrderIndexesBySettingFavourited:(BOOL)favourited {
    NSString *entityName = NSStringFromClass([TRNUserStop class]);
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:entityName];
    // Favouriting
    if (favourited) {
        fetchRequest.predicate = [NSPredicate trn_favouritedPredicate];
        NSInteger count = [self.managedObjectContext countForFetchRequest:fetchRequest error:NULL];
        self.orderIndex = @(count);
    }
    // Un-favouriting
    else {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"orderIndex > %@", self.orderIndex];
        fetchRequest.predicate = predicate;
        
        NSArray *otherUserStops = [self.managedObjectContext executeFetchRequest:fetchRequest error:NULL];
        for (TRNUserStop *userStop in otherUserStops) {
            NSInteger newIndex = [userStop.orderIndex integerValue] - 1;
            userStop.orderIndex = @(newIndex);
        }
    }
    
    self.favourited = @(favourited);
}



@end
