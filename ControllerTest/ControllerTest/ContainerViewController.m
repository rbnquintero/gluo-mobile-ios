//
//  ContainerViewController.m
//  ControllerTest
//
//  Created by Ruben Quintero on 8/25/15.
//  Copyright (c) 2015 Ruben Quintero. All rights reserved.
//

#import "ContainerViewController.h"

@interface ContainerViewController ()

@end

@implementation ContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"Is not null? %d", (self.testItem!=nil));
    if(self.testItem == nil) {
        NSString* defaultSegue = [self getDefaultSegue];
        if(defaultSegue == nil) {
            defaultSegue = @"embedFifth";
        }
        [self setTestItem:[TestItem initTestItem:@1 withName:@"First test" andSegue:defaultSegue]];
    }
    
    [self setDefaultSegue:_testItem.segueName];
    NSLog(@"%@", self.testItem.getTestName);
    // Do any additional setup after loading the view.
    
    [self performSegueWithIdentifier:self.testItem.segueName sender:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidAppear:(BOOL)animated {
    //UIStoryboard *storyboard = self.storyboard;
    //UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"manualViewOne"];
    //[self presentViewController:vc animated:NO completion:nil];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"Prepare for Segue");
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    [self addChildViewController:segue.destinationViewController];
    UIView *destView = ((UIViewController*) segue.destinationViewController).view;
    destView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    destView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:destView];
    //[segue.destinationViewController didMoveToParentViewController:self];
}

- (void) setDefaultSegue: (NSString*) lastSegue {
    NSUserDefaults* sud = [NSUserDefaults standardUserDefaults];
    [sud setObject:lastSegue forKey:@"lastSegue"];
    [sud synchronize];
}

- (NSString*) getDefaultSegue {
    NSUserDefaults* sud = [NSUserDefaults standardUserDefaults];
    return [sud stringForKey:@"lastSegue"];
}

@end
