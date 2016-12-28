//
//  TRNDatabaseVersion.m
//  Transported
//
//  Created by Luke Stringer on 12/10/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import "TRNDatabaseVersion.h"

static NSString * const PLISTFileName =             @"DatabaseVersion";
static NSString * const DatabaseVersionNumberKey =  @"DatabaseVersionNumber";

@implementation TRNDatabaseVersion

+ (NSInteger)currentDatabaseVersionNumber {
    return [[[NSUserDefaults standardUserDefaults] valueForKey:DatabaseVersionNumberKey] integerValue];
}

+ (NSInteger)staticDatabaseVersionNumber {
    NSString *filepath = [[NSBundle mainBundle] pathForResource:PLISTFileName ofType:@"plist"];
    NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:filepath];
    
    if (!dictionary) {
        return 0;
    }
    
    NSNumber *databaseVersionNumber = dictionary[DatabaseVersionNumberKey];
    return [databaseVersionNumber integerValue];
}

+ (void)setCurrentDatabaseVersion:(NSInteger)databaseVersionNumber {
    [[NSUserDefaults standardUserDefaults] setObject:@(databaseVersionNumber) forKey:DatabaseVersionNumberKey];
}

@end
