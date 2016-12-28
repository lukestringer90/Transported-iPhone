//
//  TRNAboutFooterView.m
//  Transported
//
//  Created by Luke Stringer on 11/06/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import "TRNAboutFooterView.h"
#import <Masonry/Masonry.h>

static CGFloat const XOffset = 15;
static CGFloat const SectionDivide = 10;
static CGFloat const LabelDivide = 10;

@interface TRNAboutFooterView ()
@property (nonatomic, strong) UILabel *dataTitleLabel;
@property (nonatomic, strong) UILabel *dataLabel;
@end

@implementation TRNAboutFooterView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _dataTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _dataTitleLabel.font = [UIFont systemFontOfSize:14.0];
        _dataTitleLabel.textColor = [UIColor darkGrayColor];
        _dataTitleLabel.text = [self dataTitleLabelText];
        [self addSubview:_dataTitleLabel];
        
        _dataLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _dataLabel.font = [UIFont systemFontOfSize:14.0];
        _dataLabel.textColor = [UIColor darkGrayColor];
        _dataLabel.attributedText = [self dataLabelText];
        _dataLabel.numberOfLines = 0;
        [self addSubview:_dataLabel];
        
        
        [self.dataTitleLabel sizeToFit];
        [self.dataLabel sizeToFit];
        
    }
    return self;
}

- (NSString *)dataTitleLabelText {
    NSString *text = @"Data Acknowledgements";
    return [text uppercaseString];
}

- (NSAttributedString *)dataLabelText {
    NSString *text = [NSString stringWithFormat:@"%@\n\n%@\n\n%@", [self governmentText], [self travelSouthYorkshireText], [self travelWestYorkshireText]];

    
    NSMutableParagraphStyle *paragrahStyle = [[NSMutableParagraphStyle alloc] init];
    [paragrahStyle setParagraphSpacing:-5];
    
    return [[NSAttributedString alloc] initWithString:text attributes:@{NSParagraphStyleAttributeName : paragrahStyle}];
    
}

- (NSString *)governmentText {
    return @"National Public Transport Access Nodes: Contains public sector information licensed under the Open Government Licence v2.0.";
}

- (NSString *)travelSouthYorkshireText {
    return @"Live Departure Information: Copyright South Yorkshire Passenger Transport Executive website 2004.";
}

- (NSString *)travelWestYorkshireText {
    return @"Live Departure Information: Copyright West Yorkshire Passenger Transport Executive.";
}

- (CGFloat)dataLabelHeightForWidth:(CGFloat)width {
    return [self.dataLabel sizeThatFits:CGSizeMake(width, CGFLOAT_MAX)].height;
}



- (void)layoutSubviews {
    
    CGFloat labelWidth = CGRectGetWidth(self.frame) - 2 * XOffset;
    
    [self.dataTitleLabel updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(SectionDivide);
        make.left.equalTo(self).with.offset(XOffset);
        make.width.equalTo(@(labelWidth));
    }];
    
    [self.dataLabel updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.dataTitleLabel.bottom).with.offset(LabelDivide);
        make.left.equalTo(self).with.offset(XOffset);
        make.width.equalTo(@(labelWidth));
        make.height.equalTo(@([self dataLabelHeightForWidth:labelWidth]));
    }];

    [super layoutSubviews];
}


- (CGFloat)heightForWidth:(CGFloat)width {
    CGFloat adjustedWidth = width - (2 * XOffset);
    
    CGFloat height = SectionDivide + CGRectGetHeight(self.dataTitleLabel.frame) + LabelDivide +  [self dataLabelHeightForWidth:adjustedWidth] + SectionDivide;
    return height;
}

@end
