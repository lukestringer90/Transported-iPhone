//
//  TRNSectionIndexJSONGenerator.h
//  Transported
//
//  Created by Luke Stringer on 17/05/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TRNSectionIndexJSONGenerator : NSObject

+ (void)generateSectionIndexesFromManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

@end
