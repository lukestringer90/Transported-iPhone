//
//  TRNStop+Logic.m
//  Transport
//
//  Created by Luke Stringer on 24/04/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import "TRNStop+Logic.h"
#import "NSPredicate+TRNStop.h"
#import "TRNUserStop.h"

@implementation TRNStop (Logic)

- (TRNStopType)type {
    if ([[NSPredicate trn_busesPredicate] evaluateWithObject:self]) {
        return TRNStopTypeBus;
    }
    else if ([[NSPredicate trn_tramsPredicate] evaluateWithObject:self]) {
        return TRNStopTypeTram;
    }
    return TRNStopTypeOther;
}

- (TRNUserStop *)insertOrFetchUserStop {
    [self.managedObjectContext refreshObject:self mergeChanges:YES];
	TRNUserStop *userStop = [[self valueForKey:@"userStops"] firstObject];
	if (!userStop) {
		userStop = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([TRNUserStop class])
													  inManagedObjectContext:self.managedObjectContext];
		userStop.naptanCode = self.naptanCode;
        [self.managedObjectContext save:NULL];
	}
	return userStop;
}

- (NSString *)cleanTitleByRemovingOccurencesOfString:(NSArray *)strings {
    for (NSString *stringToFind in strings) {
        NSUInteger startLocation = [self.fullTitle rangeOfString:stringToFind].location;
        if (startLocation != NSNotFound) {
            return [self.fullTitle substringToIndex:startLocation];
        }
    }
    return self.fullTitle;
}

- (TRNStopArea)area {
    if ([self.naptanCode hasPrefix:@"370"]) {
        return TRNStopAreaSouthYorkshire;
    }
    else if ([self.naptanCode hasPrefix:@"450"]) {
        return TRNStopAreaWestYorkshire;
    }
    CLSNSLog(@"Stop neither West nor South.");
    CLSNSLog(@"%@: %@", self.naptanCode, self.fullTitle);
    return TRNStopAreaNone;
}

@end
