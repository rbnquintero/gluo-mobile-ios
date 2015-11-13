//
//  GB_CarsCoreData.m
//  DataStoreTester
//
//  Copyright (c) 2014 Golden Bits Software. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "GB_CarsCoreData.h"
#import "Car.h"
#import "Manufacturer.h"
#import "CarType.h"
#import "CarDetails.h"
#import "GB_CarInfo.h"
#import "GB_CarTestData.h"
#import "GB_DiagUtil.h"

@implementation GB_CarsCoreData {
    
    // private member vars
    NSManagedObjectContext * _managedObjectContext;
    NSManagedObjectModel * _mangedModel;
    NSPersistentStoreCoordinator * _persistenCoord;
    
    // path to data store file
    NSString *_dataStoreDb;
    
    // car info
    GB_CarInfo *_carInfo;
    GB_CarTestData *_carTestData;
    
    // our sample Manufacture, CarType, Details
    NSMutableArray *_mfgInfoList;
    NSMutableArray *_carDetails;
    NSMutableArray *_carTypes;
    
    // flag
    bool _sampeDataCreated;
}



@synthesize dbFileName;



// class method to create singleton
+ (id)sharedManager {
    
    static GB_CarsCoreData *carsCoreData = nil;
    
    @synchronized(self) {
        if (carsCoreData == nil)
            carsCoreData = [[self alloc] init];
    }
    
    return carsCoreData;
}


- (id) init {
    
    // call super
    self = [super init];
    
    if( self != nil ) {
        _carInfo = [[GB_CarInfo alloc] init];
        
        // set default DB name
        dbFileName = @"carsdata.sqlite";
        
        [self createPersistentStoreCoordinator];
        
        _carTestData = [GB_CarTestData sharedManager];
    }
    
    return self;
}


- (void)createSampleData {
    
    if(_sampeDataCreated)
        return;
    
    if(!_managedObjectContext) {
        NSLog(@"Managed Object Context is nil.");
        return;
    }
    
    // purge/delete any previos records
    [self clearSampleData];
    
    _mfgInfoList = [NSMutableArray arrayWithCapacity:20];
    _carTypes = [NSMutableArray arrayWithCapacity:20];
    
    // create the sampel data that is referenced by each of
    // the car records.
    for(NSString *mfgname in _carTestData._carManufacturer) {
        
        // Create One manufacturer
        Manufacturer *manufacturer =[NSEntityDescription insertNewObjectForEntityForName:@"Manufacturer"
                                                                  inManagedObjectContext:_managedObjectContext];
        
        manufacturer.name = mfgname;
        manufacturer.hq_location = @"Detroit, MI";
        manufacturer.num_employees = [NSNumber numberWithInt:(rand() % 30000)];
        
        // add to our array
        [_mfgInfoList addObject:manufacturer];
    }
    
    for(NSString *carType in _carTestData._carTypes) {
        
        // create the car type
        CarType *cartype = [NSEntityDescription insertNewObjectForEntityForName:@"CarType"
                                                         inManagedObjectContext:_managedObjectContext];
        cartype.type = carType;
        cartype.type_desc = @"Type Description";
        
        // add to our array
        [_carTypes addObject:cartype];
    }
    
    _sampeDataCreated = true;
    
}

-(void) clearSampleData {
    
    if(_mfgInfoList != nil) {
        [_mfgInfoList removeAllObjects];
        _mfgInfoList = nil;
    }
    
    
    if(_carTypes != nil) {
        [_carTypes removeAllObjects];
        _carTypes = nil;
    }
    
    _sampeDataCreated = false;
}

- (bool) createOneCar:(int)number {
    
    // create out sample data
    [self createSampleData];
    
    [_carInfo clear];
    
    [_carTestData createCarInfo:_carInfo inNumber:number];
    
    // now get a car core data entity and fill in
    Car *car = [NSEntityDescription insertNewObjectForEntityForName:@"Car"
                                      inManagedObjectContext:_managedObjectContext];
    
    car.model = _carInfo.modelName;
    car.year = [NSNumber numberWithInt:(int)_carInfo.year];
    car.msrp = [NSNumber numberWithInt:(int)_carInfo.price];
    
    // now add car to mfg rec
    int mfgIdx = number % _mfgInfoList.count;
    Manufacturer *carMfg = _mfgInfoList[mfgIdx];
    [carMfg addCarObject:car];
    
    
    // Add Car Type
    int carTypeIdx = number % _carTypes.count;
    CarType *carType = _carTypes[carTypeIdx];
    [carType addCarObject:car];
    
    
    // Add CarDetails
    // NOTE: CarDetails is a ???
    NSMutableDictionary *detailDict = _carInfo.detailDict;
    
    // Create CarDetail entity
    CarDetails *cardetails = [NSEntityDescription insertNewObjectForEntityForName:@"CarDetails"
                                                           inManagedObjectContext:_managedObjectContext];
    
    cardetails.detailgroup = detailDict[DETAIL_GROUP_KEY];
    cardetails.info_1 = detailDict[INFO_1_KEY];
    cardetails.info_2 = detailDict[INFO_2_KEY];
    
    // now create the NSSet from the mutable array
    [car addCardetailsObject:cardetails];
    
    return true;
}


