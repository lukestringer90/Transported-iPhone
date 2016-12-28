//
//  TRNStopCell.h
//  Transport
//
//  Created by Luke Stringer on 06/04/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import "TRNCell.h"

@class TRNStop, TRNStopDistance;
@interface TRNStopCell : TRNCell

- (void)setupForStop:(TRNStop *)stop title:(NSString *)title;
- (void)setupForStop:(TRNStop *)stop title:(NSString *)title supplemtaryText:(NSString *)supplemtaryText;

@end
