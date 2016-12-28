//
//  TRNNaPTANInfoViewController.m
//  Transport
//
//  Created by Luke Stringer on 12/04/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import "TRNNaPTANInfoViewController.h"

@interface TRNNaPTANInfoViewController ()
@property (nonatomic, strong) UIImageView *busStopSignImageView;
@end

@implementation TRNNaPTANInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.busStopSignImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bus-stop-sign"]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.busStopSignImageView];
	self.title = @"Finding A NaPTAN Code";
	
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
																						   target:self
																						   action:@selector(dismissSelf)];
}

- (void)dismissSelf {
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    CGFloat oldHeight = CGRectGetHeight(self.busStopSignImageView.frame);
    CGFloat newHeight = 400;
    CGFloat ratio = newHeight / oldHeight;
    CGFloat oldWidth = CGRectGetWidth(self.busStopSignImageView.frame);
    CGFloat newWidth = oldWidth * ratio;
    
    CGFloat xPosition = (CGRectGetWidth(self.view.frame) - newWidth) / 2;
    CGFloat yPosition = (CGRectGetHeight(self.view.frame) + CGRectGetHeight(self.navigationController.navigationBar.frame) - newHeight) / 2;
    
    self.busStopSignImageView.frame = CGRectMake(xPosition, yPosition, newWidth, newHeight);
}

@end
