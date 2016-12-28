//
//  TRNLiveDataTableHeaderView.m
//  Transport
//
//  Created by Luke Stringer on 04/05/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import "TRNLiveDataTableHeaderView.h"
#import <Masonry/Masonry.h>

@interface TRNLiveDataTableHeaderView ()
@property (nonatomic, strong) UIActivityIndicatorView *activityIndiactor;
@property (nonatomic, strong) UILabel *autoUpdatingLabel;
@property (nonatomic, strong, readwrite) UILabel *titleLabel;
@property (nonatomic, strong) UIView *bottomLineView;
@property (nonatomic, strong) MASConstraint *titleLabelBottomConstaint;
@property (nonatomic, strong) MASConstraint *titleLabelCenterYConstaint;
@end

@implementation TRNLiveDataTableHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.activityIndiactor = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self.activityIndiactor startAnimating];
        [self addSubview:self.activityIndiactor];
        
        self.bottomLineView = [[UIView alloc] initWithFrame:CGRectZero];
        self.bottomLineView.backgroundColor = [UIColor colorWithRed:0.78f green:0.78f blue:0.8f alpha:1];
        [self addSubview:self.bottomLineView];
        
        self.autoUpdatingLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.autoUpdatingLabel.text = @"Streaming...";
        self.autoUpdatingLabel.textColor = [UIColor darkGrayColor];
        self.autoUpdatingLabel.font = [UIFont boldSystemFontOfSize:14.0f];
        [self.autoUpdatingLabel sizeToFit];
        [self addSubview:self.autoUpdatingLabel];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.titleLabel.textColor = [UIColor darkGrayColor];
        self.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [self.titleLabel sizeToFit];
        [self addSubview:self.titleLabel];
        
        self.showInitialDownloadLabel = YES;
        
    }
    return self;
}

- (void)setShowInitialDownloadLabel:(BOOL)showInitialDownloadLabel {
    _showInitialDownloadLabel = showInitialDownloadLabel;
    if (_showInitialDownloadLabel) {
        self.titleLabel.text = @"Downloading Departures...";
    }
    self.autoUpdatingLabel.hidden = _showInitialDownloadLabel;
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    
    [self.activityIndiactor updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@30);
        make.height.equalTo(@30);
        make.left.equalTo(self.left).with.offset(10);
        make.centerY.equalTo(self.centerY);
    }];
    
    [self.autoUpdatingLabel updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.top).with.offset(8);
        make.left.equalTo(self.activityIndiactor.right).with.offset(5);
    }];
    
    [self.bottomLineView updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@0.5);
        make.left.equalTo(self.left).with.offset(15);
        make.right.equalTo(self.right);
        make.bottom.equalTo(self.bottom).with.offset(-0.5);
    }];
    
    if (self.showInitialDownloadLabel) {
        [self.titleLabelBottomConstaint uninstall];
        [self.titleLabel updateConstraints:^(MASConstraintMaker *make) {
            self.titleLabelCenterYConstaint = make.centerY.equalTo(self.centerY);
            make.left.equalTo(self.autoUpdatingLabel.left);
        }];
    }
    else {
        [self.titleLabelCenterYConstaint uninstall];
        [self.titleLabel updateConstraints:^(MASConstraintMaker *make) {
            self.titleLabelBottomConstaint = make.bottom.equalTo(self.bottom).with.offset(-8);
            make.left.equalTo(self.autoUpdatingLabel.left);
        }];
    }
    
    
    [super layoutSubviews];
}

@end
