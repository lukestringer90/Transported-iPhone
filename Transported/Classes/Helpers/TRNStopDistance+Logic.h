//
//  TRNStopDistance+Logic.h
//  Transported
//
//  Created by Luke Stringer on 24/05/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import "TRNStopDistance.h"

@class TRNStop;
@interface TRNStopDistance (Logic)

- (TRNStop *)fetchStop;
+ (NSFetchRequest *)nearbyFetchRequest;

@end