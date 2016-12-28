//
//  TRNMapViewDelegate.h
//  Transported
//
//  Created by Luke Stringer on 05/07/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@class TRNStop;

typedef void (^StopSelectedBlock)(TRNStop *stop);

@interface TRNMapViewDelegate : NSObject <MKMapViewDelegate>

@property (nonatomic, copy, readonly) StopSelectedBlock stopSelectedBlock;

- (instancetype)initWithStopSelectedBloc:(StopSelectedBlock)stopSelectedBlock;

@end
