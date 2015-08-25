//
//  SimpleCar.m
//  ToDoList
//
//  Created by Ruben Quintero on 8/14/15.
//  Copyright (c) 2015 Ruben Quintero. All rights reserved.
//

#import "SimpleCar.h"

@implementation SimpleCar

//@synthesize make, model, vin;

// convenience method
- (void) setMake: (NSString*)newMake
        andModel: (NSString*)newModel {
    [self setMake:newMake ];
    [self setModel:newModel];
}

/* Methods before synthesize

// set methods
- (void) setVin:   (NSNumber*)newVin{
    vin = [[NSNumber alloc] init];
    vin = newVin;
}
- (void) setMake:  (NSString*)newMake {
    make = [[NSString alloc] initWithString:newMake];
}
- (void) setModel: (NSString*)newModel {
    model = [[NSString alloc] initWithString:newModel];
}

// get methods
- (NSString*) make {
    return make;
}
- (NSString*) model {
    return model;
}
- (NSNumber*) vin {
    return vin;
}*/

@end
