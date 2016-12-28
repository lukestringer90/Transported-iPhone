//
//  TRNHomeViewController.m
//  Transported
//
//  Created by Luke Stringer on 17/05/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import "TRNHomeViewController.h"
#import "TRNStopsTableViewController.h"
#import "TRNBusStopsTableViewController.h"
#import "TRNTramStopsTableViewController.h"
#import "TRNRecentViewController.h"
#import "TRNCell.h"
#import "TRNFavouriteStopsViewController.h"
#import "TRNStopDataViewController.h"
#import "TRNNearbyTableViewController.h"
#import "TRNNearbyParralaxViewController.h"
#import "UIViewController+TRNAdditions.h"
#import "TRNAboutViewController.h"
#import "TRNConstants.h"
#import <SQKDataKit/SQKContextManager.h>

typedef NS_ENUM(NSUInteger, HomeSection) {
    HomeSectionNearby,
    HomeSectionFavourites,
    HomeSectionStops,
    HomeSectionRecent,
    HomeSectionCount
};

typedef NS_ENUM(NSUInteger, StopsSectionRow) {
    StopsSectionRowAll,
    StopsSectionRowBus,
    StopsSectionRowTram,
    StopsSectionRowCount
};

@interface TRNHomeViewController ()
@property (nonatomic, strong, readwrite) SQKContextManager *contextManager;
@property (nonatomic, strong, readwrite) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong, readwrite) TRNStopsTableViewController *allStopsViewController;
@property (nonatomic, strong, readwrite) TRNBusStopsTableViewController *busStopsViewController;
@property (nonatomic, strong, readwrite) TRNTramStopsTableViewController *tramStopsViewController;
@property (nonatomic, strong, readwrite) TRNRecentViewController *recentViewController;
@property (nonatomic, strong) TRNFavouriteStopsViewController *favouritesViewController;
@property (nonatomic, strong) TRNNearbyParralaxViewController *nearbyParallaxViewController;
@property (nonatomic, strong) TRNAboutViewController *aboutViewController;
@property (nonatomic, strong) UINavigationController *aboutViewNavController;
@property (nonatomic, copy) NSArray *allStopsIndexes;
@property (nonatomic, copy) NSArray *busStopsSectionIndexes;
@property (nonatomic, copy) NSArray *tramStopsSectionIndexes;
@end

@implementation TRNHomeViewController

- (instancetype)initWithContextManager:(SQKContextManager *)contextManager {
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
        _contextManager = contextManager;
        _managedObjectContext = [contextManager mainContext];
        
        [self loadPrecomputedSectionIndexes];
        
        _allStopsViewController = [[TRNStopsTableViewController alloc] initWithContext:self.managedObjectContext
                                                                        sectionIndexes:self.allStopsIndexes];
        
        _busStopsViewController = [[TRNBusStopsTableViewController alloc] initWithContext:self.managedObjectContext
                                                                           sectionIndexes:self.busStopsSectionIndexes];
        
        _tramStopsViewController = [[TRNTramStopsTableViewController alloc] initWithContext:self.managedObjectContext
                                                                             sectionIndexes:self.tramStopsSectionIndexes];
        
        _recentViewController = [[TRNRecentViewController alloc] initWithContext:self.managedObjectContext];
        
        _favouritesViewController = [[TRNFavouriteStopsViewController alloc] initWithContext:self.managedObjectContext];
        
        _nearbyParallaxViewController = [[TRNNearbyParralaxViewController alloc] initWithContextManager:contextManager];
		
        _aboutViewController = [[TRNAboutViewController alloc] init];
        _aboutViewNavController = [[UINavigationController alloc] initWithRootViewController:_aboutViewController];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Transported";
    
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    
    [self.tableView registerClass:[TRNCell class] forCellReuseIdentifier:[TRNCell cellID]];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Home" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    UIButton *aboutButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
    [aboutButton addTarget:self action:@selector(showAbout) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:aboutButton];
    
    self.aboutViewNavController.navigationBar.barTintColor = self.navigationController.navigationBar.barTintColor;
    self.aboutViewNavController.navigationBar.tintColor = self.navigationController.navigationBar.tintColor;
    self.aboutViewNavController.navigationBar.translucent = self.navigationController.navigationBar.translucent;
    self.aboutViewNavController.navigationBar.barStyle = self.navigationController.navigationBar.barStyle;
    
    [self pushAndReloadNearbyAnimated:NO];
}

