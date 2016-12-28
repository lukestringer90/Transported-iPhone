//
//  TRNAppDelegate.m
//  Transport
//
//  Created by Luke Stringer on 3/30/14
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import "TRNAppDelegate.h"
#import "TRNHomeViewController.h"
#import "TRNCoreDataManager.h"
#import "TRNLiveDataSaver.h"
#import <SQKDataKit/SQKContextManager.h>
#import "TRNReloadLiveDataNotificationManager.h"
#import "TRNUserStop.h"
#import "TRNDatabaseVersion.h"
#import "TRNFavouriteBackup.h"

#if TARGET_IPHONE_SIMULATOR
#define isSimulator() YES
#else
#define isSimulator() NO
#endif

static NSString * const MIXPANEL_TOKEN = nil;
static NSString * const CRASHLYTICS_API_KEY = nil;

@interface TRNAppDelegate ()
@property (nonatomic, strong) SQKContextManager *contextManager;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong, readwrite) UITabBarController *tabBarController;
@end

@implementation TRNAppDelegate

// Helper function to see if we are running the production target or the test target
static BOOL isRunningTests(void) __attribute__((const));
static BOOL isRunningTests(void) {
    NSDictionary* environment = [[NSProcessInfo processInfo] environment];
    NSString* injectBundle = environment[@"XCInjectBundle"];
    return [[injectBundle pathExtension] isEqualToString:@"octest"] || [[injectBundle pathExtension] isEqualToString:@"xctest"];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	if (isRunningTests()) return YES;
    
    if (CRASHLYTICS_API_KEY) {
        [Crashlytics startWithAPIKey:CRASHLYTICS_API_KEY];
    }

    if (!isSimulator() && MIXPANEL_TOKEN) {
        NSString *deviceUUID = [[[UIDevice currentDevice] identifierForVendor].UUIDString substringToIndex:5];
        [Mixpanel sharedInstanceWithToken:MIXPANEL_TOKEN];
        [[Mixpanel sharedInstance] identify:deviceUUID];
        [[Mixpanel sharedInstance].people set:@{@"$name": deviceUUID}];
    }
    
    NSInteger currentDatabaseVersionNumber = [TRNDatabaseVersion currentDatabaseVersionNumber];
    NSInteger staticDatabaseVersionNumber = [TRNDatabaseVersion staticDatabaseVersionNumber];
    
    if (currentDatabaseVersionNumber < staticDatabaseVersionNumber) {
        NSLog(@"Backing up faves and loading new DB");
        TRNFavouriteBackup *backup = [TRNFavouriteBackup new];
        [backup createBackup];
        
        [TRNCoreDataManager loadPrecomputedSQLiteData];
        [TRNDatabaseVersion setCurrentDatabaseVersion:staticDatabaseVersionNumber];
        
        [backup restoreBackup];
    }
    
    self.contextManager = [[SQKContextManager alloc] initWithPersistentStoreCoordinator:[TRNCoreDataManager persistentStoreCoordinator]];
    self.managedObjectContext = [self.contextManager mainContext];
    
    [TRNReloadLiveDataNotificationManager startPostingNotifications];
	
	[self setupViewHierarchy];
    
    
    return YES;
}


- (void)setupViewHierarchy {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
	
	TRNHomeViewController *homeViewController = [[TRNHomeViewController alloc] initWithContextManager:self.contextManager];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:homeViewController];
    navigationController.navigationBar.tintColor = [UIColor trn_lightBlue];
    navigationController.navigationBar.barTintColor = [UIColor trn_barTintColor];
    navigationController.navigationBar.translucent = NO;
    navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    
    self.window.rootViewController = navigationController;
    [self.window makeKeyAndVisible];
}

#pragma mark - Status bar

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

@end
