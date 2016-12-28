//
//  TRNNearbyViewController.h
//  Transported
//
//  Created by Luke Stringer on 24/05/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TRNNearbyTableViewController : UITableViewController

@property (nonatomic, strong, readonly) NSManagedObjectContext *managedObjectContext;

- (instancetype)initWithContext:(NSManagedObjectContext *)managedObjectContext;

- (void)reloadData;

@end
