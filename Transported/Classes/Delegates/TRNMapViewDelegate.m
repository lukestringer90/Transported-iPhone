//
//  TRNMapViewDelegate.m
//  Transported
//
//  Created by Luke Stringer on 05/07/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import "TRNMapViewDelegate.h"
#import "TRNStop.h"
#import "TRNStopDistance+Logic.h"
#import "NSPredicate+TRNStop.h"

@interface TRNMapViewDelegate ()
@property (nonatomic, copy, readwrite) StopSelectedBlock stopSelectedBlock;
@end

@implementation TRNMapViewDelegate

- (instancetype)initWithStopSelectedBloc:(StopSelectedBlock)stopSelectedBlock {
	if (self = [super init]) {
		_stopSelectedBlock = stopSelectedBlock;
	}
	return self;
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id)annotation {
    TRNStop *stop = [self stopFromAnnotation:annotation];
    
    if (stop != nil) {
        
        NSString *PinID = NSStringFromClass([TRNStop class]);
        
        MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:PinID];
        if (!annotationView) {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:PinID];
        }
        
        UIView *accessoryView;
        
        if ([[NSPredicate trn_busesPredicate] evaluateWithObject:stop]) {
            accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bus-filled"]];
            
        }
        else if ([[NSPredicate trn_tramsPredicate] evaluateWithObject:stop]) {
            accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tram-filled"]];
        }
        
        if (self.stopSelectedBlock) {
            annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        }
        
        annotationView.leftCalloutAccessoryView = accessoryView;
        annotationView.canShowCallout = YES;
        annotationView.tintColor = [UIColor trn_barTintColor];
        
        return annotationView;
    }
    
    return nil;
}

- (TRNStop *)stopFromAnnotation:(id)annotation {
    if ([annotation isKindOfClass:[TRNStopDistance class]]) {
        TRNStopDistance *stopDistance = (TRNStopDistance *)annotation;
        return [stopDistance fetchStop];
    }
    else if ([annotation isKindOfClass:[TRNStop class]]) {
        return (TRNStop *)annotation;
    }
    return nil;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
	if (self.stopSelectedBlock) {
		TRNStop *stop = [self stopFromAnnotation:view.annotation];
		self.stopSelectedBlock(stop);
	}
}

@end
