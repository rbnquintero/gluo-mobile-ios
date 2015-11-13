//
//  GB_Preferences.h
//  DataStoreTester
//
//  Copyright (c) 2014 Golden Bits Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GB_Preferences : NSObject

// initializer
+(void)initialize;

// methods to get set user perferences

+ (bool)useCoreData;
+ (void)setUseCoreData:(bool)useCore;
+(int)getNumberOfRecsToCreate;
+(void)setNumberOfRecsToCreate:(int)numRecs;

+(void)registerDefaultPreferences;
+(void)saveCurrentPrefs;
+(void)getCurrentPrefs;

@end
