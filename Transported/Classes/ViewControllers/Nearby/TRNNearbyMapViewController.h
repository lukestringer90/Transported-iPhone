//
//  TRNMapViewController.h
//  Transported
//
//  Created by Luke Stringer on 26/05/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@class MKMapView, CLLocation;
@interface TRNNearbyMapViewController : UIViewController

@property (nonatomic, strong, readonly) MKMapView *mapView;

@property (nonatomic, strong, readonly) NSManagedObjectContext *managedObjectContext;

- (instancetype)initWithContext:(NSManagedObjectContext *)managedObjectContext;

- (void)reloadMapAtCentre:(CLLocationCoordinate2D)centreCoord reloadAnnotations:(BOOL)reloadAnnotations;

@property (nonatomic, assign) BOOL annotationViewInteractionEnabled;

@end
