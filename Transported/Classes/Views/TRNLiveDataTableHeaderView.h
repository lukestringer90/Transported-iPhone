//
//  TRNLiveDataTableHeaderView.h
//  Transport
//
//  Created by Luke Stringer on 04/05/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TRNLiveDataTableHeaderView : UIView

@property (nonatomic, strong, readonly) UILabel *titleLabel;
@property (nonatomic, assign) BOOL showInitialDownloadLabel;

@end
