//
//  TRNRecentStopsViewController.h
//  Transport
//
//  Created by Luke Stringer on 12/04/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface TRNUserStopsTableViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong, readonly) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong, readonly) NSManagedObjectContext *managedObjectContext;

- (instancetype)initWithContext:(NSManagedObjectContext *)managedObjectContext;

- (NSPredicate *)userStopsPredicate;
- (NSArray *)sortDescriptors;

@end
