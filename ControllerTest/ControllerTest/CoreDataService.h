//
//  CoreDataService.h
//  ControllerTest
//
//  Created by Ruben Quintero on 9/23/15.
//  Copyright © 2015 Ruben Quintero. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
@protocol CoreDataServiceDelegate <NSObject>
@required
- (void) showPersonas: (NSArray *) personas;
@end

@interface CoreDataService : NSObject
@property(nonatomic,strong) id<CoreDataServiceDelegate> delegate;
@property (strong) NSManagedObjectContext *managedObjectContext;

- (void) initializeCoreData;

- (void) saveNew: (NSString *) firstName :(NSString *) lastName;

- (void) fetchAllPersons;

@end
