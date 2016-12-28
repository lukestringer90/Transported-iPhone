//
//  TRNNearbyParralaxViewController.m
//  Transported
//
//  Created by Luke Stringer on 25/05/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import "TRNNearbyParralaxViewController.h"
#import "TRNNearbyTableViewController.h"
#import "TRNStopDistanceController.h"
#import <INTULocationManager/INTULocationManager.h>
#import "TRNStopDistance.h"
#import "TRNNearbyMapViewController.h"
#import "UIViewController+TRNAdditions.h"
#import <SQKDataKit/SQKContextManager.h>

@interface TRNNearbyParralaxViewController () <QMBParallaxScrollViewControllerDelegate, TRNStopDistanceControllerDelegate, QMBParallaxScrollViewControllerDelegate>
@property (nonatomic, strong, readwrite) SQKContextManager *contextManager;
@property (nonatomic, strong, readwrite) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong, readwrite) TRNNearbyTableViewController *nearbyTableViewController;
@property (nonatomic, strong, readwrite) TRNNearbyMapViewController *mapViewController;
@property (nonatomic, strong, readwrite) TRNStopDistanceController *stopsDistanceController;
@property (nonatomic, strong, readwrite) CLLocation *currentLocation;
@end

@implementation TRNNearbyParralaxViewController

- (instancetype)initWithContextManager:(SQKContextManager *)contextManager {
    if (self = [super init]) {
        _contextManager = contextManager;
        _managedObjectContext = [contextManager mainContext];
        
        _stopsDistanceController = [[TRNStopDistanceController alloc] initWithContextManager:contextManager];
        _stopsDistanceController.delegate = self;
        [_stopsDistanceController removeAllStopDistancesInContext:_managedObjectContext save:YES];
        
        _nearbyTableViewController = [[TRNNearbyTableViewController alloc] initWithContext:self.managedObjectContext];
        
        _mapViewController = [[TRNNearbyMapViewController alloc] initWithContext:self.managedObjectContext];
        
        self.delegate = self;
        
        self.title = @"Nearby";
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(reloadData)
                                                     name:UIApplicationWillEnterForegroundNotification
                                                   object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    // If popping
    if (self.parentViewController == nil) {
        [self.stopsDistanceController removeAllStopDistancesInContext:self.managedObjectContext save:YES];
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.barTintColor = [UIColor trn_barTintColor];
    self.navigationController.navigationBar.translucent = NO;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGFloat viewHeight = CGRectGetHeight(self.view.frame);
    
    [self setupWithTopViewController:self.mapViewController andTopHeight:(CGFloat)(viewHeight * 0.4) andBottomViewController:self.nearbyTableViewController];
    self.maxHeight = viewHeight - 117; // just enough to see a single row
}


- (void)setRefreshButton {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(reloadData)];
}

- (void)setRefreshingActivityView {
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [activityIndicator startAnimating];
    [activityIndicator sizeToFit];
    activityIndicator.color = [UIColor trn_lightBlue];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:activityIndicator];
}

- (void)reloadData {
    
    if ([self viewIsVisible]) {
        [self setRefreshingActivityView];
        
        INTULocationManager *locMgr = [INTULocationManager sharedInstance];
        [locMgr requestLocationWithDesiredAccuracy:INTULocationAccuracyNeighborhood
                                           timeout:10.0
                              delayUntilAuthorized:YES
                                             block:^(CLLocation *currentLocation, INTULocationAccuracy achievedAccuracy, INTULocationStatus status) {
                                                 if (status == INTULocationStatusSuccess) {
                                                     self.currentLocation = currentLocation;
                                                     [self.stopsDistanceController asyncGenerateStopDistancesForLocation:currentLocation maxDistance:TRNNearbyStopsMaxDistance];
                                                 }
                                                 else {
                                                     [self finishedGeneratingStopDistances:self.stopsDistanceController];
                                                 }
                                             }];
    }
}

#pragma mark - TRNStopDistanceControllerDelegate

- (void)finishedGeneratingStopDistances:(TRNStopDistanceController *)controller {
    [self.nearbyTableViewController reloadData];
    [self.mapViewController reloadMapAtCentre:[self.currentLocation coordinate] reloadAnnotations:YES];
    [self setRefreshButton];
}



#pragma mark - QMBParallaxScrollViewController
- (void)parallaxScrollViewController:(QMBParallaxScrollViewController *)controller didChangeState:(QMBParallaxState)state {    
    [controller enableTapGestureTopView:state == QMBParallaxStateVisible];
    
    switch (state) {
        case QMBParallaxStateVisible:
            [[Mixpanel sharedInstance] track:@"Nearby List Viewed"];
            break;
            
        case QMBParallaxStateFullSize:
            [[Mixpanel sharedInstance] track:@"Fullsize Nearby MapView Viewed"];
            break;
            
        default:
            break;
    }
    
    
    [self.mapViewController reloadMapAtCentre:[self.currentLocation coordinate] reloadAnnotations:NO];
}


@end
