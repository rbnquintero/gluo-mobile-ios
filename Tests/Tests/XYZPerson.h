//
//  XYZPerson.h
//  Tests
//
//  Created by Ruben Quintero on 8/17/15.
//  Copyright (c) 2015 Ruben Quintero. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XYZPerson : NSObject

@property (readonly) NSString* firstName;
@property (readonly, getter=getLastName) NSString* lastName;
@property NSDate* dateOfBirth;
@property (readonly) NSString *uniqueIdentifier;
@property NSArray* numerosFavoritos;

- (id) initWithFirstName:(NSString *)aFirstName lastName:(NSString *) aLastName;

- (void) sayHello;

- (void) setFirstName:(NSString *) firstName andLastName:(NSString *) lastName;

+ (XYZPerson *) newPerson;

@end
