//
//  TRNConstants.h
//  Transported
//
//  Created by Luke Stringer on 24/09/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

static NSUInteger const TRNNearbyTableViewMaxStops = 50;
static NSUInteger const TRNNearbyStopsMaxDistance = 5000; // in meters

static NSString * const TRNStoreName_Static              = @"transported-static";
static NSString * const TRNStoreName_User                = @"transported-user";

static NSString * const TRNStoreConfiguration_Static     = @"StaticStoreConfiguration";
static NSString * const TRNStoreConfiguration_User       = @"UserStoreConfiguration";

static NSString * const TRNStopIndexesJSONFilename_All   = @"section-indexes-all";
static NSString * const TRNStopIndexesJSONFilename_Buses = @"section-indexes-buses";
static NSString * const TRNStopIndexesJSONFilename_Trams = @"section-indexes-trams";
