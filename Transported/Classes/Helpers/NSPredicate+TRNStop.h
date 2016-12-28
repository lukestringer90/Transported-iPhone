//
//  NSPredicate+TRNStop.h
//  Transport
//
//  Created by Luke Stringer on 14/04/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CLLocation;
@interface NSPredicate (TRNStop)

+ (NSPredicate *)trn_favouritedPredicate;
+ (NSPredicate *)trn_recentPredicate;
+ (NSPredicate *)trn_tramsPredicate;
+ (NSPredicate *)trn_busesPredicate;
+ (NSPredicate *)trn_predicateForMaxDistance:(CGFloat)maxDistance location:(CLLocation *)location;

@end
