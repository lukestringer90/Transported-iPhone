//
//  TRNStopDistance.h
//  Transported
//
//  Created by Luke Stringer on 24/05/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface TRNStopDistance : NSManagedObject

@property (nonatomic, retain) NSNumber * distance;
@property (nonatomic, retain) NSString * naptanCode;

@end
