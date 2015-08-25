//
//  main.m
//  Tests
//
//  Created by Ruben Quintero on 8/17/15.
//  Copyright (c) 2015 Ruben Quintero. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XYZPerson.h"
#import "XYZPerson+XYZPersonNameDisplayAdditions.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"Hello, World!");
        XYZPerson *person = [[XYZPerson alloc] initWithFirstName:@"Jazmín" lastName:@"Sánchez"];
        [person sayHello];
        
        XYZPerson *other = [XYZPerson newPerson];
        [other setFirstName:@"Ruben" andLastName:@"Quintero"];
        [other sayHello];
        NSLog(@"%@",[other lastNameFirstNameString]);
        for (id eachObject in other.numerosFavoritos) {
            NSLog(@"Object: %@", eachObject);
        }
        
        XYZPerson *another = [XYZPerson new];
        [another sayHello];
        NSLog(@"longitud %lu", (unsigned long)[other.firstName length]);
        NSLog(@"longitud %lu", (unsigned long)[[other firstName] length]);
        
        NSDictionary *dictionary = @{
            @"anObject" : other,
            @"helloString" : @"Hello, World!",
            @"magicNumber" : @42,
            @"aValue" : person
        };
        
        NSLog(@"how many keys? %lu", [dictionary count]);
        NSLog(@"%@", dictionary[@"helloString"]);
        for (NSString *eachKey in dictionary) {
            id object = dictionary[eachKey];
            NSLog(@"Object: %@ for key: %@", object, eachKey);
        }
    }
    return 0;
}
