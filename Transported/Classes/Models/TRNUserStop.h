//
//  TRNUserStop.h
//  Transported
//
//  Created by Luke Stringer on 31/05/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface TRNUserStop : NSManagedObject

@property (nonatomic, retain) NSNumber * favourited;
@property (nonatomic, retain) NSDate * lastViewDate;
@property (nonatomic, retain) NSString * naptanCode;
@property (nonatomic, retain) NSNumber * orderIndex;

@end
