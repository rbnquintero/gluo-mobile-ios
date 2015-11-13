//
//  AAAEmployeeMO.h
//  ControllerTest
//
//  Created by Ruben Quintero on 9/23/15.
//  Copyright © 2015 Ruben Quintero. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface AAAEmployeeMO : NSManagedObject

@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSDate *startDate;

@end
