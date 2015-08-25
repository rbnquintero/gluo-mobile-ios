//
//  XYZPersonNameDisplayAdditions.m
//  Tests
//
//  Created by Ruben Quintero on 8/20/15.
//  Copyright (c) 2015 Ruben Quintero. All rights reserved.
//

#import "XYZPerson+XYZPersonNameDisplayAdditions.h"

@implementation XYZPerson (XYZPersonNameDisplayAdditions)

- (NSString *)lastNameFirstNameString {
    return [NSString stringWithFormat:@"%@, %@", self.lastName, self.firstName];
}

@end
