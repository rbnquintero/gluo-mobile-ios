//
//  DBManager.m
//  ControllerTest
//
//  Created by Ruben Quintero on 9/9/15.
//  Copyright (c) 2015 Ruben Quintero. All rights reserved.
//

#import "DBManager.h"
#import <CoreData/CoreData.h>

static DBManager *sharedInstance = nil;
static sqlite3 *database = nil;
static sqlite3_stmt *statement = nil;
@implementation DBManager

+(DBManager*) getSharedInstance {
    if(!sharedInstance){
        sharedInstance = [[super allocWithZone:NULL]init];
    }
    return sharedInstance;
}

-(BOOL) createDB {
    NSString *docsDir;
    NSArray *dirPaths;
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = dirPaths[0];
    
    // Build the path to the database file
    databasePath = [[NSString alloc] initWithString:[docsDir stringByAppendingString:@"/student.db"]];
    BOOL isSuccess = YES;
    NSFileManager *filemgr = [NSFileManager defaultManager];
    if([filemgr fileExistsAtPath:databasePath] == NO) {
        const char *dbpath = [databasePath UTF8String];
        if (sqlite3_open(dbpath, &database) == SQLITE_OK) {
            char *errMsg;
            const char *sql_stmt = "create table if not exists studentsDetail (regno integer primary key, name text, department text, year text)";
            if (sqlite3_exec(database, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK) {
                isSuccess = NO;
                NSLog(@"Failed to create table");
            }
            sqlite3_close(database);
            return isSuccess;
        } else {
            isSuccess = NO;
            NSLog(@"Failed to open/create database");
        }
    }
    return isSuccess;
}

-(BOOL) saveData:(NSString *)registerNumber name:(NSString *)name department:(NSString *)department year:(NSString *)year {
    return YES;
}

-(NSArray*) findByRegisterNumber:(NSString *)registerNumber {
    return nil;
}

- (void) coreData {
    // Declare coordinator
    NSPersistentStoreCoordinator *persisStCoord;
    
    // Prepare coordinator and get PersistentStore. If it doesn't exist, it's created an empty file
    NSPersistentStore *perStore;
    NSURL *tPth;
    NSError *tErr;
    tPth = [NSURL fileURLWithPath:@"/Users/Foo/Foo.sqlite"];
    perStore = [persisStCoord addPersistentStoreWithType:NSSQLiteStoreType configuration:nil  URL:tPth options:nil  error:&tErr];
    
    NSManagedObjectModel *mgdObjMdl;
    tPth = [NSURL fileURLWithPath:@"/Library/Application Support/Foo/Bar.momd"];
    mgdObjMdl = [[NSManagedObjectModel alloc] initWithContentsOfURL:tPth];
    
    
    // Initialize coordinator
    persisStCoord = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mgdObjMdl];
    
    // Declare
    NSManagedObjectContext *moContext;
    moContext = [[NSManagedObjectContext alloc]init];
    [moContext setPersistentStoreCoordinator:persisStCoord];
    
    
}

@end
