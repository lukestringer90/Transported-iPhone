//
//  TRNHelpTableViewController.m
//  Transported
//
//  Created by Luke Stringer on 09/06/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import "TRNAboutViewController.h"
#import "TRNCell.h"
#import "TRNAboutHeaderView.h"
#import "TRNAboutFooterView.h"
#import <uservoice-iphone-sdk/UserVoice.h>
#import "UVConfig+TRNConfig.h"

static NSString * const AppStoreURL = @"https://itunes.apple.com/us/app/transported-live-bus-tram/id867985577?ls=1&mt=8";
static NSString * const TwitterURL = @"https://twitter.com/transported_app";
static NSString * const FacebookURL = @"https://www.facebook.com/transported.ios";
static NSString * const GooglePlusURL = @"https://plus.google.com/114747949266227169125";
static NSString * const HomePageURL = @"http://transportedapp.com";

typedef NS_ENUM(NSUInteger, AboutSection) {
    AboutSectionReview,
    AboutSectionHelpLinks,
    AboutSectionHelp,
    AboutSectionCount
};

typedef NS_ENUM(NSUInteger, AboutRowLinks) {
    AboutRowLinksTwitter,
    AboutRowLinksFacebook,
    AboutRowLinksGooglePlus,
    AboutRowLinksHomePage,
    AboutRowLinksCount
};

@interface TRNAboutViewController ()

@end

@implementation TRNAboutViewController

- (id)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"About";
    
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStylePlain target:self action:@selector(close)];
    
    [self.tableView registerClass:[TRNCell class] forCellReuseIdentifier:[TRNCell cellID]];
    
    self.tableView.tableHeaderView = [[TRNAboutHeaderView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.tableView.frame), 150)];
    
    TRNAboutFooterView *footerView = [[TRNAboutFooterView alloc] initWithFrame:CGRectZero];
    footerView.frame = CGRectMake(0, 0, CGRectGetWidth(self.tableView.frame), [footerView heightForWidth:CGRectGetWidth(self.tableView.frame)]);
    self.tableView.tableFooterView = footerView;
}

- (void)close {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return AboutSectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == AboutSectionHelpLinks) {
        return AboutRowLinksCount;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[TRNCell cellID]];
    
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    
    switch (indexPath.section) {
        case AboutSectionReview:
            cell.textLabel.text = @"Review In App Store";
            break;
        case AboutSectionHelp:
            cell.textLabel.text = @"Feedback & Support";
            break;
        case AboutSectionHelpLinks:
            switch (indexPath.row) {
                case AboutRowLinksTwitter:
                    cell.textLabel.text = @"Twitter";
                    break;
                case AboutRowLinksFacebook:
                    cell.textLabel.text = @"Facebook";
                    break;
                case AboutRowLinksGooglePlus:
                    cell.textLabel.text = @"Google+";
                    break;
                case AboutRowLinksHomePage:
                    cell.textLabel.text = @"Transported Website";
                    break;
                    
                default:
                    break;
            }
            break;

            
        default:
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case AboutSectionReview:
            [self openURLWithString:AppStoreURL];
            break;
        case AboutSectionHelp: {
            UVConfig *config = [UVConfig trn_config];
            [UserVoice initialize:config];

            [UserVoice presentUserVoiceInterfaceForParentViewController:self];
        }
            break;
        case AboutSectionHelpLinks:
            switch (indexPath.row) {
                case AboutRowLinksTwitter:
                    [self openURLWithString:TwitterURL];
                    break;
                case AboutRowLinksFacebook:
                    [self openURLWithString:FacebookURL];
                    break;
                case AboutRowLinksGooglePlus:
                    [self openURLWithString:GooglePlusURL];
                    break;
                case AboutRowLinksHomePage:
                    [self openURLWithString:HomePageURL];
                    break;
                    
                default:
                    break;
            }
            break;
            
        default:
            break;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (void)openURLWithString:(NSString *)urlString {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
}

@end
