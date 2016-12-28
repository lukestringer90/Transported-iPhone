//
//  TRNStopsTableViewController.m
//  Transport
//
//  Created by Luke Stringer on 06/04/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import "TRNStopsTableViewController.h"
#import "TRNStop.h"
#import "TRNStopCell.h"
#import "TRNAppDelegate.h"
#import "TRNStop+Logic.h"
#import "TRNStopDataViewController.h"
#import "TRNStop+Logic.h"
#import "TRNUserStop.h"
#import "UIViewController+TRNAdditions.h"

@interface TRNStopsTableViewController () <NSFetchedResultsControllerDelegate>
@property (nonatomic, strong, readwrite) NSArray *sectionIndexes;
@end

@implementation TRNStopsTableViewController

- (instancetype)initWithContext:(NSManagedObjectContext *)context sectionIndexes:(NSArray *)sectionIndexes {
    self = [super initWithContext:context style:UITableViewStylePlain];
    self.title = @"All Stops";
    self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"All Stops" image:[UIImage imageNamed:@"stop-filled"] tag:1];
    
    /**
     *  If section indexes, add a UITableViewIndexSearch to the start for the search bar index
     */
    if (sectionIndexes) {
        self.sectionIndexes = [[NSArray arrayWithObject:UITableViewIndexSearch] arrayByAddingObjectsFromArray:sectionIndexes];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[TRNStopCell class]
           forCellReuseIdentifier:[TRNStopCell cellID]];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.searchController.searchBar.searchBarStyle = UISearchBarStyleMinimal;
    
    self.searchController.searchBar.backgroundColor = [UIColor whiteColor];
    self.searchController.searchBar.tintColor = [UIColor trn_barTintColor];
    self.searchController.searchBar.backgroundImage = [UIImage imageWithCGImage:(__bridge CGImageRef)([UIColor clearColor])];
    
    self.navigationController.navigationBar.barTintColor = [UIColor trn_barTintColor];
    self.navigationController.view.backgroundColor = [UIColor whiteColor];

    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    self.tableView.sectionIndexColor = [UIColor trn_barTintColor];
    
}

- (NSArray *)sortDescriptors {
    return @[[NSSortDescriptor sortDescriptorWithKey:@"fullTitle" ascending:YES], [NSSortDescriptor sortDescriptorWithKey:@"naptanCode" ascending:YES]];
}

#pragma mark - SJOSearchableFetchedResultsController

- (void)fetchedResultsController:(NSFetchedResultsController *)fetchedResultsController configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    TRNStop *stop = (TRNStop *)[fetchedResultsController objectAtIndexPath:indexPath];
    TRNStopCell *stopCell = (TRNStopCell *)cell;
    [stopCell setupForStop:stop title:stop.fullTitle];
}

- (NSFetchRequest *)fetchRequestForSearch:(NSString *)searchString {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([TRNStop class])];
    fetchRequest.predicate = [self predicateForSearchString:searchString];
    fetchRequest.fetchBatchSize = 50;
    fetchRequest.sortDescriptors = [self sortDescriptors];
    
    return fetchRequest;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:[TRNStopCell cellID]];
    [self fetchedResultsController:[self fetchedResultsControllerForTableView:tableView] configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (NSString *)sectionKeyPathForSearchableFetchedResultsController:(SQKFetchedTableViewController *)controller {
    return @"uppercaseFirstLetterTitle";
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 51.5;
}

#pragma mark - Other

- (NSPredicate *)predicateForSearchString:(NSString *)searchString {
    
    NSPredicate *predicate = nil;
    if (searchString.length > 0) {
        return [NSPredicate predicateWithFormat:@"commonName CONTAINS[c] %@ || street CONTAINS[c] %@", searchString, searchString];
    }
    return predicate;

}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TRNStop *stop = (TRNStop *)[self.activeFetchedResultsController objectAtIndexPath:indexPath];
    
    [self presentDataViewControllerForStop:stop];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    if (self.searchIsActive) {
        return nil;
    }
    return self.sectionIndexes;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    if (index == 0) {
        [tableView scrollRectToVisible:self.searchDisplayController.searchBar.frame animated:NO];
        return NSNotFound;
    }
    return index - 1;
}



@end
