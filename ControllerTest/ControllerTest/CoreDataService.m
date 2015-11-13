//
//  CoreDataService.m
//  ControllerTest
//
//  Created by Ruben Quintero on 9/23/15.
//  Copyright © 2015 Ruben Quintero. All rights reserved.
//

#import "CoreDataService.h"
#import "AAAEmployeeMO.h"

@implementation CoreDataService

- (id) init {
    self = [super init];
    if(!self) return nil;
    
    [self initializeCoreData];
    
    return self;
}

- (void) initializeCoreData {
    // Managed Object Model
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"CoreDataTest" withExtension:@"momd"];
    NSManagedObjectModel *mom = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    NSAssert(mom!= nil, @"Error initializing Managed Object Model");
    
    // Persistent Store Coordinator
    NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];
    // Managed Object Context
    NSManagedObjectContext *moc = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [moc setPersistentStoreCoordinator:psc];
    [self setManagedObjectContext:moc];
    
    // Generation of DB File URL
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *documentsURL = [[fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    NSURL *storeURL = [documentsURL URLByAppendingPathComponent:@"DataModel.sqlite"];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        NSError *error = nil;
        NSPersistentStoreCoordinator *psc = [[self managedObjectContext] persistentStoreCoordinator];
        NSPersistentStore *store = [psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error];
        NSAssert(store != nil, @"Error initializing PSC: %@\n%@", [error localizedDescription], [error userInfo]);
    });
    
    //[self saveNew];
}

- (void) saveNew: (NSString *) firstName :(NSString *) lastName {
    AAAEmployeeMO *employee = [NSEntityDescription insertNewObjectForEntityForName:@"Person" inManagedObjectContext:[self managedObjectContext]];
    
    [employee setFirstName:@"Ruben"];
    [employee setLastName:@"Quintero"];
    
    NSError *error = nil;
    if([[self managedObjectContext] save:&error] == NO) {
        NSAssert(NO, @"Error saving context: %@\n%@", [error localizedDescription], [error userInfo]);
    }
}

- (void) fetchAllPersons {
    NSManagedObjectContext *moc = [self managedObjectContext];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Person"];
    
    //  Optional predicate
    // NSString *firstName = @"Ruben";
    // [request setPredicate:[NSPredicate predicateWithFormat:@"firstName == %@", firstName]];
    
    NSError *error = nil;
    NSArray *results = [moc executeFetchRequest:request error:&error];
    if(!results) {
        NSLog(@"Error fetching Employee objects: %@\n%@", [error localizedDescription], [error userInfo]);
        abort();
    }
    [self.delegate showPersonas:results];
}

@end
