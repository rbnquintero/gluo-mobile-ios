//
//  GB_CarsCoreData.h
//  DataStoreTester
//
//  Copyright (c) 2014 Golden Bits Software. All rights reserved.
//


#import <Foundation/Foundation.h>

#import "GB_CarDataProtocol.h"

// Class is used to encapulate all of CoreData objects used
// by CoreData.

@class Car;

@interface GB_CarsCoreData : NSObject <GB_CarDataProtocol>

+ (id)sharedManager;

// filename for our DB
@property (nonatomic,strong) NSString *dbFileName;


@end
