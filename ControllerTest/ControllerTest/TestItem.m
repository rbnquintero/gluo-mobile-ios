//
//  TestItem.m
//  ControllerTest
//
//  Created by Ruben Quintero on 8/20/15.
//  Copyright (c) 2015 Ruben Quintero. All rights reserved.
//

#import "TestItem.h"
@interface TestItem ()

@property NSNumber *testId;
@property NSString *testNombre;
@property NSString *segueName;

@end

@implementation TestItem

-(NSString*) getTestName {
    NSString *testName = [NSString stringWithFormat:@"Test %@ - %@", _testId, _testNombre];
    return testName;
}

+(TestItem*) initTestItem:(NSNumber *)testId withData:(NSString *)testName {
    TestItem *item = [[TestItem alloc] init];
    item.testId = testId;
    item.testNombre = testName;
    return item;
}

+(TestItem*) initTestItem:(NSNumber *)testId withName:(NSString *)testName andSegue:(NSString *)segueName {
    TestItem *item = [[TestItem alloc] init];
    item.testId = testId;
    item.testNombre = testName;
    item.segueName = segueName;
    return item;
}

@end
