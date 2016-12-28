//
//  TRNLiveDataViewController.m
//  Transport
//
//  Created by Luke Stringer on 30/03/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import "TRNLiveDataViewController.h"
#import "TRNDepartureCell.h"
#import "TRNStop+Logic.h"
#import <LJSYourNextBus/LJSSouthYorkshireClient.h>
#import <LJSYourNextBus/LJSWestYorkshireClient.h>
#import <LJSYourNextBus/LJSStop.h>
#import <LJSYourNextBus/LJSService.h>
#import <LJSYourNextBus/LJSDeparture.h>
#import "TRNLiveDataTableHeaderView.h"
#import "UIViewController+TRNAdditions.h"
#import "TRNLiveDataSaver.h"
#import <LJSYourNextBus/LJSLiveDataResult.h>

@interface TRNLiveDataViewController () <LJSYourNextBusClientDelegate, LJSYourNextBusScrapeDelegate, UIAlertViewDelegate>
@property (nonatomic, strong, readwrite) TRNStop *stop;
@property (nonatomic, strong, readwrite) NSString *HTML;
@property (nonatomic, strong) LJSStop *liveStop;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, copy) NSArray *allDepartures;
@property (nonatomic, strong) LJSYourNextBusClient *yourNextBusClient;
@property (nonatomic, strong) TRNLiveDataTableHeaderView *tableViewHeaderView;
@property (nonatomic, assign) BOOL shoulApplyTopInset;
@property (nonatomic, assign, getter = isShowingErrorAlert) BOOL showingErrorAlert;
@end

@implementation TRNLiveDataViewController

#pragma mark - Init and View Load

- (instancetype)initWithStop:(TRNStop *)stop title:(NSString *)title {
    if (!stop) {
        return nil;
    }
    if (self = [super initWithStyle:UITableViewStylePlain]) {
		self.stop = stop;
        self.title = title;
        [self commonInit];
	}
	return self;
}


- (void)commonInit {
    switch ([self.stop area]) {
        case TRNStopAreaSouthYorkshire:
            self.yourNextBusClient = [LJSSouthYorkshireClient new];
            break;
        case TRNStopAreaWestYorkshire:
            self.yourNextBusClient = [LJSWestYorkshireClient new];
            break;
        case TRNStopAreaNone:
            // TODO: Show error
            break;
            
        default:
            break;
    }
    self.yourNextBusClient.clientDelegate = self;
	self.yourNextBusClient.scrapeDelegate = self;
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    self.dateFormatter.timeStyle = NSDateFormatterShortStyle;
    
    [self.tableView registerClass:[TRNDepartureCell class] forCellReuseIdentifier:NSStringFromClass([TRNDepartureCell class])];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableViewHeaderView = [[TRNLiveDataTableHeaderView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 50)];
    self.tableView.tableHeaderView = self.tableViewHeaderView;
    self.shoulApplyTopInset = NO;
    
    [self reloadLiveData];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    if (self.shoulApplyTopInset) {
        CGFloat topInset = -12 ;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
        self.tableView.contentInset = UIEdgeInsetsMake(topInset, 0, 0, 0);
        [UIView commitAnimations];
    }
}


#pragma mark - Live data

- (void)reloadLiveData {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    [TRNLiveDataSaver clearSavedValues];
    [self.yourNextBusClient getLiveDataForNaPTANCode:self.stop.naptanCode];
}

- (void)handleLiveDataDownloadError:(NSError *)error {
    
    BOOL existingDepartures = self.allDepartures != nil;
    BOOL noNetworkConnection = error.code == 256;
    
    if ([self viewIsVisible] && !self.isShowingErrorAlert) {
        
        if (noNetworkConnection && existingDepartures) {
            return;
        }
        
        NSString *message;
        if (noNetworkConnection) {
            message = @"There appears to be no internet connection.";
        }
        else {
            message = @"There was a problem with this stop's live data.";
        }
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Departures Unavailable"
                              message:message
                              delegate:self
                              cancelButtonTitle:@"Okay"
                              otherButtonTitles: nil];
        [alert show];
        self.showingErrorAlert = YES;
    }
}

- (void)setupViewForLiveStop:(LJSStop *)liveStop {
    self.liveStop = liveStop;
    self.title = self.title == nil ? liveStop.title : self.title;
    self.allDepartures = [liveStop sortedDepartures];
    
    self.tableViewHeaderView.showInitialDownloadLabel = NO;
    self.tableViewHeaderView.titleLabel.text = [NSString stringWithFormat:@"Showing Departures for %@", [self.dateFormatter stringFromDate:self.liveStop.liveDate]];
    [self.tableViewHeaderView setNeedsLayout];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 60;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.allDepartures != nil ? self.allDepartures.count : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    /**
     *  Show departures
     */
    if (self.allDepartures.count > 0) {
        TRNDepartureCell *departureCell = (TRNDepartureCell *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TRNDepartureCell class])];
        
        LJSDeparture *departure = self.allDepartures[indexPath.row];
        departureCell.destinationLabel.text = departure.destination;
        departureCell.serviceTitleLabel.text = departure.service.title;
        departureCell.lowFloorAccessLabelVisible = departure.hasLowFloorAccess;
        
        if (departure.minutesUntilDeparture <= 10) {
            departureCell.expectedDepartureLabel.text = departure.countdownString;
        }
        else {
            departureCell.expectedDepartureLabel.text = [self.dateFormatter stringFromDate:departure.expectedDepartureDate];
        }
        
        return departureCell;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];;
    
    /**
     *  Show no departures label if a stop is returned without any departures
     */
    if (self.liveStop) {
        cell.textLabel.text = @"No Departures in Next Hour";
    }
    
    return cell;
}

#pragma mark - LJSYourNextBusScrapeDelegate

- (void)client:(LJSYourNextBusClient *)client returnedLiveDataResult:(LJSLiveDataResult *)result
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    LJSStop *liveStop = result.stop;
    
    [self setupViewForLiveStop:liveStop];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    self.shoulApplyTopInset = YES;
    
    NSDictionary *properties = @{
                                 @"NaPTAN" : liveStop.NaPTANCode ? liveStop.NaPTANCode : [NSNull null],
                                 @"Stop Title" : liveStop.title ? liveStop.title : [NSNull null],
                                 @"Messages" : result.messages ? result.messages :  [NSNull null]
                                 };
    
    [[Mixpanel sharedInstance] track:@"Downloaded Live Data"
                          properties:properties];
    
}
- (void)client:(LJSYourNextBusClient *)client failedWithError:(NSError *)error NaPTANCode:(NSString *)NaPTANCode
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [self handleLiveDataDownloadError:error];
    
    NSDictionary *properties = @{
                                 @"NaPTAN" : self.stop.naptanCode ? self.stop.naptanCode : [NSNull null],
                                 @"Stop Title" : self.stop.fullTitle ? self.stop.fullTitle : [NSNull null],
                                 @"Error" : [error description] ? [error description] : [NSNull null],
                                 @"HTML" : self.HTML ? self.HTML : [NSNull null]
                                 };
    
    [[Mixpanel sharedInstance] track:@"Downloaded Live Data Failure"
                          properties:properties];
}

#pragma mark - LJSYourNextBusScrapeDelegate

- (void)client:(LJSYourNextBusClient *)client willScrapeHTML:(NSString *)HTML NaPTANCode:(NSString *)NaPTANCode {
    self.HTML = HTML;
    [TRNLiveDataSaver saveHTML:HTML NaPTANCode:NaPTANCode];
}


#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    self.showingErrorAlert = NO;
}

@end
