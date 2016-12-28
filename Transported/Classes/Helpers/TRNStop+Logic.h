//
//  TRNStop+Logic.h
//  Transport
//
//  Created by Luke Stringer on 24/04/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import "TRNStop.h"

typedef NS_ENUM(NSInteger, TRNStopType) {
    TRNStopTypeBus,
	TRNStopTypeTram,
	TRNStopTypeOther
};

typedef NS_ENUM(NSInteger, TRNStopArea) {
    TRNStopAreaWestYorkshire,
	TRNStopAreaSouthYorkshire,
    TRNStopAreaNone
};

@class TRNUserStop;
@interface TRNStop (Logic)

- (TRNStopArea)area;
- (TRNStopType)type;
- (TRNUserStop *)insertOrFetchUserStop;
- (NSString *)cleanTitleByRemovingOccurencesOfString:(NSArray *)strings;

@end
