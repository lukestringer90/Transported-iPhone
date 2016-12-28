//
//  TRNStopAddressCell.m
//  Transport
//
//  Created by Luke Stringer on 28/04/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import "TRNStopAddressCell.h"
#import "TRNStop.h"
#import <Masonry/Masonry.h>

@interface TRNStopAddressCell ()
@property (nonatomic, strong, readwrite) UILabel *titleLabel;
@property (nonatomic, strong, readwrite) UILabel *streetLabel;
@property (nonatomic, strong, readwrite) UILabel *localityLabel;
@property (nonatomic, strong, readwrite) UIImageView *stopTypeImageView;
@property (nonatomic, strong, readwrite) UILabel *naptanCodeLabel;
@property (nonatomic, strong, readwrite) UILabel *bearingIndicatorLabel;
@end

@implementation TRNStopAddressCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		self.titleLabel.adjustsFontSizeToFitWidth = YES;
		self.titleLabel.font = [UIFont systemFontOfSize:20.0];
		[self.contentView addSubview:self.titleLabel];
        
        self.streetLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		self.streetLabel.adjustsFontSizeToFitWidth = YES;
		self.streetLabel.font = [UIFont systemFontOfSize:14.0];
		[self.contentView addSubview:self.streetLabel];
        
        self.localityLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		self.localityLabel.adjustsFontSizeToFitWidth = YES;
		self.localityLabel.font = [UIFont systemFontOfSize:14.0];
		[self.contentView addSubview:self.localityLabel];
        
        self.naptanCodeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		self.naptanCodeLabel.adjustsFontSizeToFitWidth = YES;
		self.naptanCodeLabel.font = [UIFont systemFontOfSize:14.0];
		[self.contentView addSubview:self.naptanCodeLabel];
        
        self.bearingIndicatorLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.bearingIndicatorLabel.textAlignment = NSTextAlignmentRight;
		self.bearingIndicatorLabel.adjustsFontSizeToFitWidth = YES;
		self.bearingIndicatorLabel.font = [UIFont systemFontOfSize:10.0];
		[self.contentView addSubview:self.bearingIndicatorLabel];
        
        self.stopTypeImageView = [[UIImageView alloc] initWithImage:nil];
        [self.contentView addSubview:self.stopTypeImageView];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;

    }
    return self;
}

- (void)setStopType:(TRNStopType)stopType {
    _stopType = stopType;
    switch (_stopType) {
        case TRNStopTypeBus:
            self.stopTypeImageView.image = [UIImage imageNamed:@"bus-filled-cell"];
            break;
        case TRNStopTypeTram:
            self.stopTypeImageView.image = [UIImage imageNamed:@"tram-filled-cell"];
            break;
            
        default:
            break;
    }
}

- (void)layoutSubviews {
	[super layoutSubviews];
    
    CGFloat bearinIndicatorLabelHeight = CGRectGetHeight(self.bearingIndicatorLabel.frame);
    
    [self.stopTypeImageView updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.centerY).with.offset(-bearinIndicatorLabelHeight);
		make.right.lessThanOrEqualTo(self.contentView.right);
		make.width.equalTo(@40.0f);
		make.height.equalTo(@40.0f);
	}];
    
    [self.bearingIndicatorLabel sizeToFit];
    [self.bearingIndicatorLabel updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.stopTypeImageView.bottom);
        make.right.equalTo (self.contentView.right).offset(-2);
	}];
	
    CGFloat xPadding = 15.0f;
    
    [self.titleLabel updateConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.contentView.top).with.offset(5);
		make.left.equalTo(self.contentView.left).with.offset(xPadding);
		make.right.lessThanOrEqualTo(self.bearingIndicatorLabel.left).with.offset(-xPadding);
		make.height.equalTo(@25.0f);
	}];
    
    [self.streetLabel updateConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.titleLabel.bottom);
		make.left.equalTo(self.contentView.left).with.offset(xPadding);
		make.right.lessThanOrEqualTo(self.bearingIndicatorLabel.left).with.offset(-xPadding);
        make.height.equalTo(@18.0f);
	}];
    
    [self.localityLabel updateConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.streetLabel.bottom);
		make.left.equalTo(self.contentView.left).with.offset(xPadding);
		make.right.lessThanOrEqualTo(self.bearingIndicatorLabel.left).with.offset(-xPadding);
		make.height.equalTo(@18.0f);
	}];
    
    [self.naptanCodeLabel updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.localityLabel.bottom).with.offset(10);
		make.left.equalTo(self.contentView.left).with.offset(xPadding);
		make.right.lessThanOrEqualTo(self.bearingIndicatorLabel.left).with.offset(-xPadding);
		make.height.equalTo(@18.0f);
	}];
    
}

+ (CGFloat)cellHeight {
    return 100.0f;
}

@end
