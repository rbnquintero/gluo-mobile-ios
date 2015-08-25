//
//  NavigationDispatcherViewController.m
//  ControllerTest
//
//  Created by Ruben Quintero on 8/21/15.
//  Copyright (c) 2015 Ruben Quintero. All rights reserved.
//

#import "NavigationDispatcherViewController.h"
#import "DetailViewController.h"
#import "TestItem.h"

@interface NavigationDispatcherViewController ()

@end

@implementation NavigationDispatcherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"prepareForSegue NavigationDispatcher");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    NSLog(@"prepareForSegue NavigationDispatcher");
}

@end
