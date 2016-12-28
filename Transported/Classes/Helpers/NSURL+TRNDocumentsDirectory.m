//
//  NSURL+TRNDocumentsDirectory.m
//  Transport
//
//  Created by Luke Stringer on 20/04/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import "NSURL+TRNDocumentsDirectory.h"

@implementation NSURL (TRNDocumentsDirectory)

+ (NSURL *)trn_urlForFileInDocumentsNamed:(NSString *)filename {
    NSURL *documentsURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
	return [documentsURL URLByAppendingPathComponent:filename];
}

@end