// stub function, this protocol method is really intended for
// use by the SQLite implementation
- (bool) fetchCarDetails:(GB_CarInfo*)carInfo  timeMs:(NSInteger*)time {
    
    // not implemented
    return false;
}


- (bool)saveStore {

    NSError *error = nil;
    
    if (_managedObjectContext == nil)
        return false;
    
    if ([_managedObjectContext hasChanges] && ![_managedObjectContext save:&error]) {
        
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        return false;
    }
    
    return true;
}

// build a fetch request for cars entity
// return -1 on error, else # cars fetched, also return
// fetch time in msec

- (int) fetchCars:(NSArray **)results  timeMs:(NSInteger*)time {
    
    // check the managed context is set
    if( _managedObjectContext == nil) {
        return -1;
    }
    
    // get start time
    NSInteger start = [GB_DiagUtil getCurrentMillsecs];
    
    // Create our fetch request
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Car"
                                              inManagedObjectContext:_managedObjectContext];
    
    [fetchRequest setEntity:entity];

    NSError *err;
    NSArray *fetchedCarObjects = [_managedObjectContext executeFetchRequest:fetchRequest error:&err];
    
    if (fetchedCarObjects == nil) {
        NSLog(@"CoreData fectched failed. Error %@, %@", err, [err userInfo]);
        return -1;
    }
    
    
    // Time took to fetch
    *time = [GB_DiagUtil getCurrentMillsecs] - start;
    

    // set pointer into return value
    *results = fetchedCarObjects;

    
    // return number of cars fetched
    return (int)fetchedCarObjects.count;
}


-(bool) createOpenStore {
    
    // is the store already created ?
    // if so, the close it
    if( !_persistenCoord ) {
        return false;
    }
    
    // purge/delete any previos records
    [self clearSampleData];
    
    [self setStoreFile];
    
    // create managed object and set the persistent coordinator
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    
    [_managedObjectContext setPersistentStoreCoordinator:_persistenCoord];

    return true;
}


-(bool)deleteStore {
    
    // purge/delete any previos records
    [self clearSampleData];
    
    if(_managedObjectContext) {
        // reset managed object, this will free NSManagedObjects in
        // it's context
        [_managedObjectContext reset];
        
        _managedObjectContext = nil;
    }
    
    if(_persistenCoord) {
    
        // remove the store file from the persistent store file
        [self removeStoreFile];
        
        NSURL *storeURL = [[self documentDir] URLByAppendingPathComponent:dbFileName ];
        
        _dataStoreDb = storeURL.path;
        
        // Delete file
        NSError *error;
        if ([[NSFileManager defaultManager] fileExistsAtPath:storeURL.path]) {
            if (![[NSFileManager defaultManager] removeItemAtPath:storeURL.path error:&error]) {
                NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            } 
        }
    }
    
    return true;
}

// set the store into the persistent coordinator
- (void) setStoreFile {
    
    if( _persistenCoord == nil) {
        return;
    }
    
    
    NSURL *storeURL = [[self documentDir] URLByAppendingPathComponent:dbFileName ];
    
    NSError *error = nil;

    // NOTE: Here's where you specify the type of store to use.
    if (![_persistenCoord addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL
                                             options:nil error:&error]) {
        
        NSLog(@"Failed to add store, error %@, %@", error, [error userInfo]);
    }
}

- (void)removeStoreFile {
    
    // check that we have persistent stores
    NSArray *storeList = [_persistenCoord persistentStores];

    if(storeList == nil || storeList.count == 0) {
        return;
    }

    // now delete the data store file itself
    NSPersistentStore *store = [storeList objectAtIndex:0];

    // remove store
    // NOTE: This flushes the sqlite-wal (write ahead log) to the db.
    NSError *err;
    if([_persistenCoord removePersistentStore:store error:&err] == NO) {
    
        // error in removing store
        NSLog(@"Failed to remove store: error %@, %@", err, [err userInfo]);
    }
}

- (void) closeStore {
    
    
    // purge/delete any previos records
    [self clearSampleData];
    
    if( _managedObjectContext != nil) {
        
        // reset managed object
        [_managedObjectContext reset];
        _managedObjectContext = nil;
    }
    
    // remove store file from peristent store coordiantor
    [self removeStoreFile];
    
}


// Returns the URL to the application's Documents directory.
- (NSURL *)documentDir
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                   inDomains:NSUserDomainMask] lastObject];
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)createPersistentStoreCoordinator
{
    // create managed model
    if( ![self createManagedModel] ) {
        NSLog(@"Failed to create managed model.");
        return nil;
    }
    
    _persistenCoord = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_mangedModel ];
    
    return _persistenCoord;
}


- (NSManagedObjectModel *)createManagedModel
{
    
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"CarModel" withExtension:@"momd"];
    
    _mangedModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    return _mangedModel;
}

- (NSInteger)getDataStoreSizeKBytes {

    NSInteger sizeKbytes= 0;
    
    sizeKbytes = [GB_DiagUtil getFileSizeKBytes:_dataStoreDb];
    
    return sizeKbytes;
}

    
@end
