//
//  XYZPerson.m
//  Tests
//
//  Created by Ruben Quintero on 8/17/15.
//  Copyright (c) 2015 Ruben Quintero. All rights reserved.
//

#import "XYZPerson.h"
#import "XYZPerson+XYZPersonNameDisplayAdditions.h"

@interface XYZPerson ()

@property NSString *uniqueIdentifier;

@end

@implementation XYZPerson

- (id) initWithFirstName:(NSString *)aFirstName lastName:(NSString *) aLastName {
    self = [super init];
    
    if(self) {
        _firstName = aFirstName;
        _lastName = aLastName;
    }
    
    return self;
}

- (void) sayHello {
    NSLog(@"Hello %@!", _firstName);
    if (self.numerosFavoritos > 0) {
        NSLog(@"Number of numbers: %lu", (unsigned long)[self.numerosFavoritos count]);
        if ([self.numerosFavoritos containsObject:@10]) {
            NSLog(@"Uno de los números es el 10");
        }
    }
}

- (void) setFirstName:(NSString *)firstName andLastName:(NSString *)lastName {
    _firstName = firstName;
    _lastName = lastName;
    
    self.uniqueIdentifier = @"1";
    self.numerosFavoritos = @[@1, @10];
}

+ (XYZPerson *) newPerson {
    return [[self alloc] init];
}

- (void) dealloc {
    NSLog(@"%@ is being deallocated", [self lastNameFirstNameString]);
}

@end
