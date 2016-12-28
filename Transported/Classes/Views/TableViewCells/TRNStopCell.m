//
//  TRNStopCell.m
//  Transport
//
//  Created by Luke Stringer on 06/04/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import "TRNStopCell.h"
#import "TRNStop+Logic.h"
#import "TRNStopDistance+Logic.h"
#import <Masonry/Masonry.h>

@interface TRNStopCell ()
@property (nonatomic, strong) UILabel *stopTitleLabel;
@property (nonatomic, strong) UILabel *stopDetailLabel;
@property (nonatomic, strong) UILabel *supplemtaryLabel;
@property (nonatomic, strong) MASConstraint *topConstraint;
@property (nonatomic, strong) MASConstraint *centreConstraint;
@end

@implementation TRNStopCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
        _stopTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _stopTitleLabel.font = [UIFont systemFontOfSize:18.0f];
        _stopTitleLabel.textColor = self.detailTextLabel.textColor;
        [self.contentView addSubview:_stopTitleLabel];
        
        _stopDetailLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _stopDetailLabel.font = [UIFont systemFontOfSize:14.0f];
        _stopDetailLabel.textColor = self.detailTextLabel.textColor;
        [self.contentView addSubview:_stopDetailLabel];
        
        _supplemtaryLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _supplemtaryLabel.font = [UIFont systemFontOfSize:12.0f];
        _supplemtaryLabel.textColor = [UIColor whiteColor];
        _supplemtaryLabel.backgroundColor = [UIColor trn_barTintColor];
        _supplemtaryLabel.textAlignment = NSTextAlignmentCenter;
        _supplemtaryLabel.layer.cornerRadius = 3.0f;
        _supplemtaryLabel.layer.masksToBounds = YES;
        [self.contentView addSubview:_supplemtaryLabel];
        
        self.textLabel.adjustsFontSizeToFitWidth = NO;
        self.detailTextLabel.adjustsFontSizeToFitWidth = NO;
    }
    return self;
}

- (void)prepareForReuse {
	[super prepareForReuse];
	
	self.supplemtaryLabel.text = nil;
    self.stopTitleLabel.text = nil;
    self.stopDetailLabel.text = nil;
    self.textLabel.text = nil;
    self.detailTextLabel.text = nil;
}

- (void)layoutSubviews {
    
    [self.supplemtaryLabel sizeToFit];
    [self.stopTitleLabel sizeToFit];
    [self.stopDetailLabel sizeToFit];
    
    if (self.stopDetailLabel.text.length> 0) {
        [self.centreConstraint uninstall];
        [self.stopTitleLabel updateConstraints:^(MASConstraintMaker *make) {
            self.topConstraint = make.top.equalTo(self.contentView).with.offset(5);
            make.left.equalTo(self.contentView).with.offset(15);
            make.right.lessThanOrEqualTo(self.supplemtaryLabel.left);
        }];
    }
    
    else {
        [self.topConstraint uninstall];
        [self.stopTitleLabel updateConstraints:^(MASConstraintMaker *make) {
            self.centreConstraint = make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.contentView).with.offset(15);
            make.right.lessThanOrEqualTo(self.supplemtaryLabel.left);
        }];
    }
    
    
    
    [self.stopDetailLabel updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.bottom).with.offset(-5);
        make.left.equalTo(self.contentView).with.offset(15);
        make.right.lessThanOrEqualTo(self.supplemtaryLabel.left);
    }];
    
    
    CGFloat supplemtaryLabelHeight = CGRectGetHeight(self.supplemtaryLabel.frame);
    CGFloat supplemtaryLabelWidth = CGRectGetWidth(self.supplemtaryLabel.frame);
    
    if (supplemtaryLabelHeight > 0) {
        supplemtaryLabelHeight += 4;
    }
    
    if (supplemtaryLabelWidth > 0) {
        supplemtaryLabelWidth += 8;
    }
    
    [self.supplemtaryLabel updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(supplemtaryLabelHeight));
        make.width.equalTo(@(supplemtaryLabelWidth));
        make.right.equalTo(self.contentView).with.offset(-13);
        make.centerY.equalTo(self.contentView.centerY);
    }];
    
    
    [super layoutSubviews];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    self.supplemtaryLabel.textColor = [UIColor whiteColor];
    self.supplemtaryLabel.backgroundColor = [UIColor trn_barTintColor];
}

#pragma mark - Public

- (void)setupForStop:(TRNStop *)stop title:(NSString *)title supplemtaryText:(NSString *)supplemtaryText {
    [self setupForStop:stop title:title];
    self.supplemtaryLabel.text = supplemtaryText;
    
}

- (void)setupForStop:(TRNStop *)stop title:(NSString *)title {
    self.stopTitleLabel.text = title;
    
    NSString *detail = nil;
    if ([stop type] == TRNStopTypeTram) {
        detail = stop.indicator;
    }
    else {
        detail = [NSString stringWithFormat:@"%@ → %@", stop.street, stop.bearing];
    }
    
    self.stopDetailLabel.text = detail;
}

@end
