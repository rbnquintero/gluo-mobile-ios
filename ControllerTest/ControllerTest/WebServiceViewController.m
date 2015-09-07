//
//  WebServiceViewController.m
//  ControllerTest
//
//  Created by Ruben Quintero on 9/7/15.
//  Copyright (c) 2015 Ruben Quintero. All rights reserved.
//

#import "WebServiceViewController.h"
#import "TemperatureService.h"

@interface WebServiceViewController ()

@end

@implementation WebServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[TemperatureService getSharedInstance] setDelegate:self];
    //[[TemperatureService getSharedInstance] celsiusToFahrenheit:@"30"];
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

-(void) returnFahrenheit:(NSString *)fahrenheit {
    NSLog(@"Returned %@ fahrenheit", fahrenheit);
    self.resultLabel.text = fahrenheit;
}

-(void) returnCelsius:(NSString *)celsius {
    NSLog(@"Returned %@ celsius", celsius);
    self.resultLabel.text = celsius;
}

- (IBAction)convertirGrados:(id)sender {
    NSLog(@"Clicked");
    NSString *fahrenheit = self.fahrenheitField.text;
    [[TemperatureService getSharedInstance] fahrenheitToCelsius:fahrenheit];
}
@end
