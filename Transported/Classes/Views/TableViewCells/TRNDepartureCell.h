//
//  TRNDepartureCell.h
//  Transport
//
//  Created by Luke Stringer on 30/03/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TRNDepartureCell : UITableViewCell

@property (nonatomic, strong, readonly) UILabel *destinationLabel;
@property (nonatomic, strong, readonly) UILabel *expectedDepartureLabel;
@property (nonatomic, strong, readonly) UILabel *serviceTitleLabel;
@property (nonatomic, assign, readwrite, getter = lowFloorAccessLabelIsVisible) BOOL lowFloorAccessLabelVisible;

@end
