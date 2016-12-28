//
//  TRNRecentViewController.m
//  Transport
//
//  Created by Luke Stringer on 17/05/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import "TRNRecentViewController.h"
#import "NSPredicate+TRNStop.h"

@interface TRNRecentViewController ()

@end

@implementation TRNRecentViewController

- (instancetype)initWithContext:(NSManagedObjectContext *)context {
    if (self = [super initWithContext:context]) {
        self.title = @"Recently Viewed";
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Recent" style:UIBarButtonItemStylePlain target:nil action:nil];
    }
    return self;
}

- (NSPredicate *)userStopsPredicate {
    return [NSPredicate trn_recentPredicate];
}

- (NSArray *)sortDescriptors {
    return @[[NSSortDescriptor sortDescriptorWithKey:@"lastViewDate" ascending:NO]];
}

@end
