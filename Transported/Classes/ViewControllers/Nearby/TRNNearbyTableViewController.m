//
//  TRNNearbyViewController.m
//  Transported
//
//  Created by Luke Stringer on 24/05/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import "TRNNearbyTableViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "TRNStopCell.h"
#import "TRNStopDistance.h"
#import <Masonry/Masonry.h>
#import <AddressBookUI/AddressBookUI.h>
#import "TRNStopDataViewController.h"
#import "TRNStop+Logic.h"
#import "TRNStopDistance+Logic.h"
#import "TRNUserStop.h"
#import "UIViewController+TRNAdditions.h"

@interface TRNNearbyTableViewController ()
@property (nonatomic, strong, readwrite) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong, readwrite) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, assign) BOOL performedFetch;
@end

@implementation TRNNearbyTableViewController

- (instancetype)initWithContext:(NSManagedObjectContext *)managedObjectContext {
    if (self = [super initWithStyle:UITableViewStylePlain]) {
        _managedObjectContext = managedObjectContext;
        self.tableView.scrollsToTop = YES;
        
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.tableView.frame), 1)];
        headerView.backgroundColor = [UIColor trn_barTintColor];
        self.tableView.tableHeaderView = headerView;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[TRNStopCell class] forCellReuseIdentifier:[TRNStopCell cellID]];
}

- (void)reloadData {
    [self.fetchedResultsController performFetch:NULL];
    self.performedFetch = YES;
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
}


#pragma mark - NSFetchedResultsController setup

- (NSFetchedResultsController *)fetchedResultsController {
    if (!_fetchedResultsController) {
        _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:[TRNStopDistance nearbyFetchRequest] managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    }
    return _fetchedResultsController;
}



#pragma mark - UITableViewController


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController.sections objectAtIndex:section];
    
    if ([sectionInfo numberOfObjects] == 0) {
        return 1;
    }
    
    return [sectionInfo numberOfObjects];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 51.5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[TRNStopCell cellID]];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    TRNStopCell *stopCell = (TRNStopCell *)cell;
    BOOL fetchedDataAvaible = self.fetchedResultsController.fetchedObjects.count > 0;
    if (fetchedDataAvaible) {
        TRNStopDistance *stopDistance = [self.fetchedResultsController.fetchedObjects objectAtIndex:indexPath.row];
        TRNStop *stop = [stopDistance fetchStop];
        [stopCell setupForStop:stop title:stop.fullTitle supplemtaryText:[NSString stringWithFormat:@"%li m", (long)[stopDistance.distance integerValue]]];
    }
    else if (self.performedFetch) {
        cell.textLabel.text = @"No Nearby Stops";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
	else {
        cell.textLabel.text = @"Finding Nearby Stops...";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BOOL fetchedDataAvaible = self.fetchedResultsController.fetchedObjects.count > 0;
    if (fetchedDataAvaible) {
        TRNStopDistance *stopDistance = [self.fetchedResultsController.fetchedObjects objectAtIndex:indexPath.row];
        TRNStop *stop = [stopDistance fetchStop];
        [self presentDataViewControllerForStop:stop];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}


@end
