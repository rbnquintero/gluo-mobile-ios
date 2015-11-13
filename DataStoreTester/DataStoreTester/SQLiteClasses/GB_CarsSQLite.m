//
//  GB_CarsSQLite.m
//  DataStoreTester
//
//  Copyright (c) Golden Bits Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "GB_CarsSQLite.h"
#import "GB_CarTestData.h"
#import "GB_CarInfo.h"
#import "GB_DiagUtil.h"


#define FOREIGN_KEY_ON_STMT "PRAGMA foreign_keys=ON"

#define MFG_TABLE_CREATE_STMT "create table if not exists manufacturer (id integer "  \
                                 "primary key autoincrement, hq_location text, name text,  num_employees integer)"


#define CARTYPE_TABLE_CREATE_STMT "create table if not exists cartype (id integer "  \
                                 "primary key autoincrement, type text, type_desc text)"

#define CARDETAILS_TABLE_CREATE_STMT "create table if not exists cardetails (id integer "  \
                            "primary key autoincrement, detailgroup text, info_1 text, info_2 text)"

#define CAR_TABLE_CREATE_STMT  "create table if not exists car (id integer "  \
                               "primary key autoincrement, model text, msrp integer, year integer, " \
                               "mfg_id integer, cartype_id integer, cardetails_id integer, " \
                               "foreign key(mfg_id) references manufacturer (id), " \
                               "foreign key(cartype_id) references cartype (id), " \
                               "foreign key(cardetails_id) references cardetails (id) )"


// table insert statements
#define MFG_INSERT_STMT "insert into manufacturer (hq_location, name, num_employees) " \
                             "values('%s', '%s', %d)"

#define CARTYPE_INSERT_STMT "insert into cartype (type, type_desc) values('%s', '%s')"

#define CARDETAILS_INSERT_STMT "insert into cardetails (detailgroup, info_1, info_2) " \
                            "values('%s', '%s', '%s')"

#define CAR_BULK_INSERT_BEG   @"insert into car (model, msrp, year, mfg_id, cartype_id, cardetails_id) VALUES "
#define CAR_BULK_INSERT_END   @";"


// select statements
#define MFG_SELECT_ID_STMT        "select id from manufacturer"
#define CARTYPE_SELECT_ID_STMT    "select id from cartype"
#define CARDET_SELECT_ID_STMT     "select id from cardetails"
#define CARS_SELECT_STMT          "select id, model, msrp, year from car"

// This statements gets all of the info for a car by joining the various
// tables that contain the details.
#define CAR_ALL_INFO_JOIN_STMT    @"select car.model, car.year, car.msrp, cardetails.detailgroup, " \
                                  "cardetails.info_1, cardetails.info_2, manufacturer.hq_location, " \
                                  "manufacturer.name, manufacturer.num_employees, cartype.type, " \
                                  "cartype.type_desc  from car inner join cartype on " \
                                  "car.cartype_id = cartype.id inner join cardetails on " \
                                  "car.cardetails_id = cardetails.id inner join manufacturer on " \
                                  "car.mfg_id = manufacturer.id where car.id = %@"


@implementation GB_CarsSQLite {
    
    sqlite3 *_dbObj;   // Sqlite3 DB handle
    NSURL *_dbPath; // path to DB file
    
    // array used to store the keys of the referenced
    // DB tables.
    NSMutableArray *_mfgKeys;
    NSMutableArray *_carTypeKeys;
    NSMutableArray *_carDetailKeys;
    
    GB_CarTestData *_testData;
    
    NSString *_bulkInsertStmt;
    int _insertcnt;
};




// class method to create singleton
+ (id)sharedManager {
    
    static GB_CarsSQLite *carsSQLite = nil;
    
    @synchronized(self) {
        if (carsSQLite == nil)
            carsSQLite = [[self alloc] init];
    }
    
    return carsSQLite;
}



- (id)init {
    
    self = [super init];
    
    // create our db path
    if(self) {
        
        _dbPath = [[self documentDir] URLByAppendingPathComponent:@"cars.db" ];
        
        _testData= [GB_CarTestData sharedManager];
    }
    
    return self;
}



