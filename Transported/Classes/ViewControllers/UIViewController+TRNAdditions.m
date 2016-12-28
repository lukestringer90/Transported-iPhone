//
//  UIViewController+TRNPresentStopDataViewController.m
//  Transported
//
//  Created by Luke Stringer on 27/05/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import "UIViewController+TRNAdditions.h"
#import "TRNStopDataViewController.h"
#import "TRNStop+Logic.h"
#import "TRNUserStop.h"

@implementation UIViewController (TRNAdditions)

- (void)presentDataViewControllerForStop:(TRNStop *)stop {
    NSString *cleanTitle = [stop cleanTitleByRemovingOccurencesOfString:[self stringsToCleanFromTitle]];
    
    TRNStopDataViewController *stopDataViewController = [[TRNStopDataViewController alloc] initWithStop:stop title:cleanTitle];
    
    [self.navigationController pushViewController:stopDataViewController animated:YES];
    
    [stop insertOrFetchUserStop].lastViewDate = [NSDate date];
    NSError *error = nil;
    [stop.managedObjectContext save:&error];
    NSAssert(error == nil, @"Error when saving new TRNUserStop and setting lastViewDate");
}

- (NSArray *)stringsToCleanFromTitle {
    /**
     *  Always clean Supertram.
     */
    return @[@"(Supertram)"];
}

- (BOOL)viewIsVisible {
    return self.view.superview != nil;
}

@end
