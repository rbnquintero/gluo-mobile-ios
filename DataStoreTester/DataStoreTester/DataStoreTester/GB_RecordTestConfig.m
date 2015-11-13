//
//  GB_RecordTestConfig.m
//  DataStoreTester
//
//  Copyright (c) 2014 Golden Bits Software. All rights reserved.
//

#import "GB_RecordTestConfig.h"

@implementation GB_RecordTestConfig

// vars w/default values
static int numRecsToCreate = 4000;
static bool useCoreDataForRecs = true;
static bool refechRecs = true;


+(int) numRecs {
    @synchronized(self) { return numRecsToCreate; }
}

+ (void) setnumRecs:(int)val {
    @synchronized(self) { numRecsToCreate = val; }
}



+(bool) useCoreData {
    @synchronized(self) { return useCoreDataForRecs; }
}

+ (void) setuseCoreData:(bool)val {
    @synchronized(self) { useCoreDataForRecs = val; }
}

+(bool) refetchCarRecs {
    @synchronized(self) { return refechRecs; }
}

+ (void) setrefetchCarRecs:(bool)val {
    @synchronized(self) { refechRecs = val; }
}



@end
