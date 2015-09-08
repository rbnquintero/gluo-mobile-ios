//
//  RESTService.h
//  ControllerTest
//
//  Created by Ruben Quintero on 9/8/15.
//  Copyright (c) 2015 Ruben Quintero. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RESTServiceDelegate <NSObject>
@required
- (void) handleResponse: (NSDictionary*) response;
- (void) handleResponsePost;
@end

@interface RESTService : NSObject

@property(nonatomic,strong) id<RESTServiceDelegate> delegate;
+ (id) initializeWithURL: (NSString *)url andDelegate: (id)delegate;
- (void) getRESTServiceResponse;

@end