- (void)showAbout {
    [self.aboutViewController.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
    [self presentViewController:self.aboutViewNavController animated:YES completion:nil];
}


#pragma mark - Data loading

- (NSArray *)loadJSONArrayFromFileNamed:(NSString *)fileName {
    NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    
    return [NSJSONSerialization JSONObjectWithData:data
                                           options:kNilOptions
                                             error:NULL];
}

- (void)loadPrecomputedSectionIndexes {
    self.allStopsIndexes = [self loadJSONArrayFromFileNamed:TRNStopIndexesJSONFilename_All];
    self.busStopsSectionIndexes = [self loadJSONArrayFromFileNamed:TRNStopIndexesJSONFilename_Buses];
    self.tramStopsSectionIndexes = [self loadJSONArrayFromFileNamed:TRNStopIndexesJSONFilename_Trams];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return HomeSectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case HomeSectionFavourites:
            return 1;
            break;
            
        case HomeSectionStops:
            return StopsSectionRowCount;
            break;
            
        case HomeSectionRecent:
            return 1;
            break;
        case HomeSectionNearby:
            return 1;
            break;
            
        default:
            break;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    
    switch (indexPath.section) {
        case HomeSectionFavourites:
            cell = [tableView dequeueReusableCellWithIdentifier:[TRNCell cellID] forIndexPath:indexPath];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text = @"Favourites";
            cell.imageView.image = [UIImage imageNamed:@"star-filled"];
            break;
            break;
            
        case HomeSectionStops: {
            cell = [tableView dequeueReusableCellWithIdentifier:[TRNCell cellID] forIndexPath:indexPath];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            switch (indexPath.row) {
                case StopsSectionRowAll:
                    cell.textLabel.text = @"All Stops";
                    cell.imageView.image = [UIImage imageNamed:@"stop-filled"];
                    break;
                case StopsSectionRowBus:
                    cell.textLabel.text = @"Bus Stops";
                    cell.imageView.image = [UIImage imageNamed:@"bus-filled"];
                    break;
                case StopsSectionRowTram:
                    cell.textLabel.text = @"Sheffield Supertram Stops";
                    cell.imageView.image = [UIImage imageNamed:@"tram-filled"];
                    break;
                default:
                    break;
            }
        }
            break;
            
        case HomeSectionRecent:
            cell = [tableView dequeueReusableCellWithIdentifier:[TRNCell cellID] forIndexPath:indexPath];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text = @"Recently Viewed";
            cell.imageView.image = [UIImage imageNamed:@"clock-filled"];
            break;
            
        case HomeSectionNearby:
            cell = [tableView dequeueReusableCellWithIdentifier:[TRNCell cellID] forIndexPath:indexPath];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text = @"Nearby Stops";
            cell.imageView.image = [UIImage imageNamed:@"location-filled"];
            break;
            
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case HomeSectionFavourites:
            [self.navigationController pushViewController:self.favouritesViewController animated:YES];
            [self.favouritesViewController.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
            break;

        case HomeSectionStops:
            switch (indexPath.row) {
                case StopsSectionRowAll:
                    [self.navigationController pushViewController:self.allStopsViewController animated:YES];
                    [self.allStopsViewController.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
                    break;
                case StopsSectionRowBus:
                    [self.navigationController pushViewController:self.busStopsViewController animated:YES];
                    [self.busStopsViewController.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
                    break;
                case StopsSectionRowTram:
                    [self.navigationController pushViewController:self.tramStopsViewController animated:YES];
                    [self.tramStopsViewController.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
                    break;
                default:
                    break;
            }
            break;
        case HomeSectionRecent:
            [self.navigationController pushViewController:self.recentViewController animated:YES];
            [self.recentViewController.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
            break;
            
        case HomeSectionNearby:
            [self pushAndReloadNearbyAnimated:YES];
            break;
            
        default:
            break;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)pushAndReloadNearbyAnimated:(BOOL)animated {
    [CATransaction begin];
    [CATransaction setCompletionBlock: ^{
        [self.nearbyParallaxViewController reloadData];
    }];
    [self.navigationController pushViewController:self.nearbyParallaxViewController animated:animated];
    [CATransaction commit];

}

@end
