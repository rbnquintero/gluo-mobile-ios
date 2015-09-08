//
//  RESTService.m
//  ControllerTest
//
//  Created by Ruben Quintero on 9/8/15.
//  Copyright (c) 2015 Ruben Quintero. All rights reserved.
//

#import "RESTService.h"

@interface RESTService ()
@property NSURL *url;
@end

void (^CompletitionHandler)(NSURLResponse *response, NSData *data, NSError *connectionError);

@implementation RESTService

+ (id) initializeWithURL:(NSString *)urlString andDelegate: (id)delegate {
    RESTService *restService = [[RESTService alloc] init];
    NSURL *url = [NSURL URLWithString:urlString];
    [restService setUrl:url];
    [restService setDelegate:delegate];
    return restService;
}

- (void) getRESTServiceResponse {
    NSURLRequest *request = [NSURLRequest requestWithURL: self.url];
    
    
    CompletitionHandler = ^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (data.length > 0 && connectionError == nil) {
            NSDictionary *greeting = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
            [self.delegate handleResponse:greeting];
        }
    };
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:CompletitionHandler];
    
}

- (void) postRESTServiceResponse {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: self.url];
    [request setHTTPMethod:@"POST"];
    NSString *postString = @"company=Locassa&quality=AWESOME!";
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    CompletitionHandler = ^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError == nil) {
            [self.delegate handleResponsePost];
        }
    };
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:CompletitionHandler];
}

@end
