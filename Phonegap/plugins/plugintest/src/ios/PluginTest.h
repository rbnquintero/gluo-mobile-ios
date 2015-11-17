//
//  PluginTest.h
//  Hello World
//
//  Created by Ruben Quintero on 11/9/15.
//
//

#import <Cordova/CDV.h>

@interface PluginTest : CDVPlugin

// Native code to load data from disk and return the String.
- (NSString *) testString:(NSString *) input;

@end
