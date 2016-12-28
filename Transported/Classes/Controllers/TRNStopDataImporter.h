//
//  TRNStopDataImporter.h
//  Transport
//
//  Created by Luke Stringer on 31/03/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TRNStopDataImporter : NSObject

+ (void)importStopJSON:(NSArray *)stopJSON intoContext:(NSManagedObjectContext *)context;
+ (NSArray *)managedObjectContext:(NSManagedObjectContext *)context sectionIndexesForStopsMatchingPredicate:(NSPredicate *)predicate;

@end
