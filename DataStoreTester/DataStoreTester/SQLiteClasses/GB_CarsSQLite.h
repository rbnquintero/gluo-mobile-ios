//
//  GB_CarsSQLite.h
//  DataStoreTester
//
//  Copyright (c) 2014 Golden Bits Software. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GB_CarDataProtocol.h"


@interface GB_CarsSQLite : NSObject <GB_CarDataProtocol>

+ (id)sharedManager;


@end