- (int) getKeyFromArray:(NSArray*)keyArray carNumber:(int)number {
    
    int idex = number % keyArray.count;
    NSNumber *keynum = keyArray[idex];
    int keyval = [keynum intValue];
    
    return keyval;
}

- (bool) createOneCar:(int)number {

    int mfg_key, cartype_key, detail_key;
    
    // get the keys for foreign tables
    mfg_key     = [self getKeyFromArray:_mfgKeys carNumber:number];
    cartype_key = [self getKeyFromArray:_carTypeKeys carNumber:number];
    detail_key  = [self getKeyFromArray:_carDetailKeys carNumber:number];

    
    int carIdx = number % _testData._carModels.count;
    
    // Add one car to the DB, use the number to idenity the car
    NSString *carmodelName = [NSString stringWithFormat:@"%@_%i", _testData._carModels[carIdx], number];
    
    int msrp = rand() % 45000;
    int year = 2000 + (rand() % 15);

    // build statement
    if(!_bulkInsertStmt) {
        _bulkInsertStmt = CAR_BULK_INSERT_BEG;
    }
    
    NSString *insertValues;
    
    if (_insertcnt == 0 ) {
        // model, msrp, year, mfg_id, cartype_id, cardetails_id)
        insertValues = [NSString stringWithFormat:@"( '%@', %d, %d, %d, %d, %d )",
                                      carmodelName, msrp, year, mfg_key, cartype_key, detail_key ];
    } else {
        
        // This just inserts a comma before the values
        insertValues = [NSString stringWithFormat:@", ( '%@', %d, %d, %d, %d, %d )",
                          carmodelName, msrp, year, mfg_key, cartype_key, detail_key ];
    }
    
    _insertcnt++;


    // now append bulk insert statement
    _bulkInsertStmt = [_bulkInsertStmt stringByAppendingString:insertValues ];
    
    return true;
}


// does the bulk insert
- (bool) saveStore {
    
    bool retval = true;
    char *errMsg;
    
    //  append terminaitng ';'
    _bulkInsertStmt = [_bulkInsertStmt stringByAppendingString:CAR_BULK_INSERT_END ];
    
    // convet NSString to char*
    const char *insertRecs = [_bulkInsertStmt UTF8String];
 
    // now do the insert
    if (sqlite3_exec(_dbObj, insertRecs, NULL,
                     NULL, &errMsg) != SQLITE_OK) {
        
        NSLog(@"Failed to insert car records, err '%s'", errMsg);
        
        // free mem
        sqlite3_free(errMsg);
        retval = false;
    }
    
    // reset our vars to insert more
    _insertcnt = 0;
    _bulkInsertStmt = nil;
    
    return retval;
}


