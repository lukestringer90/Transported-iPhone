//
//  TRNSectionIndexJSONGenerator.m
//  Transported
//
//  Created by Luke Stringer on 17/05/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import "TRNSectionIndexJSONGenerator.h"
#import "TRNStopDataImporter.h"
#import "NSPredicate+TRNStop.h"
#import "NSURL+TRNDocumentsDirectory.h"
#import "TRNConstants.h"

@implementation TRNSectionIndexJSONGenerator

+ (void)generateSectionIndexesFromManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    NSArray *allStopsIndexes = [TRNStopDataImporter managedObjectContext:managedObjectContext sectionIndexesForStopsMatchingPredicate:nil];
    NSArray *busIndexes = [TRNStopDataImporter managedObjectContext:managedObjectContext sectionIndexesForStopsMatchingPredicate:[NSPredicate trn_busesPredicate]];
    NSArray *tramIndexes = [TRNStopDataImporter managedObjectContext:managedObjectContext sectionIndexesForStopsMatchingPredicate:[NSPredicate trn_tramsPredicate]];
    
    NSData *allStopsIndexesJSON = [NSJSONSerialization dataWithJSONObject:allStopsIndexes
                                                                  options:kNilOptions
                                                                    error:NULL];
    NSData *busIndexesJSON = [NSJSONSerialization dataWithJSONObject:busIndexes
                                                             options:kNilOptions
                                                               error:NULL];
    NSData *tramIndexesJSON = [NSJSONSerialization dataWithJSONObject:tramIndexes
                                                              options:kNilOptions
                                                                error:NULL];
    
    [allStopsIndexesJSON writeToFile:[[NSURL trn_urlForFileInDocumentsNamed:[NSString stringWithFormat:@"%@.json", TRNStopIndexesJSONFilename_All]] path] atomically:YES];
    [busIndexesJSON writeToFile:[[NSURL trn_urlForFileInDocumentsNamed:[NSString stringWithFormat:@"%@.json", TRNStopIndexesJSONFilename_Buses]] path] atomically:YES];
    [tramIndexesJSON writeToFile:[[NSURL trn_urlForFileInDocumentsNamed:[NSString stringWithFormat:@"%@.json", TRNStopIndexesJSONFilename_Trams]] path] atomically:YES];
}

@end
