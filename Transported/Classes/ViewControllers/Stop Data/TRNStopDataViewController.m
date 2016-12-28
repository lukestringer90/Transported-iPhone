//
//  TRNStopModalViewController.m
//  Transport
//
//  Created by Luke Stringer on 26/04/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import "TRNStopDataViewController.h"
#import "TRNLiveDataViewController.h"
#import "TRNStopDetailsViewController.h"
#import "TRNStop+Logic.h"
#import "TRNUserStop+Logic.h"
#import "TRNReloadLiveDataNotificationManager.h"
#import "UIViewController+TRNAdditions.h"

@interface TRNStopDataViewController ()
@property (nonatomic, strong, readwrite) TRNStop *stop;
@property (nonatomic, strong, readwrite) TRNUserStop *userStop;
@property (nonatomic, strong, readwrite) TRNLiveDataViewController *liveDataViewController;
@property (nonatomic, strong, readwrite) TRNStopDetailsViewController *stopInfoViewController;
@end

@implementation TRNStopDataViewController

- (instancetype)initWithStop:(TRNStop *)stop title:(NSString *)title {
    CLS_LOG(@"Init TRNStopDataViewController for %@ - %@", stop.fullTitle, stop.naptanCode);
    
	TRNLiveDataViewController *liveDataViewController = [[TRNLiveDataViewController alloc] initWithStop:stop title:title];
    
    TRNStopDetailsViewController *stopInfoViewController = [[TRNStopDetailsViewController alloc] initWithStop:stop title:title];
    
    NSArray *viewControllers = @[liveDataViewController, stopInfoViewController];
    NSArray *titles = @[@"Live Departures", @"Stop Details"];
    
    if (self = [super initWithViewControllers:viewControllers title:titles]) {
        _stop = stop;
        _userStop = [self.stop insertOrFetchUserStop];
        _liveDataViewController = liveDataViewController;
        _stopInfoViewController = stopInfoViewController;
        
        UILabel *label = [[UILabel alloc] init];
        label.text = title;
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont boldSystemFontOfSize:16.0];
        label.adjustsFontSizeToFitWidth = YES;
        [label sizeToFit];
        self.navigationItem.titleView = label;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(downloadLiveDataWithViewVisibilityCheck)
                                                     name:TRNReloadLiveDataNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(downloadLiveDataWithViewVisibilityCheck)
                                                     name:UIApplicationWillEnterForegroundNotification
                                                   object:nil];
        
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:TRNReloadLiveDataNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.liveDataViewController.navigationController.navigationBar.translucent = NO;
    self.liveDataViewController.navigationController.navigationBar.barTintColor = [UIColor trn_barTintColor];
    self.stopInfoViewController.navigationController.navigationBar.translucent = NO;
    self.stopInfoViewController.navigationController.navigationBar.barTintColor = [UIColor trn_barTintColor];
    
    self.toolbar.barTintColor = [UIColor trn_barTintColor];
    self.toolbar.translucent = NO;
    self.segmentedControl.tintColor = [UIColor whiteColor];
    
    // Remove the shadow image view for the nav bar to get rid of white line divider with toolbar.
    
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    [navigationBar setBackgroundImage:[UIImage new]
                       forBarPosition:UIBarPositionAny
                           barMetrics:UIBarMetricsDefault];
    [navigationBar setShadowImage:[UIImage new]];
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Details"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:nil
                                                                            action:nil];
    
    [self setupFavouritesButton];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    // If popping
    if (self.parentViewController == nil) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }
}

- (void)setupFavouritesButton {
    UIImage *buttonImage;
    if ([self.userStop.favourited boolValue]) {
        buttonImage = [UIImage imageNamed:@"star-filled"];
    }
    else {
        buttonImage = [UIImage imageNamed:@"star-unfilled"];
    }
    
    UIBarButtonItem *favButton = [[UIBarButtonItem alloc] initWithImage:buttonImage
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(toggleStopFavourite)];
    
    self.navigationItem.rightBarButtonItem = favButton;
    
}

- (void)toggleStopFavourite {
    [self.userStop adjustOrderIndexesBySettingFavourited:![self.userStop.favourited boolValue]];
    [self.stop.managedObjectContext save:NULL];
    [self setupFavouritesButton];
    
    [[Mixpanel sharedInstance] track:@"Toggled Favourite Stop" properties:@{@"Stop Title" : self.stop.fullTitle}];
}

- (void)downloadLiveDataWithViewVisibilityCheck {
    if ([self viewIsVisible]) {
        [self.liveDataViewController reloadLiveData];
    }
}


@end
