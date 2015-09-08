//
//  RESTServiceViewController.m
//  ControllerTest
//
//  Created by Ruben Quintero on 9/8/15.
//  Copyright (c) 2015 Ruben Quintero. All rights reserved.
//

#import "RESTServiceViewController.h"
#import "RESTService.h"

@interface RESTServiceViewController ()

@end

@implementation RESTServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.restService = [RESTService initializeWithURL:@"http://jsonplaceholder.typicode.com/posts" andDelegate:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void) handleResponse:(NSDictionary *)response {
    NSLog(@"Service response: %@", response);
    self.responseLabel.text= [response objectForKey:@"content"];
}

- (void) handleResponsePost {
    NSLog(@"POST OK");
}

- (IBAction)testService:(id)sender {
    [self.restService getRESTServiceResponse];
}
@end