// creates a new DB, if database already exists, then just
// opens an exsting DB.
- (bool) createOpenStore {
    
    NSLog(@"Creating or Opening database");
    
    // is the DB already opened?
    if(_dbObj)
       return true;
    
    NSFileManager *filemgr = [NSFileManager defaultManager];
    BOOL isExists = [filemgr fileExistsAtPath:[_dbPath path]];
    
    // convert DB to file path
    // Important: The returned dbpath pointer will be automatically freed
    //            so it must be used in this contenxt.
    const char *dbpath = [_dbPath fileSystemRepresentation];
    
    int ret = sqlite3_open(dbpath, &_dbObj);
    
    if (ret != SQLITE_OK) {
      
        NSLog(@"Failed to open datbase file: %s, error: %d", dbpath, ret);
        return false;
    }
    
    // db is now open successfuly
    // if the DB file exists, then don't add the supporting tables
    if(isExists)
        return true;
    
    // success bool
    bool success = false;
    
    // to get our error message;
    char *errMsg = NULL;
    
    do {
        
        // We need to explicitly turn on foreign key support
        if (sqlite3_exec(_dbObj, FOREIGN_KEY_ON_STMT, NULL,
                         NULL, &errMsg) != SQLITE_OK)
        {
            NSLog(@"Failed to enable foreign key support, err '%s'", errMsg);
            break;
        }
        
        
        if (sqlite3_exec(_dbObj, MFG_TABLE_CREATE_STMT, NULL,
                         NULL, &errMsg) != SQLITE_OK)
        {
            NSLog(@"Failed to create manufacture table, err '%s'", errMsg);
            break;
        }
        
        
        // create car type table
        if (sqlite3_exec(_dbObj, CARTYPE_TABLE_CREATE_STMT, NULL,
                         NULL, &errMsg) != SQLITE_OK)
        {
            NSLog(@"Failed to create cartype table, err '%s'", errMsg);
            break;
        }
        
        // create car type table
        if (sqlite3_exec(_dbObj, CARDETAILS_TABLE_CREATE_STMT, NULL,
                         NULL, &errMsg) != SQLITE_OK)
        {
            NSLog(@"Failed to create cardetails table, err '%s'", errMsg);
            break;
        }
        

        // create car table with foreign keys
        if (sqlite3_exec(_dbObj, CAR_TABLE_CREATE_STMT, NULL,
                         NULL, &errMsg) != SQLITE_OK)
        {
            NSLog(@"Failed to create car table, err '%s'", errMsg);
            break;
        }
        
        success = true;
       
    } while (false);
    
    // need to free the sqlite error message
    if( errMsg ) {
        sqlite3_free(errMsg);
        errMsg = NULL;
    }
    
    if(!success) {
        // close and delete db
        [self deleteStore];
    }
    
    // now fill the manufacture, cartype, and car details table with
    // dummy/test data that will be referenced by the car table.
    success = [self fillTestData];
    
    // After filling in the test data, we'll need to re-fetch it because
    // we need the id's (primary keys) of the supporting data tables.
    // We'll need these keys when inserting the car records.
    [self getTestDataKeys];
    
    return success;
}


- (bool) fillTestData {
    
    if(!_dbObj)
        return false;
    
    int cnt;
    
    // alloc large buff to handle insert statement
    char *insertStmt = malloc(1000);
    char *errMsg;
    
    // insert manufacture names
    for(cnt = 0; cnt < _testData._carManufacturer.count; cnt++) {
        
        const char *mfg_name = [_testData._carManufacturer[cnt] UTF8String];
        
        // build insert statement
        // limit out test employee number to a max of 30000
        sprintf(insertStmt,  MFG_INSERT_STMT,  "United States", mfg_name, rand() % 30000);
        
        // execute statement
        if (sqlite3_exec(_dbObj, insertStmt, NULL,
                         NULL, &errMsg) != SQLITE_OK) {
            NSLog(@"Failed to insert manufacturer test data, err '%s'", errMsg);
            
            sqlite3_free(errMsg);
            return false;
        }
    }
    
    // insert car type records
    for(cnt = 0; cnt < _testData._carTypes.count; cnt++) {
        
        const char *cartype = [_testData._carTypes[cnt] UTF8String];
        
        // build insert statement
        sprintf(insertStmt,  CARTYPE_INSERT_STMT,  cartype, "Dummy description");
        
        // execute statement
        if (sqlite3_exec(_dbObj, insertStmt, NULL,
                         NULL, &errMsg) != SQLITE_OK) {
            NSLog(@"Failed to insert cartype test data, err '%s'", errMsg);
            
            sqlite3_free(errMsg);
            return false;
        }
    }
    
    
    // insert car type records
    for(cnt = 0; cnt < _testData._detailGroup.count; cnt++) {
        
        const char *detailgroup = [_testData._detailGroup[cnt] UTF8String];
        
        // build insert statement
        sprintf(insertStmt,  CARDETAILS_INSERT_STMT, detailgroup,
                       "Detail 1", "Detail 2");
        
        // execute statement
        if (sqlite3_exec(_dbObj, insertStmt, NULL,
                         NULL, &errMsg) != SQLITE_OK) {
            NSLog(@"Failed to insert cardetail test data, err '%s'", errMsg);
            
            sqlite3_free(errMsg);
            return false;;
        }
    }
    
    // free memory allcoated w/malloc()
    free(insertStmt);
    
    return true;
}



