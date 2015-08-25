//
//  SimpleCar.h
//  ToDoList
//
//  Created by Ruben Quintero on 8/14/15.
//  Copyright (c) 2015 Ruben Quintero. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SimpleCar : NSObject {
    //NSString* make;
    //NSString* model;
    //NSNumber* vin;
}

@property(readwrite, retain) NSString* make;
@property(readwrite, retain) NSString* model;
@property(readwrite, retain) NSNumber* vin;

- (void) setMake: (NSString*)newMake
        andModel: (NSString*)newModel;

@end
