//
//  TRNMapViewController.h
//  Transported
//
//  Created by Luke Stringer on 05/07/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TRNStopMapViewController, TRNStop;
@protocol TRNStopMapViewControllerDelegate <NSObject>

- (void)stopMapView:(TRNStopMapViewController *)mapViewController showDirectionsToStop:(TRNStop *)stop;

@end

@class MKMapView;
@interface TRNStopMapViewController : UIViewController

@property (nonatomic, readonly) MKMapView *mapView;
@property (nonatomic, readonly) TRNStop *stop;
@property (nonatomic, weak, readwrite) id<TRNStopMapViewControllerDelegate> delegate;

- (instancetype)initWithStop:(TRNStop *)stop;

@end
