//
//  TRNNearbyParralaxViewController.h
//  Transported
//
//  Created by Luke Stringer on 25/05/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import "QMBParallaxScrollViewController.h"

@class SQKContextManager;
@interface TRNNearbyParralaxViewController : QMBParallaxScrollViewController

@property (nonatomic, strong, readonly) SQKContextManager *contextManager;

- (instancetype)initWithContextManager:(SQKContextManager *)contextManager;
- (void)reloadData;

@end
