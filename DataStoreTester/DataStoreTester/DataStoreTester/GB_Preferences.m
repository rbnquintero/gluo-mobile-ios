//
//  GB_Preferences.m
//  DataStoreTester
//
//  Copyright (c) 2014 Golden Bits Software. All rights reserved.
//

#import "GB_Preferences.h"
#import "GB_RecordTestConfig.h"

#define PREF_NUM_RECS_KEY               @"NumberofRecords"
#define PREF_NUM_RECS_DEFAULT           4000
#define PREF_USE_CORE_DATA              @"UseCoreData"
#define PREF_USE_CORE_DATA_DEFAULT      TRUE

@implementation GB_Preferences


// setup our preference dictionary
static NSDictionary *_appDefaults;


// initialize
+(void)initialize {
    
    _appDefaults  = @{
                       PREF_NUM_RECS_KEY : @PREF_NUM_RECS_DEFAULT,
                       PREF_USE_CORE_DATA: @PREF_USE_CORE_DATA_DEFAULT
                      };

}

// methods to get set user perferneces
+ (bool)useCoreData {
    
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    
    return [userDefaults boolForKey:PREF_USE_CORE_DATA]? TRUE : FALSE;
    
}


+ (void)setUseCoreData:(bool)useCore {
    
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    
    // BOOL and bool are usually defined as the same, but you can't
    // make that assumption.
    BOOL useCoreBoolVal = useCore ? TRUE : FALSE;
    
    [userDefaults setBool:useCoreBoolVal forKey:PREF_USE_CORE_DATA];
}

+(int)getNumberOfRecsToCreate {
    
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSInteger createCnt = [userDefaults integerForKey:PREF_NUM_RECS_KEY];

    return (int)createCnt;
}

+(void)setNumberOfRecsToCreate:(int)numRecs {
    
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
 
    [userDefaults setInteger:numRecs forKey:PREF_NUM_RECS_KEY];
}

+(void)registerDefaultPreferences {
    
    // Register the preference defaults
    [[NSUserDefaults standardUserDefaults] registerDefaults:_appDefaults];
    
}

+(void)getCurrentPrefs {
    
    [GB_RecordTestConfig setnumRecs:[self getNumberOfRecsToCreate]];
    
    [GB_RecordTestConfig setuseCoreData:[self useCoreData]];
}

+(void)saveCurrentPrefs {
    
    [self setUseCoreData:GB_RecordTestConfig.useCoreData];

    [self setNumberOfRecsToCreate:GB_RecordTestConfig.numRecs];
    
}

@end
