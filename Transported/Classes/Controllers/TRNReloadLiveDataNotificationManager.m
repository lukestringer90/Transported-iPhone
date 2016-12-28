//
//  TRNTimeNotifcationManager.m
//  Transported
//
//  Created by Luke Stringer on 25/05/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import "TRNReloadLiveDataNotificationManager.h"

NSString * const TRNReloadLiveDataNotification = @"TRNReloadLiveDataNotification";

@implementation TRNReloadLiveDataNotificationManager

#pragma mark - Singleton setup
+ (void)startPostingNotifications {
    [[TRNReloadLiveDataNotificationManager sharedInstance] setupReloadLiveDataNotification];
}

+ (TRNReloadLiveDataNotificationManager *)sharedInstance {
    static TRNReloadLiveDataNotificationManager *sharedSingleton;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedSingleton = [[TRNReloadLiveDataNotificationManager alloc] init];
    });
    
    return sharedSingleton;
}

- (void)setupReloadLiveDataNotification {
    // Call again when next minute arrives
    // Add a offset og n seconds so live departures HTML has chance to change
    // for the new minute
    NSDate *now = [NSDate date];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSSecondCalendarUnit fromDate:now];
    NSInteger secondsUntilNextMinute = 60 - [components second];


    NSInteger offset = 5;
    [self performSelector:@selector(sendReloadLiveDataNotification) withObject:nil afterDelay:secondsUntilNextMinute+offset];
    
}

- (void)sendReloadLiveDataNotification {
    [[NSNotificationCenter defaultCenter] postNotificationName:TRNReloadLiveDataNotification object:nil];
    [self setupReloadLiveDataNotification];
}

@end
