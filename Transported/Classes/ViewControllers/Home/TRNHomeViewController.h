//
//  TRNHomeViewController.h
//  Transported
//
//  Created by Luke Stringer on 17/05/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SQKContextManager;
@interface TRNHomeViewController : UITableViewController

@property (nonatomic, strong, readonly) SQKContextManager *contextManager;

- (instancetype)initWithContextManager:(SQKContextManager *)contextManager;

@end
