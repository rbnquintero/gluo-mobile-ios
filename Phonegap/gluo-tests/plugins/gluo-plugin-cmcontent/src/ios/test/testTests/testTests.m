//
//  testTests.m
//  testTests
//
//  Created by Ruben Quintero on 11/13/15.
//  Copyright © 2015 Ruben Quintero. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CMContent.h"

@interface testTests : XCTestCase

@end

@implementation testTests

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
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    NSArray *args = @[@"Some"];
    CMContent* cm = [[CMContent alloc] init];
    CDVInvokedUrlCommand* cdvCmd = [cm getCDVObj:args];
    [cm getContenido:cdvCmd];
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
