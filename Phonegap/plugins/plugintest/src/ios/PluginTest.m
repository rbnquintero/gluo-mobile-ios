//
//  PluginTest.m
//  Hello World
//
//  Created by Ruben Quintero on 11/9/15.
//
//

#import "PluginTest.h"

@implementation PluginTest

- (NSString*) testString:(NSString *)input {
    NSLog(@"String input: %@", input);
    return @"Success!";
}

@end
