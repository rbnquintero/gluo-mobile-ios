//
//  Car.h
//  DataStoreTester
//
//  Copyright (c) Golden Bits Software All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Manufacturer;
@class CarType;

@interface Car : NSManagedObject

@property (nonatomic, retain) NSString * model;
@property (nonatomic, retain) NSNumber * msrp;
@property (nonatomic, retain) NSNumber * year;
@property (nonatomic, retain) NSSet *cardetails;
@property (nonatomic, retain) CarType *cartype;
@property (nonatomic, retain) Manufacturer *manufacturer;
@end

@interface Car (CoreDataGeneratedAccessors)

- (void)addCardetailsObject:(NSManagedObject *)value;
- (void)removeCardetailsObject:(NSManagedObject *)value;
- (void)addCardetails:(NSSet *)values;
- (void)removeCardetails:(NSSet *)values;

@end
