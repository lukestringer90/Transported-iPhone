//
//  TRNStopAddressCell.h
//  Transport
//
//  Created by Luke Stringer on 28/04/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import "TRNCell.h"
#import "TRNStop+Logic.h"

@interface TRNStopAddressCell : TRNCell

@property (nonatomic, strong, readonly) UILabel *titleLabel;
@property (nonatomic, strong, readonly) UILabel *streetLabel;
@property (nonatomic, strong, readonly) UILabel *localityLabel;
@property (nonatomic, strong, readonly) UILabel *naptanCodeLabel;
@property (nonatomic, assign) TRNStopType stopType;
@property (nonatomic, strong, readonly) UILabel *bearingIndicatorLabel;

+ (CGFloat)cellHeight;

@end
