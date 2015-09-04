//
//  LocationViewController.m
//  ControllerTest
//
//  Created by Ruben Quintero on 8/27/15.
//  Copyright (c) 2015 Ruben Quintero. All rights reserved.
//

#import "LocationViewController.h"
#import "LocationHandler.h"

@implementation LocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[LocationHandler getSharedInstance] setDelegate:self];
    [[LocationHandler getSharedInstance] startUpdating];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didFailWithError:(NSError *)error {
    NSLog(@"Ocurrió un error: %@", error.localizedDescription);
}

- (void)didUpdateLocations:(CLLocation *)location {
    [_latitudeLabel setText:[NSString stringWithFormat:@"Latitude: %f", location.coordinate.latitude]];
    [_longitudeLabel setText:[NSString stringWithFormat:@"Longitude: %f", location.coordinate.longitude]];
    [_precisionLabel setText:[NSString stringWithFormat:@"Accuracy: %.1f m", location.horizontalAccuracy]];
    
    [[LocationHandler getSharedInstance] getAddressFromCLLocation:location];
}

- (void)didRecieveAddress:(NSString *)address {
    [_addressLabel setText:address];
}

@end
