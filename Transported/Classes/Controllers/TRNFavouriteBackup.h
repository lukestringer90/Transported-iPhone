//
//  TRNUserStopRestorer.h
//  Transported
//
//  Created by Luke Stringer on 24/11/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TRNFavouriteBackup : NSObject

- (void)createBackup;
- (void)restoreBackup;

@end
