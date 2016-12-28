//
//  TRNStopMapSnapshotImageGenerator.m
//  Transport
//
//  Created by Luke Stringer on 29/04/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import "TRNStopMapSnapshotImageGenerator.h"
#import "TRNStop.h"
#import <MapKit/MapKit.h>

@implementation TRNStopMapSnapshotImageGenerator

+ (void)generateMapSnapshotImageForStop:(TRNStop *)stop size:(CGSize)size completion:(void (^)(UIImage *mapSnapshotImage))completion {
    if (completion == nil || stop == nil) {
        return;
    }
    
    MKCoordinateSpan span;
    span.latitudeDelta = 0.003;
    span.longitudeDelta = 0.003;

    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([stop.latitude floatValue], [stop.longitude floatValue]);

    MKCoordinateRegion region;
    region.span = span;
    region.center = coordinate;
    
    MKMapSnapshotOptions *options = [[MKMapSnapshotOptions alloc] init];
    options.region = region;
    options.scale = [UIScreen mainScreen].scale;
    options.size = size;
    
    MKMapSnapshotter *snapShotter = [[MKMapSnapshotter alloc] initWithOptions:options];
    [snapShotter startWithCompletionHandler:^(MKMapSnapshot *snapshot, NSError *error) {
        
        UIImage *drawnImage = [self drawPinAnnotiationAtCoordinate:coordinate ontoSnapShot:snapshot];
        completion(drawnImage);
        
    }];
}

+ (UIImage *)drawPinAnnotiationAtCoordinate:(CLLocationCoordinate2D)coordinate ontoSnapShot:(MKMapSnapshot *)snapshot {
    MKPinAnnotationView *pin = [[MKPinAnnotationView alloc]initWithAnnotation:nil reuseIdentifier:@""];
    UIImage *firstPointPinImage = pin.image;
    
    CGPoint firstPoint = [snapshot pointForCoordinate:coordinate];
    
    // Move the pin so that the "base" of the pin points to the right spot
    CGPoint pinCenterOffset = pin.centerOffset;
    firstPoint.x -= pin.bounds.size.width / 2.0;
    firstPoint.y -= pin.bounds.size.height / 2.0;
    firstPoint.x += pinCenterOffset.x;
    firstPoint.y += pinCenterOffset.y;
    
    UIGraphicsBeginImageContextWithOptions(snapshot.image.size, YES, snapshot.image.scale);
    
    // Draw the pins on the image
    [snapshot.image drawAtPoint:CGPointMake(0, 0)];
    [firstPointPinImage drawAtPoint:firstPoint];
    
    // Get the final image with the pins on top
    UIImage *drawnImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return drawnImage;

}

@end
