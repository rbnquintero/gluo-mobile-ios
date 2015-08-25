//
//  ToDoListTests.m
//  ToDoListTests
//
//  Created by Ruben Quintero on 8/10/15.
//  Copyright (c) 2015 Ruben Quintero. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "SimpleCar.h"

@interface ToDoListTests : XCTestCase

@end

@implementation ToDoListTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    XCTAssert(YES, @"Pass");
    NSLog(@"Your message here");
    printf("\n");
    
    int some = 123;
    // int *someo = &some;
    printf("Some %i %i", some, 123);
    
    NSString *testString;
    testString = [[NSString alloc] init];
    testString = @"Here's a test string in testString!";
    NSLog(@"testString: %@", testString);
    
    testString = @"Here's another test string in testString!";
    NSLog(@"testString: %@", testString);
    
    SimpleCar *myCar = [[SimpleCar alloc] init];
    
    NSNumber *newVin = [NSNumber numberWithInt:123];
    
    [myCar setVin:newVin];
    [myCar setMake:@"Honda" andModel:@"Civic"];
    
    NSLog(@"The car is: %@ %@", [myCar make], [myCar model]);
    NSLog(@"The vin is: %@", [myCar vin]);
    
    
    printf("\n");
    printf("\n");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
