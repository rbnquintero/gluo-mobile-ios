//
//  GB_CarDataProtocol.h
//  DataStoreTester
//
//  Copyright (c) 2014 Golden Bits Software All rights reserved.
//

#import <Foundation/Foundation.h>

@class GB_CarInfo;

@protocol GB_CarDataProtocol <NSObject>

- (bool) createOneCar:(int)number;
- (bool) saveStore;
- (bool) createOpenStore;
- (void) closeStore;
- (bool) deleteStore;
- (int) fetchCars:(NSArray **)results timeMs:(NSInteger*)time;
- (bool) fetchCarDetails:(GB_CarInfo*)carInfo timeMs:(NSInteger*)time;
- (NSInteger) getDataStoreSizeKBytes;

@end
