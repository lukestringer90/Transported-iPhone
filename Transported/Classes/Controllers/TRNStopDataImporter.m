//
//  TRNStopDataImporter.m
//  Transport
//
//  Created by Luke Stringer on 31/03/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import "TRNStopDataImporter.h"
#import <KZPropertyMapper/KZPropertyMapper.h>
#import "TRNStop.h"

@implementation KZPropertyMapper (Boxing)

+ (id)boxValueAsNumber:(id)value {
    return @([value doubleValue]);
}

+ (id)boxValueAsDate:(id)value {
    static NSDateFormatter *dateFormatter;
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    }
    return [dateFormatter dateFromString:value];
}

@end

@implementation TRNStopDataImporter

+ (void)importStopJSON:(NSArray *)stopJSON intoContext:(NSManagedObjectContext *)context {
    [KZPropertyMapper logIgnoredValues:NO];
    NSDictionary *mapping = @{
                              @"AdministrativeAreaCode" : @"administritiveAreaCode",
                              @"Bearing" : @"bearing",
                              @"BusStopType" : @"busStopType",
                              @"CommonName" : @"commonName",
                              @"ShortCommonName" : @"commonNameShort",
                              @"CreationDateTime" : @"@Date(creationDate)",
                              @"Crossing" : @"crossing",
                              @"DefaultWaitTime" : @"defaultWaitTime",
                              @"Easting" : @"@Number(easting)",
                              @"GrandParentLocalityName" : @"grandParentLocalityName",
                              @"GridType" : @"gridType",
                              @"Indicator" : @"indicator",
                              @"Landmark" : @"landmark",
                              @"Latitude" : @"@Number(latitude)",
                              @"LocalityCentre" : @"localityCentre",
                              @"NptgLocalityCode" : @"localityCode",
                              @"LocalityName" : @"localityName",
                              @"Longitude" : @"@Number(longitude)",
                              @"Modification" : @"modification",
                              @"ModificationDateTime" : @"@Date(modificationDate)",
                              @"Northing" : @"@Number(northing)",
                              @"Notes" : @"notes",
                              @"ParentLocalityName" : @"parentLocalityName",
                              @"RevisionNumber" : @"revisionNumber",
                              @"Status" : @"status",
                              @"StopType" : @"stopType",
                              @"Street" : @"street",
                              @"Suburb" : @"suburb",
                              @"TimingStatus" : @"timingStatus",
                              @"Town" : @"town"
                              };
    
    for (NSDictionary *dictionary in stopJSON) {
        TRNStop *stop = [self insertOrFetchStopWithNaptanCode:dictionary[@"CorrectCode"] context:context error:NULL];
        [KZPropertyMapper mapValuesFrom:dictionary toInstance:stop usingMapping:mapping];
        if ([stop.commonNameShort length] > 0) {
            stop.fullTitle = stop.commonNameShort;
        }
        else {
            stop.fullTitle = stop.commonName;
        }
        NSString *firstLetter = [stop.fullTitle substringToIndex:1];
        
        if ([firstLetter rangeOfCharacterFromSet:[NSCharacterSet letterCharacterSet]].location == NSNotFound) {
            stop.uppercaseFirstLetterTitle = @"#";
        }
        else {
            stop.uppercaseFirstLetterTitle = firstLetter;
        }
        
        NSString *title = stop.fullTitle;
        
        stop.fullTitle = [title stringByReplacingOccurrencesOfString:@"(Sheffield Supertram)" withString:@"(Supertram)"];
        stop.cleanTitle = [title stringByReplacingOccurrencesOfString:@"(Sheffield Supertram)" withString:@""];
        
        if ([stop.naptanCode isEqualToString:@"37090183"]) {
            stop.indicator = nil;
        }

    }
    [context save:nil];
}

+ (TRNStop *)insertOrFetchStopWithNaptanCode:(id)naptancode
                                 context:(NSManagedObjectContext *)context
                                   error:(NSError **)error
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([TRNStop class])];
    [request setFetchLimit:1];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"naptanCode = %@", naptancode];
    [request setPredicate:predicate];
    
    NSError *localError = nil;
    NSArray *objects = [context executeFetchRequest:request error:&localError];
    if (localError)
    {
        // Check the passed error pointer is not nil
        if (error)
        {
            *error = localError;
        }
        return nil;
    }
    
    TRNStop *stop = [objects lastObject];
    if (!stop)
    {
        stop = (TRNStop *)[NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([TRNStop class])
                                                      inManagedObjectContext:context];
        stop.naptanCode = naptancode;
    }
    
    return stop;
}

+ (NSArray *)managedObjectContext:(NSManagedObjectContext *)context sectionIndexesForStopsMatchingPredicate:(NSPredicate *)predicate {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([TRNStop class])];
    fetchRequest.predicate = predicate;
    NSArray *objects = [context executeFetchRequest:fetchRequest error:NULL];
    NSArray *indexes = [[objects valueForKeyPath:@"uppercaseFirstLetterTitle"] sortedArrayUsingSelector:@selector(compare:)];
    return [[NSSet setWithArray:indexes] allObjects];
}


@end
