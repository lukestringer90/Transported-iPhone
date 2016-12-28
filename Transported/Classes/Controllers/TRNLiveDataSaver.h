//
//  TRNLiveDataSaver.h
//  Transported
//
//  Created by Luke Stringer on 28/06/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TRNLiveDataSaver : NSObject

+ (void)saveHTML:(NSString *)HTML NaPTANCode:(NSString *)NaPTANCode;
+ (void)clearSavedValues;

@end
