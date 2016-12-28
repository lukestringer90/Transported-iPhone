//
//  TRNLiveDataViewController.h
//  Transport
//
//  Created by Luke Stringer on 30/03/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TRNStop;
@interface TRNLiveDataViewController : UITableViewController

@property (nonatomic, strong, readonly) TRNStop *stop;

- (instancetype)initWithStop:(TRNStop *)stop title:(NSString *)title;

- (void)reloadLiveData;

@end
