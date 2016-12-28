//
//  TRNTramStopsTableViewController.m
//  Transport
//
//  Created by Luke Stringer on 12/04/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import "TRNTramStopsTableViewController.h"
#import "TRNStop+Logic.h"
#import "NSPredicate+TRNStop.h"
#import "TRNStop.h"
#import "TRNStopCell.h"

@implementation TRNTramStopsTableViewController

- (instancetype)initWithContext:(NSManagedObjectContext *)context sectionIndexes:(NSArray *)sectionIndexes {
    self = [super initWithContext:context sectionIndexes:sectionIndexes];
    self.title = @"Tram Stops";
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Tram Stops" style:UIBarButtonItemStylePlain target:nil action:nil];
    return self;
}

#pragma mark - TRNAllStopsTableViewController

- (NSPredicate *)predicateForSearchString:(NSString *)searchString {
    NSPredicate *searchPredicate = [super predicateForSearchString:searchString];
    
    NSMutableArray *subPredicates = [NSMutableArray arrayWithObject:[NSPredicate trn_tramsPredicate]];
    if (searchPredicate) {
        [subPredicates addObject:searchPredicate];
    }
    
    return [NSCompoundPredicate andPredicateWithSubpredicates:subPredicates];
}

- (void)fetchedResultsController:(NSFetchedResultsController *)fetchedResultsController configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    TRNStop *stop = (TRNStop *)[fetchedResultsController objectAtIndexPath:indexPath];
    TRNStopCell *stopCell = (TRNStopCell *)cell;
    [stopCell setupForStop:stop title:stop.cleanTitle];
}


@end
