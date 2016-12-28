//
//  TRNUserStop+Logic.h
//  Transport
//
//  Created by Luke Stringer on 17/05/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import "TRNUserStop.h"

@class TRNStop;
@interface TRNUserStop (Logic)

- (TRNStop *)fetchStop;
- (void)adjustOrderIndexesBySettingFavourited:(BOOL)favourited;
+ (TRNUserStop *)trn_insertOrFetchUserStopWithNaPTANCode:(NSString *)naptanCode managedObjectContext:(NSManagedObjectContext *)managedObjectContext;

@end