// fetches the test data keys for later use when the car
// records are added to the DB.
- (bool) getTestDataKeys {
    
    // sanity check
    if(!_dbObj) {
        NSLog(@"Database not opened.");
        return false;
    }

    
    // get the number of records for the manufacture
    // select
    _mfgKeys = [[NSMutableArray alloc] init];
    if( ![self getIdFields:_mfgKeys select:MFG_SELECT_ID_STMT ] ) {
        NSLog(@"Failed to get manufacture ids");
        return false;
    }
    
    _carTypeKeys = [[NSMutableArray alloc] init];
    if( ![self getIdFields:_carTypeKeys select:CARTYPE_SELECT_ID_STMT]) {
        NSLog(@"Failed to get cartype ids");
        return false;
    }

    _carDetailKeys = [[NSMutableArray alloc] init];
    if( ![self getIdFields:_carDetailKeys select:CARDET_SELECT_ID_STMT ] ) {
        NSLog(@"Failed to get cardetails ids.");
        return false;
    }
    
    return true;
}


- (bool)getIdFields:(NSMutableArray*)idResults  select:(const char *)selectStmt {
   
    sqlite3_stmt *queryStmt;
    
    if(sqlite3_prepare_v2(_dbObj, selectStmt, -1, &queryStmt, nil) != SQLITE_OK) {
        return false;
    }
    
    // now loop through and get the ids
    while (sqlite3_step(queryStmt) == SQLITE_ROW) {
        
        // NOTE: The id (primary key) is always the first column.
        //       That's how the select statements are written.
        int idKey = sqlite3_column_int(queryStmt, 0);
        
        // now add to our array
        [idResults addObject:[NSNumber numberWithInt:idKey]];
    }
    
    // clean up statement
    sqlite3_finalize(queryStmt);
    
    return true;
}





- (bool) deleteStore {
    
    // close SQL handle
    if(_dbObj) {
        sqlite3_close(_dbObj);
        _dbObj = nil;
    }
    
    // clear out our keys stored in the mutable arrays.
    // Yes ARC should do this for us automatically, but I'm being
    // parnoid and yes ARC can (and does) fail at times.
    if(_mfgKeys) {
        [_mfgKeys removeAllObjects];
        _mfgKeys = nil;
    }
    
    if(_carTypeKeys) {
        [_carTypeKeys removeAllObjects];
        _carTypeKeys = nil;
    }
    
    if(_carDetailKeys) {
        [_carDetailKeys removeAllObjects];
        _carDetailKeys = nil;
    }
    
    
    // delete database file, ony if it exits
    NSFileManager *filemgr = [NSFileManager defaultManager];
    
    if( [filemgr fileExistsAtPath:[_dbPath path]] ) {
        
        NSLog(@"Deleting db file: %@", [_dbPath path]);
        
        if( ![filemgr removeItemAtURL:_dbPath error:nil]) {
            NSLog(@"Failed to delete db file: %@", [_dbPath path]);
        }
    }
    
    
    return true;
}

- (void) closeStore {
    
    // close SQL handle
    if(_dbObj) {   
        sqlite3_close(_dbObj);
        _dbObj = nil;
    }
}

- (int) fetchCars:(NSArray **)results timeMs:(NSInteger*)time{

    sqlite3_stmt *queryStmt;
    
    // initialize to nil, what's get returned on error
    *results = nil;
    
    // get start time
    NSInteger start = [GB_DiagUtil getCurrentMillsecs];
    
    // select stmt
    // id, model, msrp, year
    
    if(sqlite3_prepare_v2(_dbObj, CARS_SELECT_STMT, -1, &queryStmt, nil) != SQLITE_OK) {
        return -1;
    }
    
    // create NSAMutablerray and initalize it with ~50,0000 items
    NSMutableArray *gbCars = [NSMutableArray arrayWithCapacity:(NSUInteger)50000];

    // now loop through and get the ids
    while (sqlite3_step(queryStmt) == SQLITE_ROW) {
        
        // create 
        GB_CarInfo *carInfo = [[GB_CarInfo alloc] init];
        
        // Get the fields
        int idtemp = sqlite3_column_int(queryStmt, 0);
        carInfo.carid = [NSNumber numberWithInt:idtemp];
        
        // get string
        const unsigned char *model_text = sqlite3_column_text(queryStmt, 1);
        carInfo.modelName = [NSString stringWithUTF8String:(const char*)model_text];
        
        carInfo.price = sqlite3_column_int(queryStmt, 2);
        carInfo.year = sqlite3_column_int(queryStmt, 3);
        
        // now add to our array
        [gbCars addObject:carInfo];
    }
    
    // clean up statement
    sqlite3_finalize(queryStmt);
    
    // return the results array
    *results  = gbCars;
    
    // get end time
    *time = [GB_DiagUtil getCurrentMillsecs] - start;
    
    return (int)gbCars.count;
}


