//
//  CarType.h
//  DataStoreTester
//
//  Copyright (c) 2014 Golden Bits Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Car;

@interface CarType : NSManagedObject

@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSString * type_desc;
@property (nonatomic, retain) NSSet *car;
@end

@interface CarType (CoreDataGeneratedAccessors)

- (void)addCarObject:(Car *)value;
- (void)removeCarObject:(Car *)value;
- (void)addCar:(NSSet *)values;
- (void)removeCar:(NSSet *)values;

@end
