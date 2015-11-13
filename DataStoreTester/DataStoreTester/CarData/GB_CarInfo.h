//
//  GB_CarInfo.h
//  DataStoreTester
//
//  Copyright (c) 2014 Golden Bits Software. All rights reserved.
//

#import <Foundation/Foundation.h>


// keys used for the car detail dictionary
#define DETAIL_GROUP_KEY        @"DetailGroup"
#define INFO_1_KEY              @"info_1"
#define INFO_2_KEY              @"info_2"


// Contains informaiton for one car
@interface GB_CarInfo : NSObject


// Properties for the car record
@property (nonatomic) NSString *modelName;
@property (nonatomic) NSInteger year;
@property (nonatomic) NSInteger price;

// properites for the car manufacure
@property (nonatomic) NSString *manufacturerName;
@property (nonatomic) NSString *manufacturerHQloc;
@property (nonatomic) NSInteger numEmployees;

// properites for the car type
@property (nonatomic) NSString *typeName;  // SUV, Electric, Passenger, etc..
@property (nonatomic) NSString *typeDesc;  // type descripiton

// properties for the car detail, dictionary
@property(nonatomic) NSMutableDictionary *detailDict;


// For SQLite, time took to fetch car details
@property NSInteger fetchTimeMs;


// car id field used for SQLite, used to identify the specific car.
@property NSNumber* carid;


// method to clear car info
- (void) clear;
- (void) getFullDetails;

@end






