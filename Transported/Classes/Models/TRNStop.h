//
//  TRNStop.h
//  Transported
//
//  Created by Luke Stringer on 25/08/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface TRNStop : NSManagedObject

@property (nonatomic, retain) NSString * administritiveAreaCode;
@property (nonatomic, retain) NSString * bearing;
@property (nonatomic, retain) NSString * busStopType;
@property (nonatomic, retain) NSString * cleanTitle;
@property (nonatomic, retain) NSString * commonName;
@property (nonatomic, retain) NSString * commonNameShort;
@property (nonatomic, retain) NSDate * creationDate;
@property (nonatomic, retain) NSString * crossing;
@property (nonatomic, retain) NSString * defaultWaitTime;
@property (nonatomic, retain) NSNumber * easting;
@property (nonatomic, retain) NSString * grandParentLocalityName;
@property (nonatomic, retain) NSString * gridType;
@property (nonatomic, retain) NSString * indicator;
@property (nonatomic, retain) NSString * landmark;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSString * localityCentre;
@property (nonatomic, retain) NSString * localityCode;
@property (nonatomic, retain) NSString * localityName;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSString * modification;
@property (nonatomic, retain) NSDate * modificationDate;
@property (nonatomic, retain) NSString * naptanCode;
@property (nonatomic, retain) NSNumber * northing;
@property (nonatomic, retain) NSString * notes;
@property (nonatomic, retain) NSString * parentLocalityName;
@property (nonatomic, retain) NSString * revisionNumber;
@property (nonatomic, retain) NSString * status;
@property (nonatomic, retain) NSString * fullTitle;
@property (nonatomic, retain) NSString * stopType;
@property (nonatomic, retain) NSString * street;
@property (nonatomic, retain) NSString * suburb;
@property (nonatomic, retain) NSString * timingStatus;
@property (nonatomic, retain) NSString * town;
@property (nonatomic, retain) NSString * uppercaseFirstLetterTitle;

@end
