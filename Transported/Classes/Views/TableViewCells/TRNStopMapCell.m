//
//  TRNStopMapCell.m
//  Transport
//
//  Created by Luke Stringer on 28/04/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import "TRNStopMapCell.h"

@implementation TRNStopMapCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

@end
