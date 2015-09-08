//
//  RESTServiceViewController.h
//  ControllerTest
//
//  Created by Ruben Quintero on 9/8/15.
//  Copyright (c) 2015 Ruben Quintero. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RESTService.h"

@interface RESTServiceViewController : UIViewController<RESTServiceDelegate>
- (IBAction)testService:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *responseLabel;

@property RESTService* restService;

@end
