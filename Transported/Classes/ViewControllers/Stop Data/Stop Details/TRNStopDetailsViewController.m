//
//  TRNStopInfoViewController.m
//  Transport
//
//  Created by Luke Stringer on 27/04/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import "TRNStopDetailsViewController.h"
#import "TRNStop.h"
#import "TRNStopMapCell.h"
#import "TRNStopAddressCell.h"
#import <INTULocationManager/INTULocationManager.h>
#import "TRNStopMapSnapshotImageGenerator.h"
#import <uservoice-iphone-sdk/UserVoice.h>
#import "UVConfig+TRNConfig.h"
#import "TRNStopMapViewController.h"

typedef NS_ENUM(NSInteger, TableViewSection) {
    TableViewSectionLocation,
    TableViewSectionActions,
    TableViewSectionCount
};

typedef NS_ENUM(NSInteger, LocationRow) {
    LocationRowAddress,
    LocationRowMap,
    LocationRowDirections,
    LocationRowCount
};

typedef NS_ENUM(NSInteger, ActionRow) {
    ActionRowCount,
};

@interface TRNStopDetailsViewController () <UIActionSheetDelegate, TRNStopMapViewControllerDelegate>
@property (nonatomic, strong, readwrite) TRNStop *stop;
@property (nonatomic, strong) UIImageView *mapImageView;
@property (nonatomic, assign) CGFloat mapImageYOffset;
@property (nonatomic, strong) TRNStopMapViewController *mapViewController;
@end

@implementation TRNStopDetailsViewController

- (instancetype)initWithStop:(TRNStop *)stop title:(NSString *)title {
    if (!stop) {
        return nil;
    }
    
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
        self.stop = stop;
        self.title = title;
        
        [TRNStopMapSnapshotImageGenerator generateMapSnapshotImageForStop:self.stop size:CGSizeMake(CGRectGetWidth(self.tableView.frame), 180.0f) completion:^(UIImage *mapSnapshotImage) {
            self.mapImageView = [[UIImageView alloc] initWithImage:mapSnapshotImage];
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:LocationRowMap inSection:TableViewSectionLocation]]
                                  withRowAnimation:UITableViewRowAnimationAutomatic];
        }];
        
        [self.tableView registerClass:[TRNStopAddressCell class] forCellReuseIdentifier:[TRNStopAddressCell cellID]];
        [self.tableView registerClass:[TRNStopMapCell class] forCellReuseIdentifier:[TRNStopMapCell cellID]];
        [self.tableView registerClass:[TRNCell class] forCellReuseIdentifier:[TRNCell cellID]];
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
        self.tableView.tableFooterView = [self tableViewFooterView];
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.barTintColor = [UIColor trn_barTintColor];
    self.navigationController.navigationBar.translucent = NO;
}

