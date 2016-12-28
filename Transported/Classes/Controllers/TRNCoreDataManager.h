//
//  TRNCoreDataConfigurator.h
//  Transport
//
//  Created by Luke Stringer on 20/04/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TRNCoreDataManager : NSObject

+ (NSPersistentStoreCoordinator *)persistentStoreCoordinator;
+ (NSPersistentStoreCoordinator *)legacyPersistentStoreCoordinator;
+ (BOOL)staticStoreExists;
+ (void)loadPrecomputedSQLiteData;

@end
