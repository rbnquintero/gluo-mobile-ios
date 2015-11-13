//
//  Manufacturer.h
//  DataStoreTester
//
//  Copyright (c) 2014 Golden Bits Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Manufacturer : NSManagedObject

@property (nonatomic, retain) NSString * hq_location;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * num_employees;
@property (nonatomic, retain) NSSet *car;
@end

@interface Manufacturer (CoreDataGeneratedAccessors)

- (void)addCarObject:(NSManagedObject *)value;
- (void)removeCarObject:(NSManagedObject *)value;
- (void)addCar:(NSSet *)values;
- (void)removeCar:(NSSet *)values;

@end
