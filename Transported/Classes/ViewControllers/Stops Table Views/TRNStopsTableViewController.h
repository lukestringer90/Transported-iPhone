//
//  TRNStopsTableViewController.h
//  Transport
//
//  Created by Luke Stringer on 06/04/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SQKDataKit/SQKFetchedTableViewController.h>

@interface TRNStopsTableViewController : SQKFetchedTableViewController

@property (nonatomic, readonly, strong) NSArray *sectionIndexes;

- (instancetype)initWithContext:(NSManagedObjectContext *)context sectionIndexes:(NSArray *)sectionIndexes;

/**
 *  Can be overriden
 */
- (NSPredicate *)predicateForSearchString:(NSString *)searchString;
- (NSArray *)sortDescriptors;

@end
