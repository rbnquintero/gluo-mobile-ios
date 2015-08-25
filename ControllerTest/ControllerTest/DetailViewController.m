//
//  DetailViewController.m
//  ControllerTest
//
//  Created by Ruben Quintero on 8/21/15.
//  Copyright (c) 2015 Ruben Quintero. All rights reserved.
//

#import "DetailViewController.h"
#import "TestItem.h"
#import "ContainerViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //[self performSegueWithIdentifier:@"manual" sender:self];
    //UIStoryboard *storyboard = self.storyboard;
    //UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"manualViewOne"];
    //UINavigationController *nc = [self navigationController];
    
    // Configure controller
    //[nc pushViewController:vc animated:NO];
    
    //[self presentViewController:vc animated:NO completion:nil];
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
    NSString *segueName = segue.identifier;
    NSLog(@"Segue identifier: %@", segueName);
    if([segueName isEqualToString:@"containerSegue"]){
        ContainerViewController *containerController = [segue destinationViewController];
        containerController.testItem = self.testItem;
    }
}

@end
