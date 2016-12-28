//
//  TRNFavouriteStopsViewController.m
//  Transport
//
//  Created by Luke Stringer on 13/04/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import "TRNFavouriteStopsViewController.h"
#import "NSPredicate+TRNStop.h"
#import "TRNCell.h"
#import "TRNUserStop+Logic.h"
#import "TRNStop.h"

@interface TRNFavouriteStopsViewController ()
@property (nonatomic, strong) NSMutableArray *orderedFavourites;
@end

static NSString * const HelpCellID = @"HelpCellID";

@implementation TRNFavouriteStopsViewController

- (instancetype)initWithContext:(NSManagedObjectContext *)context {
    if (self = [super initWithContext:context]) {
        self.title = @"Favourites";
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Faves" style:UIBarButtonItemStylePlain target:nil action:nil];
        [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:HelpCellID];
        
    }
    return self;
}

- (NSPredicate *)userStopsPredicate {
    return [NSPredicate trn_favouritedPredicate];
}

- (NSArray *)sortDescriptors {
    return @[[NSSortDescriptor sortDescriptorWithKey:@"orderIndex" ascending:YES]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupRightBarButtonItem];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setTableHeaderView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self setupRightBarButtonItem];
}

- (void)startEditting {
    self.orderedFavourites = [[self.fetchedResultsController fetchedObjects] mutableCopy];
    
    [self.tableView setEditing:YES animated:YES];
    [self.navigationItem setHidesBackButton:YES animated:YES];
    [self setupRightBarButtonItem];
}

- (void)finishEditting {
    
    [CATransaction begin];
    [CATransaction setCompletionBlock: ^{
        // Re-order
        [self.orderedFavourites enumerateObjectsUsingBlock:^(TRNUserStop *userStop, NSUInteger idx, BOOL *stop) {
            userStop.orderIndex = @(idx);
        }];
        [self.managedObjectContext save:NULL];
        self.orderedFavourites = nil;
    }];
    [self.tableView setEditing:NO animated:YES];
    [self.navigationItem setHidesBackButton:NO animated:YES];
    [self setupRightBarButtonItem];
    [CATransaction commit];
}

- (void)setupRightBarButtonItem {
    if (self.fetchedResultsController.fetchedObjects.count > 0) {
        if (self.tableView.isEditing) {
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(finishEditting)];
        }
        else {
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Order" style:UIBarButtonItemStylePlain target:self action:@selector(startEditting)];
        }
    }
    else {
        [self.navigationItem setRightBarButtonItem:nil animated:YES];
    }
}

#pragma mark - NSFetchedResultsController

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [super controllerDidChangeContent:controller];
    
    [self setTableHeaderView];
}

#pragma mark - TableView

- (void)setTableHeaderView {
    if (self.fetchedResultsController.fetchedObjects.count == 0) {
        UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(header.frame), 50)];
        label.text = @"Favourite Stops by Tapping ★";
        label.textAlignment = NSTextAlignmentCenter;
        [header addSubview:label];
        header.backgroundColor = [UIColor trn_groupedTableViewBackgroundColor];
        self.tableView.tableHeaderView = header;
        
    }
    else {
        self.tableView.tableHeaderView = nil;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController.sections objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.isEditing) {
        return UITableViewCellEditingStyleNone;
    }
    return UITableViewCellEditingStyleDelete;
}

- (BOOL)tableView:(UITableView *)tableview shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (BOOL)tableView:(UITableView *)tableview canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    TRNUserStop *userStop = self.orderedFavourites[sourceIndexPath.row];
    [self.orderedFavourites removeObject:userStop];
    [self.orderedFavourites insertObject:userStop atIndex:destinationIndexPath.row];
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"Remove";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    TRNUserStop *userStop = [self.fetchedResultsController objectAtIndexPath:indexPath];
    userStop.favourited = @(NO);
    [self.managedObjectContext save:NULL];
    [self setupRightBarButtonItem];
}


@end
