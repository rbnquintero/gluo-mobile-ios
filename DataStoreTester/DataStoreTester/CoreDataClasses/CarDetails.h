//
//  CarDetails.h
//  DataStoreTester
//
//  Copyright (c) 2014 Golden Bits Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Car;

@interface CarDetails : NSManagedObject

@property (nonatomic, retain) NSString * detailgroup;
@property (nonatomic, retain) NSString * info_1;
@property (nonatomic, retain) NSString * info_2;
@property (nonatomic, retain) Car *car;

@end
