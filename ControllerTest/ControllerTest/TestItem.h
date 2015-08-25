//
//  TestItem.h
//  ControllerTest
//
//  Created by Ruben Quintero on 8/20/15.
//  Copyright (c) 2015 Ruben Quintero. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TestItem : NSObject

@property (readonly) NSNumber *testId;
@property (readonly) NSString *testNombre;
@property (readonly) NSString *segueName;

-(NSString*) getTestName;

+(TestItem*) initTestItem:(NSNumber*)testId withData:(NSString*)testName;

+(TestItem*) initTestItem:(NSNumber *)testId withName:(NSString *)testName andSegue:(NSString *)segueName;

@end
