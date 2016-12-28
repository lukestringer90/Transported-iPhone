//
//  TRNTimeNotifcationManager.h
//  Transported
//
//  Created by Luke Stringer on 25/05/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const TRNReloadLiveDataNotification;

@interface TRNReloadLiveDataNotificationManager : NSObject

+ (void)startPostingNotifications;

@end
