//
//  TRNStopInfoViewController.h
//  Transport
//
//  Created by Luke Stringer on 27/04/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TRNStop;
@interface TRNStopDetailsViewController : UITableViewController

@property (nonatomic, strong, readonly) TRNStop *stop;

- (instancetype)initWithStop:(TRNStop *)stop title:(NSString *)title;


@end
