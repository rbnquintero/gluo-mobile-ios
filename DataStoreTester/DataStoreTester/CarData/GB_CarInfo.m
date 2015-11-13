//
//  GB_CarInfo.m
//  DataStoreTester
//
//  Copyright (c) 2014 Golden Bits Software All rights reserved.
//

#import "Car.h"
#import "GB_CarInfo.h"


@implementation GB_CarInfo  {
    
    // only set when using core data
    Car *_coreDataCar;
}

// Properties for the car record
@synthesize modelName;
@synthesize year;
@synthesize price;

// properites for the car manufacure
@synthesize manufacturerName;
@synthesize manufacturerHQloc;
@synthesize numEmployees;

// properites for the car type
@synthesize typeName;  // SUV, Electric, Passenger, etc..
@synthesize typeDesc;  // type descripiton

// dictionary for the car detail
@synthesize  detailDict;


// simply nills everything out
- (void) clear {
    
    // Properties for the car record
    modelName = nil;
    year = 0;
    price = 0;
    
    manufacturerName = nil;
    manufacturerHQloc = nil;
    numEmployees  = 0;
    
    // properites for the car type
    typeName = nil;
    typeDesc = nil;
    
    // properties for the car detail
    // an array of dictionaries
    detailDict = nil;
    
    // TODO: Should I add clear? or free resources?
    _coreDataCar = nil;
}


- (void) getFullDetails {
    
    //
}

@end
