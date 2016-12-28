//
//  TRNCoreDataConfigurator.m
//  Transport
//
//  Created by Luke Stringer on 20/04/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import "TRNCoreDataManager.h"
#import "NSURL+TRNDocumentsDirectory.h"
#import "TRNConstants.h"

@implementation TRNCoreDataManager

+ (NSPersistentStoreCoordinator *)legacyPersistentStoreCoordinator {
    NSManagedObjectModel *model = [NSManagedObjectModel mergedModelFromBundles:nil];
    NSPersistentStoreCoordinator *persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    
    NSURL *staticStoreURL = [NSURL trn_urlForFileInDocumentsNamed:[self staticSQLiteFileName]];
    NSURL *userStoreURL = [NSURL trn_urlForFileInDocumentsNamed:TRNStoreName_User]; // named wrong in earlier build
    
    NSDictionary *options = @{
                              NSMigratePersistentStoresAutomaticallyOption: @(YES),
                              NSInferMappingModelAutomaticallyOption : @(YES)
                              };
    
    [persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                             configuration:TRNStoreConfiguration_Static
                                                       URL:staticStoreURL
                                                   options:options
                                                     error:nil];
    
    [persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                             configuration:TRNStoreConfiguration_User
                                                       URL:userStoreURL
                                                   options:options
                                                     error:nil];
    
    return persistentStoreCoordinator;
}

+ (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
	NSManagedObjectModel *model = [NSManagedObjectModel mergedModelFromBundles:nil];
	NSPersistentStoreCoordinator *persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
	
	NSURL *staticStoreURL = [NSURL trn_urlForFileInDocumentsNamed:[self staticSQLiteFileName]];
	NSURL *userStoreURL = [NSURL trn_urlForFileInDocumentsNamed:[self userSQLiteFileName]];
    
    // Static data should not be backed up
    NSError *error = nil;
    [staticStoreURL setResourceValue:@(YES) forKey:NSURLIsExcludedFromBackupKey error:&error];
	
	NSDictionary *options = @{
							  NSMigratePersistentStoresAutomaticallyOption: @(YES),
							  NSInferMappingModelAutomaticallyOption : @(YES)
							  };
	
	[persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
											 configuration:TRNStoreConfiguration_Static
													   URL:staticStoreURL
												   options:options
													 error:nil];
	
	[persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
											 configuration:TRNStoreConfiguration_User
													   URL:userStoreURL
												   options:options
													 error:nil];
	
	return persistentStoreCoordinator;
}

+ (BOOL)staticStoreExists {
	NSString *sqlitePath = [[NSURL trn_urlForFileInDocumentsNamed:[self staticSQLiteFileName]] path];
	return [[NSFileManager defaultManager] fileExistsAtPath:sqlitePath];
}

+ (void)loadPrecomputedSQLiteData {
	
	NSString *sqliteName = TRNStoreName_Static;
	NSString *sqlitePath = [[NSURL trn_urlForFileInDocumentsNamed:[self staticSQLiteFileName]] path];
	NSString *sqliteWALPath = [[NSURL trn_urlForFileInDocumentsNamed:[sqliteName stringByAppendingString:@".sqlite-wal"]] path];
	NSString *sqliteSHMPath = [[NSURL trn_urlForFileInDocumentsNamed:[sqliteName stringByAppendingString:@".sqlite-shm"]] path];
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *preloadSQLitePath = [[NSBundle mainBundle]
                                   pathForResource:TRNStoreName_Static ofType:@"sqlite"];
    NSString *preloadSQLiteWALPath = [[NSBundle mainBundle]
                                      pathForResource:TRNStoreName_Static ofType:@"sqlite-wal"];
    NSString *preloadSQLiteSHMPath = [[NSBundle mainBundle]
                                      pathForResource:TRNStoreName_Static ofType:@"sqlite-shm"];
    
    NSError *error = nil;
    
    /**
     *  Remove existing sqlite data
     */
    [fileManager removeItemAtPath:sqlitePath error:&error];
    if (error) {
        NSLog(@"Failed to remove sqlitePath");
        error = nil;
    }
    
    [fileManager removeItemAtPath:sqliteWALPath error:&error];
    if (error) {
        NSLog(@"Failed to remove sqliteWALPath");
        error = nil;
    }
    
    [fileManager removeItemAtPath:sqliteSHMPath error:&error];
    if (error) {
        NSLog(@"Failed to remove sqliteSHMPath");
        error = nil;
    }
    
   
    /**
     *  Copy preloaded sqlite data
     */
    [fileManager copyItemAtPath:preloadSQLitePath
                         toPath:sqlitePath
                          error:&error];
    if (error) {
        NSLog(@"Could not load .sqlite");
        error = nil;
    }
    [fileManager copyItemAtPath:preloadSQLiteWALPath
                         toPath:sqliteWALPath
                          error:&error];
    if (error) {
        NSLog(@"Could not load .sqlite-wal");
        error = nil;
    }
    [fileManager copyItemAtPath:preloadSQLiteSHMPath
                         toPath:sqliteSHMPath
                          error:&error];
    if (error) {
        NSLog(@"Could not load .sqlite-shm");
        error = nil;
    }


}


+ (NSString *)staticSQLiteFileName {
	return [TRNStoreName_Static stringByAppendingString:@".sqlite"];
}

+ (NSString *)userSQLiteFileName {
	return [TRNStoreName_User stringByAppendingString:@".sqlite"];
}


@end
