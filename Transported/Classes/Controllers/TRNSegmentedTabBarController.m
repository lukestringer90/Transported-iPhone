//
//  TRNSegmentedTabBarController.m
//  Transport
//
//  Created by Luke Stringer on 12/04/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import "TRNSegmentedTabBarController.h"

@interface TRNSegmentedTabBarController () <UINavigationControllerDelegate, UIToolbarDelegate>
@property (nonatomic, copy, readwrite) NSArray *viewControllers;
@property (nonatomic, copy, readwrite) NSArray *titles;
@property (nonatomic, strong, readwrite) UISegmentedControl *segmentedControl;
@property (nonatomic, strong, readwrite) UIToolbar *toolbar;
@property (nonatomic, strong) UIViewController *activeViewController;
@property (nonatomic, strong) NSArray *viewControllersWithAppliedScrollViewInsets;
@property (nonatomic, assign) BOOL shouldInsetActiveViewController;
@end

static CGFloat const ToolbarHeight = 38;

@implementation TRNSegmentedTabBarController

- (instancetype)initWithViewControllers:(NSArray *)viewControllers title:(NSArray *)titles {
    if (self = [super init]) {
        self.viewControllers = viewControllers;
        self.activeViewController = [viewControllers firstObject];
        self.viewControllersWithAppliedScrollViewInsets = [NSArray array];
        self.titles = titles;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSegmentedControl];
    [self setupToolbar];
    
    [self addActiveViewControllerAsChildViewController];
    
    self.shouldInsetActiveViewController = YES;
}


- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    CGFloat toolBarWidth = CGRectGetWidth(self.view.bounds);
    self.toolbar.frame = CGRectMake(0, 0, toolBarWidth, ToolbarHeight);
    
    self.activeViewController.view.frame = self.view.bounds;
    
    /**
     *  The tool bar is positioned above the active view controller so it is necessary to 
     *  inset the active view controllers scroll view so that content is not obscured when
     *  scrolled all the way to the bottom.
     *  This only needs to be done once to stop too many insets being added.
     */
    if (self.shouldInsetActiveViewController && ![self.viewControllersWithAppliedScrollViewInsets containsObject:self.activeViewController]) {
        [self applyScrollViewInset:CGRectGetMaxY(self.toolbar.frame)];
    }
}

- (void)applyScrollViewInset:(CGFloat)topInset {
    UIScrollView *scrollView = (UIScrollView *)self.activeViewController.view;
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(topInset, 0, 0, 0);
    scrollView.contentInset = edgeInsets;
    scrollView.scrollIndicatorInsets = edgeInsets;
    self.viewControllersWithAppliedScrollViewInsets = [self.viewControllersWithAppliedScrollViewInsets arrayByAddingObject:self.activeViewController];
}


- (void)setupSegmentedControl {
    self.segmentedControl = [[UISegmentedControl alloc] initWithItems:self.titles];
    [self.segmentedControl addTarget:self action:@selector(segmentedControlTapped) forControlEvents:UIControlEventValueChanged];
    self.segmentedControl.selectedSegmentIndex = 0;

    [self.segmentedControl sizeToFit];
}

- (void)setupToolbar {
    UIView *segmentedContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.segmentedControl.frame), ToolbarHeight)];
    [segmentedContainerView addSubview:self.segmentedControl];
    
    UIBarButtonItem *segmentedControlButton = [[UIBarButtonItem alloc] initWithCustomView:segmentedContainerView];
    segmentedControlButton.width = CGRectGetWidth(segmentedContainerView.frame);
    
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    self.toolbar = [[UIToolbar alloc] initWithFrame:CGRectZero];
    self.toolbar.delegate = self;
    self.toolbar.items = @[flexibleSpace, segmentedControlButton, flexibleSpace];
}

- (void)segmentedControlTapped {
    [self.activeViewController removeFromParentViewController];
    [self.activeViewController.view removeFromSuperview];
    
    self.activeViewController = self.viewControllers[self.segmentedControl.selectedSegmentIndex];
    [self addActiveViewControllerAsChildViewController];
}

- (void)addActiveViewControllerAsChildViewController {
    /**
     *  Remove and read the toolbar each time so that the active
     *  view controller underlaps it.
     */
    [self.toolbar removeFromSuperview];
    [self addChildViewController:self.activeViewController];
    [self.view addSubview:self.activeViewController.view];
    [self.activeViewController didMoveToParentViewController:self];
    [self.view addSubview:self.toolbar];
}

#pragma mark - UIToolbarDelegate

- (UIBarPosition)positionForBar:(id <UIBarPositioning>)bar {
    return UIBarPositionTopAttached;
}

@end
