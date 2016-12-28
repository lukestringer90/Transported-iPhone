//
//  TRNRecentStopsViewController.m
//  Transport
//
//  Created by Luke Stringer on 12/04/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import "TRNUserStopsTableViewController.h"
#import "TRNStop.h"
#import "TRNUserStop.h"
#import "TRNStopCell.h"
#import "TRNUserStop+Logic.h"
#import "TRNStop+Logic.h"
#import "TRNStopDataViewController.h"
#import "UIViewController+TRNAdditions.h"

@interface TRNUserStopsTableViewController () <NSFetchedResultsControllerDelegate>
@property (nonatomic, strong, readwrite) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong, readwrite) NSFetchedResultsController *fetchedResultsController;
@end

@implementation TRNUserStopsTableViewController

- (instancetype)initWithContext:(NSManagedObjectContext *)managedObjectContext {
    if (self = [super initWithStyle:UITableViewStylePlain]) {
        _managedObjectContext = managedObjectContext;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[TRNStopCell class]
           forCellReuseIdentifier:[TRNStopCell cellID]];
    
    
    [self.fetchedResultsController performFetch:NULL];
    
    self.navigationController.navigationBar.barTintColor = [UIColor trn_barTintColor];
    self.navigationController.navigationBar.translucent = NO;
    
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
}

#pragma mark - NSFetchedResultsController setup

- (NSFetchedResultsController *)fetchedResultsController {
    if (!_fetchedResultsController) {
        NSFetchRequest *fetchRequest = [self userStopsFetchRequest];
        NSFetchedResultsController *newFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
        newFetchedResultsController.delegate = self;
        _fetchedResultsController = newFetchedResultsController;
    }
    return _fetchedResultsController;
}

- (NSFetchRequest *)userStopsFetchRequest {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([TRNUserStop class])];
    fetchRequest.predicate = [self userStopsPredicate];
    fetchRequest.sortDescriptors = [self sortDescriptors];
    
    return fetchRequest;
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)theIndexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:theIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[self.tableView cellForRowAtIndexPath:theIndexPath] atIndexPath:theIndexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:theIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}

#pragma mark - Overridden

- (NSPredicate *)userStopsPredicate {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

- (NSArray *)sortDescriptors {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

#pragma mark - UITableViewController

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.fetchedResultsController.sections.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController.sections objectAtIndex:section];
    return [sectionInfo numberOfObjects];
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 51.5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:[TRNStopCell cellID]];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    TRNUserStop *userStop = [self.fetchedResultsController objectAtIndexPath:indexPath];
    TRNStop *stop = [userStop fetchStop];
    TRNStopCell *stopCell = (TRNStopCell *)cell;
    [stopCell setupForStop:stop title:stop.fullTitle];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TRNUserStop *userStop = [self.fetchedResultsController objectAtIndexPath:indexPath];
    TRNStop *stop = [userStop fetchStop];
    [self presentDataViewControllerForStop:stop];
}

- (NSArray *)stringsToCleanFromTitle {
    /**
     *  Always clean Supertram.
     */
    return @[@"(Supertram)"];
}


@end
