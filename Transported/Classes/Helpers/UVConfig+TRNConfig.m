//
//  UVConfig+TRNConfig.m
//  Transported
//
//  Created by Luke Stringer on 11/06/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import "UVConfig+TRNConfig.h"

@implementation UVConfig (TRNConfig)

+ (UVConfig *)trn_config {
    UVConfig *config = [UVConfig configWithSite:@"transportedapp.uservoice.com"];
    config.forumId = 255120;
    return config;
}

@end