- (TRNStopMapViewController *)mapViewController {
    if (!_mapViewController) {
        _mapViewController = [[TRNStopMapViewController alloc] initWithStop:self.stop];
        _mapViewController.delegate = self;
    }
    return _mapViewController;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return TableViewSectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case TableViewSectionLocation:
            return LocationRowCount;
            break;
        case TableViewSectionActions:
            return ActionRowCount;
            break;
            
        default:
            break;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell;
    
    switch (indexPath.section) {
        case TableViewSectionLocation:
            switch (indexPath.row) {
                case LocationRowAddress: {
                    TRNStopAddressCell *addressCell = [tableView dequeueReusableCellWithIdentifier:[TRNStopAddressCell cellID]];
                    addressCell.titleLabel.text = self.title;
                    addressCell.streetLabel.text = self.stop.street;
                    addressCell.localityLabel.text = self.stop.localityName;
                    addressCell.stopType = [self.stop type];
                    addressCell.naptanCodeLabel.text = [NSString stringWithFormat:@"Stop code: %@", self.stop.naptanCode];
                    if ([self.stop type] == TRNStopTypeBus) {
                        addressCell.bearingIndicatorLabel.text = [NSString stringWithFormat:@"%@ ←", self.stop.bearing];
                    }
                    else {
                        addressCell.bearingIndicatorLabel.text = self.stop.indicator;
                    }
                    cell = addressCell;
                }
                    break;
                case LocationRowMap:
                    cell = [tableView dequeueReusableCellWithIdentifier:[TRNStopMapCell cellID]];
                    [cell.contentView addSubview:self.mapImageView];
                    break;
                case LocationRowDirections:
                    cell = [tableView dequeueReusableCellWithIdentifier:[TRNStopMapCell cellID]];
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
                    cell.textLabel.text = @"Directions to Stop";
                    break;
                default:
                    break;
            }
            break;
            
        case TableViewSectionActions:
            break;
            
        default:
            break;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case TableViewSectionLocation:
            switch (indexPath.row) {
                case LocationRowAddress:
                    break;
                case LocationRowMap:
//                    [self.navigationController pushViewController:self.mapViewController animated:YES];
                    break;
                case LocationRowDirections:
                    [self showDirectionsForStop:self.stop];
                    break;
                default:
                    break;
            }
            break;
            
        case TableViewSectionActions:
            break;
            
        default:
            break;
    }
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case TableViewSectionLocation:
            switch (indexPath.row) {
                case LocationRowAddress:
                    return [TRNStopAddressCell cellHeight];
                    break;
                case LocationRowMap:
                    return self.mapImageView.frame.size.height;
                    break;
                default:
                    break;
            }
            break;
            
        default:
            break;
    }
    return 44.0f;
}

#pragma mark - Directoins

- (void)openDirectionsForLocation:(CLLocation *)location {
    [[Mixpanel sharedInstance] track:@"Opening Directions" properties:@{@"NaPTAN" : self.stop.naptanCode}];
    
    NSString *url = [NSString stringWithFormat: @"http://maps.apple.com/?saddr=%f,%f&daddr=%f,%f", location.coordinate.latitude, location.coordinate.longitude, [self.stop.latitude floatValue], [self.stop.longitude floatValue]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: url]];
}

- (void)handleDirectionsFailure {
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"No Location For Directions"
                          message:@"It is not possible to obtain your current location so directions to this stop cannot be found at this time."
                          delegate:nil
                          cancelButtonTitle:@"Close"
                          otherButtonTitles: nil];
    [alert show];
}

- (void)showDirectionsForStop:(TRNStop *)stop {
    INTULocationManager *locMgr = [INTULocationManager sharedInstance];
    [locMgr requestLocationWithDesiredAccuracy:INTULocationAccuracyNeighborhood
                                       timeout:10.0
                          delayUntilAuthorized:YES
                                         block:^(CLLocation *currentLocation, INTULocationAccuracy achievedAccuracy, INTULocationStatus status) {
                                             if (status == INTULocationStatusSuccess) {
                                                 [self openDirectionsForLocation:currentLocation];
                                             }
                                             else {
                                                 [self handleDirectionsFailure];
                                             }
                                         }];
}

#pragma mark - Reporting

- (void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        return;
    }
    
    UVConfig *config = [UVConfig trn_config];
    NSString *stopDetails = [NSString stringWithFormat:@"%@, %@", self.stop.naptanCode, self.stop.fullTitle];
    config.customFields = @{@"Stop Details" : stopDetails};
    
    [UserVoice initialize:config];
    [UserVoice presentUserVoiceContactUsFormForParentViewController:self];
}

- (void)showReport {
    NSString *title = @"If the information for this stop is wrong then report it and we will look into it. Thanks! \n(The stop details will automatically be submitted with your feedback.)";
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:title
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Report Error", nil];
    [actionSheet showInView:self.view];
}

- (UIView *)tableViewFooterView {
    UIButton *reportButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.tableView.frame), 40)];
    [reportButton setTitle:@"Report Error" forState:UIControlStateNormal];
    [reportButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [reportButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    reportButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    reportButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [reportButton addTarget:self action:@selector(showReport) forControlEvents:UIControlEventTouchUpInside];
    return reportButton;
}

#pragma mark - TRNStopMapViewControllerDelegate

- (void)stopMapView:(TRNStopMapViewController *)mapViewController showDirectionsToStop:(TRNStop *)stop {
    [self showDirectionsForStop:stop];
}

@end
