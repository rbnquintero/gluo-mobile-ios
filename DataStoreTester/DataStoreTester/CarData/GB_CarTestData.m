//
//  GB_CarTestData.m
//  DataStoreTester
//
//  Copyright (c) 2014 Golden Bits Software. All rights reserved.
//

// some dummy test data for cars

#import "GB_CarTestData.h"
#import "GB_CarInfo.h"

@implementation GB_CarTestData


@synthesize _carManufacturer;
@synthesize _carModels;
@synthesize _detailGroup;
@synthesize _carTypes;


// class method to create singleton
+ (id)sharedManager {
    
    static GB_CarTestData *carsTestData = nil;
    
    @synchronized(self) {
        if (carsTestData == nil) {
            carsTestData = [[self alloc] init];
            [carsTestData createTestData];
         }
    }
    
    return carsTestData;
}


- (void) createTestData {
    
    // some dummy car data
    _carManufacturer = [NSArray arrayWithObjects:@"Aston Martin", @"Lotus", @"Jaguar", @"Bentley",
                                           @"Ford", @"Chevy", @"Dodge", @"Fiat", @"Honda",
                                           @"Toyota", nil];
    
    // made up car names
    _carModels = [NSArray arrayWithObjects:@"Fox", @"Pinto", @"Alure", @"RitzFitz",
                                          @"Nova", @"Free Wheel", @"Smart Choice", @"Gas Eater",
                                          @"Moving Out", nil];
    
    _detailGroup = [NSArray arrayWithObjects:@"Drive Train", @"Wheels", @"Interior", @"Electronics",
                                         @"Capacity", @"Crash Test", nil];

    _carTypes  = [NSArray arrayWithObjects:@"Truck", @"SUV", @"Passenger", @"Electric",
                                   @"Commuter", @"Off Road", nil];

}

- (void) createCarInfo:(GB_CarInfo*)carInfo inNumber:(int)number {

    static int detailidx = 0;
    static int caridx = 0;
    
    [carInfo clear];
    
    // Properties for the car record
    if(++caridx >= _carModels.count)
        caridx = 0;
    
    carInfo.modelName = [NSString stringWithFormat:@"%@_%i", _carModels[caridx], number];
    
    carInfo.year = 1980;
    carInfo.price = 35000;
    
    
    
    // properties for the car detail
    // create dictionary w/dummy detail
    NSMutableDictionary *detailDict = [[NSMutableDictionary alloc] init];
    
    if(++detailidx >= _detailGroup.count)
        detailidx = 0;
    
    NSString *groupname = _detailGroup[detailidx];
    [detailDict setObject:groupname forKey:DETAIL_GROUP_KEY];
    [detailDict setObject:@"Detailed info 1" forKey:INFO_1_KEY];
    [detailDict setObject:@"Detailed info 2" forKey:INFO_2_KEY];
    
    carInfo.detailDict = detailDict;
}


@end