// fethches the details for a car from the db
- (bool) fetchCarDetails:(GB_CarInfo*)carInfo timeMs:(NSInteger*)time {
    
    sqlite3_stmt *queryStmt;
    
    // get start time
    NSInteger start = [GB_DiagUtil getCurrentMillsecs];
    
    // build select stmt
    // id, model, msrp, year, mfg_id, cartype_id, cardetails_id
    NSString *select =
         [NSString stringWithFormat:CAR_ALL_INFO_JOIN_STMT, carInfo.carid];
    
    const char *carSelectStmt = [select UTF8String];
    
    if(sqlite3_prepare_v2(_dbObj, carSelectStmt, -1, &queryStmt, nil) != SQLITE_OK) {
        return -1;
    }
    
    if(sqlite3_step(queryStmt) != SQLITE_ROW) {
        
        // empty row? which is OK vs. error?
        *time  = 0;
        return true;
    }
    
    // get end time
    // ** how long to fetch
    
    // success, now let's get our fields
    // car.model, car.year, car.msrp, cardetails.detailgroup, " \
    //"cardetails.info_1, cardetails.info_2, manufacturer.hq_location, " \
    //"manufacturer.name, manufacturer.num_employees, cartype.type, " \
    //"cartype.type_desc
    
    // NOTE: This is the tedious part, need to insure that you match the correct columns
    //       to data fields in the SQL select statement.
    
    carInfo.modelName = [NSString stringWithUTF8String: (const char*)sqlite3_column_text(queryStmt, 0)];
    carInfo.year = sqlite3_column_int(queryStmt, 1);
    carInfo.price = sqlite3_column_int(queryStmt, 2);
    
    NSMutableDictionary *detailDictInfo = [[NSMutableDictionary alloc] init];
    
    // cardetails.detailgroup
    NSString *detailgroup = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(queryStmt, 3)];
                             
    // cardetails.info_1
    NSString *detail_info_1 = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(queryStmt, 4)];
                               
    // cardetails.info_2
    NSString *detail_info_2 = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(queryStmt, 5)];
    
    [detailDictInfo setObject:detailgroup forKey:DETAIL_GROUP_KEY];
    [detailDictInfo setObject:detail_info_1 forKey:INFO_1_KEY];
    [detailDictInfo setObject:detail_info_2 forKey:INFO_2_KEY];
    
    carInfo.detailDict = detailDictInfo;
    

    // manufacturer.hq_location
    carInfo.manufacturerHQloc = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(queryStmt, 6)];
    
    // manufacturer.name
    carInfo.manufacturerName = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(queryStmt, 7)];
    
    // manufacturer.num_employees
    carInfo.numEmployees = sqlite3_column_int(queryStmt, 8);
    
    // cartype.type
    carInfo.typeName = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(queryStmt, 9)];
    
    // cartype.type_desc
    carInfo.typeDesc = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(queryStmt, 10)];
    
    // For SQLite, time took to fetch
    *time = [GB_DiagUtil getCurrentMillsecs] - start;
    
    return true;
}


- (NSInteger)getDataStoreSizeKBytes {
    
    NSInteger sizeMB = 0;
    
    NSString *storePath = _dbPath.path;
    
    sizeMB = [GB_DiagUtil getFileSizeKBytes:storePath ];
    
    return sizeMB;
}


// Returns the URL to the application's Documents directory.
- (NSURL *)documentDir
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                   inDomains:NSUserDomainMask] lastObject];
}

@end
