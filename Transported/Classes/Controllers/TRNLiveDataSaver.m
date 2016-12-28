//
//  TRNLiveDataSaver.m
//  Transported
//
//  Created by Luke Stringer on 28/06/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import "TRNLiveDataSaver.h"

NSString * const TRNLiveDataSaverHTMLKey    = @"TRNLiveDataSaverHTMLKey";
NSString * const TRNLiveDataSaverNaPTANKey  = @"TRNLiveDataSaverNaPTANKey";

@implementation TRNLiveDataSaver

+ (void)saveHTML:(NSString *)HTML NaPTANCode:(NSString *)NaPTANCode {
    [[Crashlytics sharedInstance] setObjectValue:HTML forKey:@"HTML"];
    [[Crashlytics sharedInstance] setObjectValue:NaPTANCode forKey:@"NaPTANCode"];
}

+ (void)clearSavedValues {
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:TRNLiveDataSaverNaPTANKey];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:TRNLiveDataSaverHTMLKey];
    [[NSUserDefaults standardUserDefaults] synchronize];

}

@end
