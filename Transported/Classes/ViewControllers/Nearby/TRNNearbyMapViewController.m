//
//  TRNMapViewController.m
//  Transported
//
//  Created by Luke Stringer on 26/05/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import "TRNNearbyMapViewController.h"
#import "TRNStopDistance.h"
#import "TRNStopDistance+MKAnnotation.h"
#import "NSPredicate+TRNStop.h"
#import "TRNStop.h"
#import "TRNStopDistance+Logic.h"
#import "UIViewController+TRNAdditions.h"
#import "TRNMapViewDelegate.h"

@interface TRNNearbyMapViewController ()
@property (nonatomic, strong, readwrite) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong, readwrite) MKMapView *mapView;
@property (nonatomic, strong, readwrite) NSArray *stopDistances;
@property (nonatomic, strong, readwrite) TRNMapViewDelegate *mapViewDelegate;
@end

@implementation TRNNearbyMapViewController

- (instancetype)initWithContext:(NSManagedObjectContext *)managedObjectContext {
    if (self = [super init]) {
        _managedObjectContext = managedObjectContext;
        
        _mapView = [[MKMapView alloc] initWithFrame:CGRectZero];
        _mapView.showsUserLocation = YES;
        _mapView.zoomEnabled = YES;
        _mapView.scrollEnabled = YES;
        _mapView.rotateEnabled = NO;
        _mapView.tintColor = [UIColor trn_barTintColor];
        
        _mapViewDelegate = [[TRNMapViewDelegate alloc] initWithStopSelectedBloc:^(TRNStop *stop) {
            [self presentDataViewControllerForStop:stop];
        }];
        _mapView.delegate = _mapViewDelegate;
        
    }
    return self;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    self.mapView.frame = self.view.frame;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.mapView];
}

#pragma mark - Reloading data

- (void)reloadMapAtCentre:(CLLocationCoordinate2D)centreCoord reloadAnnotations:(BOOL)reloadAnnotations {
    
    if (reloadAnnotations) {
        self.stopDistances = [self.managedObjectContext executeFetchRequest:[TRNStopDistance nearbyFetchRequest] error:NULL];
        
        if (self.stopDistances.count > 0) {
            [self.mapView removeAnnotations:self.mapView.annotations];
            [self.mapView addAnnotations:self.stopDistances];
        }
    }
    
    // TODO: Maybe us showAnnotations: instead?
    
    MKCoordinateRegion region;
    if (self.stopDistances.count > 0) {
        MKCoordinateSpan span = [self spanForAnnotations:self.stopDistances];
        region = MKCoordinateRegionMake(centreCoord, span);
        
    }
    else {
        region = MKCoordinateRegionMakeWithDistance(centreCoord, 500, 500);
    }
    
    [self.mapView setRegion:region animated:YES];
}


#pragma mark - MKCoordinateRegion

- (MKCoordinateSpan)spanForAnnotations:(NSArray *)annotations {
    
    CLLocationDegrees minLat = 90.0;
    CLLocationDegrees maxLat = -90.0;
    CLLocationDegrees minLon = 180.0;
    CLLocationDegrees maxLon = -180.0;
    
    for (id <MKAnnotation> annotation in annotations) {
        if (annotation.coordinate.latitude < minLat) {
            minLat = annotation.coordinate.latitude;
        }
        if (annotation.coordinate.longitude < minLon) {
            minLon = annotation.coordinate.longitude;
        }
        if (annotation.coordinate.latitude > maxLat) {
            maxLat = annotation.coordinate.latitude;
        }
        if (annotation.coordinate.longitude > maxLon) {
            maxLon = annotation.coordinate.longitude;
        }
    }
    
    double padding = 0.003;
    CLLocationDegrees latSpan = maxLat - minLat + padding;
    CLLocationDegrees longSpan = maxLon - minLon + padding;
    return  MKCoordinateSpanMake(latSpan, longSpan);
    
}


@end
