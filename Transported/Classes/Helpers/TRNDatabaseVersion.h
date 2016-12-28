//
//  TRNDatabaseVersion.h
//  Transported
//
//  Created by Luke Stringer on 12/10/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TRNDatabaseVersion : NSObject

/*
 *  Version number of the current database used by core data.
 */
+ (NSInteger)currentDatabaseVersionNumber;

/*
 *  Version number of the precomputed static database included in the bundle.
 */
+ (NSInteger)staticDatabaseVersionNumber;

/*
 *  Set the version number of the current database used by core data.
 */
+ (void)setCurrentDatabaseVersion:(NSInteger)databaseVersionNumber;

@end
