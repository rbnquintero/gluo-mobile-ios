//
//  GB_CarTestData.h
//  DataStoreTester
//
//  Copyright (c) 2014 Golden Bits Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GB_CarInfo;

@interface GB_CarTestData : NSObject

@property NSArray *_carManufacturer;
@property NSArray *_carModels;
@property NSArray *_detailGroup;
@property NSArray *_carTypes;


+ (id)sharedManager;

- (void) createTestData;
- (void) createCarInfo:(GB_CarInfo*)carInfo inNumber:(int)number;

@end
