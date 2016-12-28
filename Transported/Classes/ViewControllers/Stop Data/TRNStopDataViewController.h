//
//  TRNStopModalViewController.h
//  Transport
//
//  Created by Luke Stringer on 26/04/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import "TRNSegmentedTabBarController.h"

@class TRNStop, TRNLiveDataViewController;
@interface TRNStopDataViewController : TRNSegmentedTabBarController
@property (nonatomic, strong, readonly) TRNStop *stop;
@property (nonatomic, strong, readonly) TRNLiveDataViewController *liveDataViewController;

- (instancetype)initWithStop:(TRNStop *)stop title:(NSString *)title;

@end
