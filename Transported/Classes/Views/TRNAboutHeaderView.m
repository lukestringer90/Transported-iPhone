//
//  TRNAboutHeaderView.m
//  Transported
//
//  Created by Luke Stringer on 11/06/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import "TRNAboutHeaderView.h"
#import <Masonry/Masonry.h>

@interface TRNAboutHeaderView ()
@property (nonatomic, strong) UIImageView *logoImageView;
@property (nonatomic, strong) UILabel *versionLabel;
@property (nonatomic, strong) UILabel *developerLabel;
@end

@implementation TRNAboutHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bus-only-icon"]];
        [self addSubview:_logoImageView];
        
        _versionLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _versionLabel.textAlignment = NSTextAlignmentCenter;
        _versionLabel.font = [UIFont systemFontOfSize:14.0];
        _versionLabel.text = [NSString stringWithFormat:@"Transported %@", [self appVersion]];
        [self addSubview:_versionLabel];
        
        _developerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _developerLabel.textAlignment = NSTextAlignmentCenter;
        _developerLabel.font = [UIFont systemFontOfSize:12.0];
        _developerLabel.textColor = [UIColor darkGrayColor];
        _developerLabel.text = @"© 2014 Luke Stringer";
        [self addSubview:_developerLabel];

    }
    return self;
}

- (NSString *)appVersion {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

- (void)layoutSubviews {
    
    [self.versionLabel sizeToFit];
    [self.developerLabel sizeToFit];
    
    [self.logoImageView updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(25.0);
        make.centerX.equalTo(self);
    }];
    
    [self.versionLabel updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.logoImageView.bottom).with.offset(5);
        make.centerX.equalTo(self);
    }];
    
    [self.developerLabel updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.versionLabel.bottom).with.offset(5);
        make.centerX.equalTo(self);
    }];
    
    [super layoutSubviews];
}

@end
