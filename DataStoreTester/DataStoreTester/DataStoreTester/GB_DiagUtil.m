//
//  GB_DiagUtil.m
//  DataStoreTester
//
//  Copyright (c) 2014 Golden Bits Software. All rights reserved.
//
#import <sys/time.h>
#import <mach/mach.h>
#import "GB_DiagUtil.h"

@implementation GB_DiagUtil


+ (NSInteger)getCurrentMillsecs {

    struct timeval time;
    gettimeofday(&time, NULL);
    long millis = (time.tv_sec * 1000) + (time.tv_usec / 1000);
    
    return (NSInteger)millis;
}




+ (NSInteger) getMemoryUsage {
    
    struct task_basic_info info;
    mach_msg_type_number_t size = sizeof(info);
    
    kern_return_t kerr = task_info(mach_task_self(),
                                   TASK_BASIC_INFO,
                                   (task_info_t)&info,
                                   &size);
    
    if( kerr != KERN_SUCCESS ) {
        NSLog(@"Error with task_info(): %s", mach_error_string(kerr));
        info.resident_size = 0;
    }
    

    return (long)info.resident_size;
}


+ (NSInteger) getFileSizeKBytes:(NSString*)path {
    
    NSInteger sizeKb = 0;
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        
        
        NSDictionary *fileAttributes = [[NSFileManager defaultManager]
                                        attributesOfItemAtPath:path error:nil];
        // get size
        NSNumber *fileSizeNumber = [fileAttributes objectForKey:NSFileSize];
        long long fileSize = [fileSizeNumber longLongValue];
        
        sizeKb = (long)(fileSize / 1024L);
    }
    
    return sizeKb;
}

+ (float) getCpuUsage {

    kern_return_t kr;
    task_info_data_t tinfo;
    mach_msg_type_number_t task_info_count;
    
    task_info_count = TASK_INFO_MAX;
    
    kr = task_info(mach_task_self(), TASK_BASIC_INFO, (task_info_t)tinfo, &task_info_count);
    
    if (kr != KERN_SUCCESS) {
        return -1;
    }
    
    task_basic_info_t      basic_info;
    thread_array_t         thread_list;
    mach_msg_type_number_t thread_count;
    
    thread_info_data_t     thinfo;
    mach_msg_type_number_t thread_info_count;
    
    thread_basic_info_t basic_info_th;
    uint32_t stat_thread = 0; // Mach threads
    
    basic_info = (task_basic_info_t)tinfo;
    
    // get threads in the task
    kr = task_threads(mach_task_self(), &thread_list, &thread_count);
    
    if (kr != KERN_SUCCESS) {
        return -1;
    }
    if (thread_count > 0)
        stat_thread += thread_count;
    
    long tot_sec = 0;
    long tot_usec = 0;
    float tot_cpu = 0;
    int j;
    
    // loop through all of the threads for this process and get the
    // CPU usage time.
    for (j = 0; j < thread_count; j++)
    {
        thread_info_count = THREAD_INFO_MAX;
        
        kr = thread_info(thread_list[j], THREAD_BASIC_INFO,
                         (thread_info_t)thinfo, &thread_info_count);
        
        if (kr != KERN_SUCCESS) {
            return -1;
        }
        
        basic_info_th = (thread_basic_info_t)thinfo;
        
        if (!(basic_info_th->flags & TH_FLAGS_IDLE)) {
            tot_sec = tot_sec + basic_info_th->user_time.seconds + basic_info_th->system_time.seconds;
            tot_usec = tot_usec + basic_info_th->system_time.microseconds + basic_info_th->system_time.microseconds;
            tot_cpu = tot_cpu + basic_info_th->cpu_usage / (float)TH_USAGE_SCALE * 100.0;
        }
        
    } // for each thread
    
    kr = vm_deallocate(mach_task_self(), (vm_offset_t)thread_list, thread_count * sizeof(thread_t));
    
    if(kr != KERN_SUCCESS) {
        NSLog(@"Failed to deallocate vm memory, error: %s", mach_error_string(kr));
    }
    
    return tot_cpu;
}




    
@end
