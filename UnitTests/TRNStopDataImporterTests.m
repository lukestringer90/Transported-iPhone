//
//  TRNStopDataImporterTests.m
//  Transport
//
//  Created by Luke Stringer on 31/03/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TRNStopDataImporter.h"
#import "TRNStop.h"
#import <KZPropertyMapper/KZPropertyMapper.h>


@interface TRNStopDataImporterTests : XCTestCase
@property (nonatomic, strong) NSManagedObjectContext *context;
@end

static NSString * const DataBaseName = @"transported-static";

@implementation TRNStopDataImporterTests

#pragma mark - Helpers

- (NSArray *)loadJSONFileNamed:(NSString *)fileName {
    NSString *filepath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"json"];
    if (filepath) {
        NSData *data = [NSData dataWithContentsOfFile:filepath];
        return [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    }
    return nil;
}

- (void)setupCoreDataStack {
    NSURL *storeURL = [self storeURL];
    
    // TODO: Delete existing store
    
    NSManagedObjectModel *model = [NSManagedObjectModel mergedModelFromBundles:nil];
    NSPersistentStoreCoordinator *persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    
    NSDictionary *options = @{
                              NSMigratePersistentStoresAutomaticallyOption: @(YES),
                              NSInferMappingModelAutomaticallyOption : @(YES),
                              NSSQLiteManualVacuumOption : @(YES)
                              };
    
    [persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                             configuration:nil
                                                       URL:storeURL
                                                   options:options
                                                     error:nil];
    
    self.context = [[NSManagedObjectContext alloc] init];
    self.context.persistentStoreCoordinator = persistentStoreCoordinator;
}

- (NSURL *)storeURL {
    NSURL *documentsURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
	return [documentsURL URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite", DataBaseName]];
}

- (void)setUp {
    [super setUp];
    
    [self setupCoreDataStack];
    
    [KZPropertyMapper logIgnoredValues:NO];
    
}

#pragma mark - Tests

- (void)testDataImportCount {
    
    NSArray *stopFilenames = @[
                               @"370_stops_0",
                               @"370_stops_1",
                               @"450_stops_0"
                               ];
    
    for (NSString *filename in stopFilenames) {
        id JSON = [self loadJSONFileNamed:filename];
        
        XCTAssertNotNil(JSON, @"");
        
        [TRNStopDataImporter importStopJSON:JSON intoContext:self.context];
    }
    
    [self.context save:NULL];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([TRNStop class])];
    request.predicate = [NSPredicate predicateWithFormat:@"fullTitle.length > 0"];
    
    NSInteger count = [self.context countForFetchRequest:request error:NULL];
    
    XCTAssert(count > 0, @"");
}

@end
