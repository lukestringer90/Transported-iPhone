//
//  TRNMapViewController.m
//  Transported
//
//  Created by Luke Stringer on 05/07/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import "TRNStopMapViewController.h"
#import <MapKit/MapKit.h>
#import "TRNStop+MKAnnotation.h"
#import "NSPredicate+TRNStop.h"
#import "TRNMapViewDelegate.h"

@interface TRNStopMapViewController ()
@property (nonatomic, strong, readwrite) MKMapView *mapView;
@property (nonatomic, strong, readwrite) TRNStop *stop;
@property (nonatomic, assign) BOOL annotationAdded;
@property (nonatomic, strong, readwrite) TRNMapViewDelegate *mapViewDelegate;

@end

@implementation TRNStopMapViewController

- (instancetype)initWithStop:(TRNStop *)stop {
    if (self = [super init]) {
        _stop = stop;
        _mapView = [[MKMapView alloc] init];
        _mapView.zoomEnabled = YES;
        _mapView.scrollEnabled = YES;
        _mapView.rotateEnabled = YES;
        _mapView.tintColor = [UIColor trn_barTintColor];
        
        _mapViewDelegate = [[TRNMapViewDelegate alloc] initWithStopSelectedBloc:nil];
        _mapView.delegate = _mapViewDelegate;
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.mapView];
    
    self.title = [self.stop title];
    
    [self.mapView addAnnotation:self.stop];
    self.mapView.centerCoordinate = [self.stop coordinate];
    [self.mapView showAnnotations:self.mapView.annotations animated:YES];
    
//    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance([self.stop coordinate], 200, 200);
//    [self.mapView setRegion:region animated:YES];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Directions"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(showDirections)];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    self.mapView.frame = self.view.bounds;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.mapView selectAnnotation:self.stop animated:YES];
}

- (void)showDirections {
    if ([self.delegate respondsToSelector:@selector(stopMapView:showDirectionsToStop:)]) {
        [self.delegate stopMapView:self showDirectionsToStop:self.stop];
    }
}

@end
