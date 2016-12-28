//
//  TRNDepartureCell.m
//  Transport
//
//  Created by Luke Stringer on 30/03/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import "TRNDepartureCell.h"
#import <Masonry/Masonry.h>


@interface TRNDepartureCell ()
@property (nonatomic, strong, readwrite) UILabel *destinationLabel;
@property (nonatomic, strong, readwrite) UILabel *expectedDepartureLabel;
@property (nonatomic, strong, readwrite) UILabel *serviceTitleLabel;
@property (nonatomic, strong, readwrite) UIImageView *lowFloorAccessImageView;
@end

@implementation TRNDepartureCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
		self.selectionStyle = UITableViewCellSelectionStyleNone;
		
		self.destinationLabel = [[UILabel alloc] initWithFrame:CGRectZero];\
		self.destinationLabel.adjustsFontSizeToFitWidth	= YES;
		self.destinationLabel.font = [UIFont systemFontOfSize:14.0];
		[self.contentView addSubview:self.destinationLabel];
		
		self.expectedDepartureLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		self.expectedDepartureLabel.adjustsFontSizeToFitWidth = YES;
		self.expectedDepartureLabel.font = [UIFont systemFontOfSize:22.0];
		[self.contentView addSubview:self.expectedDepartureLabel];
		
		self.serviceTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		self.serviceTitleLabel.adjustsFontSizeToFitWidth = YES;
		self.serviceTitleLabel.font = [UIFont systemFontOfSize:22.0];
		[self.contentView addSubview:self.serviceTitleLabel];
		
		self.lowFloorAccessImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wheelchair"]];
		[self.contentView addSubview:self.lowFloorAccessImageView];
		
    }
    return self;
}

- (void)prepareForReuse {
	[super prepareForReuse];
	
	self.destinationLabel.text = nil;
	self.expectedDepartureLabel.text = nil;
	self.serviceTitleLabel.text = nil;
}

- (void)layoutSubviews {
	[super layoutSubviews];
	
	UIEdgeInsets padding = UIEdgeInsetsMake(5, 15, 5, 15);
	
	[self.expectedDepartureLabel sizeToFit];
	if (self.lowFloorAccessLabelIsVisible) {
		[self.expectedDepartureLabel updateConstraints:^(MASConstraintMaker *make) {
			make.top.equalTo(self.expectedDepartureLabel.superview.top).with.offset(padding.top);
			make.right.equalTo(self.expectedDepartureLabel.superview.right).with.offset(-padding.right);
		}];
		
		self.lowFloorAccessImageView.hidden = NO;
		[self.lowFloorAccessImageView updateConstraints:^(MASConstraintMaker *make) {
			make.bottom.equalTo(self.lowFloorAccessImageView.superview.bottom).with.offset(-padding.bottom);
			make.right.equalTo(self.expectedDepartureLabel.superview.right).with.offset(-padding.right);
		}];
	}
	else {
		self.lowFloorAccessImageView.hidden = YES;
        CGFloat expectedDepartureLabelHeight = CGRectGetHeight(self.expectedDepartureLabel.frame);
		[self.expectedDepartureLabel updateConstraints:^(MASConstraintMaker *make) {
			make.top.equalTo(self.expectedDepartureLabel.superview.top).with.offset(expectedDepartureLabelHeight/2);
			make.right.equalTo(self.expectedDepartureLabel.superview.right).with.offset(-padding.right);
		}];
	}
	
	[self.serviceTitleLabel updateConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.serviceTitleLabel.superview.top).with.offset(padding.top);
		make.left.equalTo(self.serviceTitleLabel.superview.left).with.offset(padding.left);
		make.right.lessThanOrEqualTo(self.expectedDepartureLabel.left);
		make.height.equalTo(self.expectedDepartureLabel.height);
	}];
    
	[self.destinationLabel updateConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.serviceTitleLabel.bottom).with.offset(padding.top);
		make.bottom.equalTo(self.destinationLabel.superview.bottom).with.offset(-padding.bottom);
		make.left.equalTo(self.serviceTitleLabel.superview.left).with.offset(padding.left);
		make.right.lessThanOrEqualTo(self.expectedDepartureLabel.left);
	}];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


@end
