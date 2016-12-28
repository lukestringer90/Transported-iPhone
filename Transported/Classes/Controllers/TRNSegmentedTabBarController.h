//
//  TRNSegmentedTabBarController.h
//  Transport
//
//  Created by Luke Stringer on 12/04/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TRNSegmentedTabBarController;
@protocol TRNSegmentedTabBarControllerDelegate <NSObject>

- (NSString *)titleForSegmentedTabBarController:(TRNSegmentedTabBarController *)segmentedTabBarController;

@end

@interface TRNSegmentedTabBarController : UIViewController

@property (nonatomic, copy, readonly) NSArray *viewControllers;
@property (nonatomic, copy, readonly) NSArray *titles;
@property (nonatomic, strong, readonly) UISegmentedControl *segmentedControl;

/**
 *  Initialises the receiver with an array of the view controllers displayed by the segmented tab bar interface. These must be instance of UIViewController, and are assumed to have UIScrollViews as their views.
 *
 *  @param viewControllers An array of the view controllers displayed by the segmented tab bar interface.
 *  @param viewControllers Titles to use for the segments.
 *
 *  @return An initialised TRNSegmentedTabBarController with the specified view controllers.
 */
- (instancetype)initWithViewControllers:(NSArray *)viewControllers title:(NSArray *)titles;

@property (nonatomic, strong, readonly) UIToolbar *toolbar;

@end
