//
//  DBManager.h
//  ControllerTest
//
//  Created by Ruben Quintero on 9/9/15.
//  Copyright (c) 2015 Ruben Quintero. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface DBManager : NSObject {
    NSString *databasePath;
}

+(DBManager*) getSharedInstance;
-(BOOL) createDB;
-(BOOL) saveData:(NSString*)registerNumber name:(NSString*)name department:(NSString*)department year:(NSString*)year;
-(NSArray*) findByRegisterNumber: (NSString*)registerNumber;

@end
