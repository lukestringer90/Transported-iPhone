//
//  TRNStopMapSnapshotImageGenerator.h
//  Transport
//
//  Created by Luke Stringer on 29/04/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TRNStop;
@interface TRNStopMapSnapshotImageGenerator : NSObject

+ (void)generateMapSnapshotImageForStop:(TRNStop *)stop size:(CGSize)size completion:(void (^)(UIImage *mapSnapshotImage))completion;

@end
