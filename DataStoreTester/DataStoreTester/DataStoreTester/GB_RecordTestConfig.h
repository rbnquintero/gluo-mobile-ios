//
//  GB_RecordTestConfig.h
//  DataStoreTester
//
//  Copyright (c) 2014 Golden Bits Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GB_RecordTestConfig : NSObject

+(int) numRecs;
+(void)setnumRecs:(int)val;

+(bool) useCoreData;
+(void) setuseCoreData:(bool)val;

+(bool) refetchCarRecs;
+(void) setrefetchCarRecs:(bool)val;

@end
