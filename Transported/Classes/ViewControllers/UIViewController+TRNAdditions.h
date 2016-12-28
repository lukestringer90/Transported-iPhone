//
//  UIViewController+TRNPresentStopDataViewController.h
//  Transported
//
//  Created by Luke Stringer on 27/05/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TRNStop;
@interface UIViewController (TRNAdditions)

- (void)presentDataViewControllerForStop:(TRNStop *)stop;
- (BOOL)viewIsVisible;

@end
