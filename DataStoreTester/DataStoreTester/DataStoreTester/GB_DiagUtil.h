//
//  GB_DiagUtil.h
//  DataStoreTester
//
//  Copyright (c) 2014 Golden Bits Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GB_DiagUtil : NSObject

+ (NSInteger)getCurrentMillsecs;
+ (NSInteger) getMemoryUsage;
+ (NSInteger) getFileSizeKBytes:(NSString*)path;
+ (float) getCpuUsage;

@end
