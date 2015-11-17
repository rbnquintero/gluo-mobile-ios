//
//  TemperatureService.m
//  ControllerTest
//
//  Created by Ruben Quintero on 9/7/15.
//  Copyright (c) 2015 Ruben Quintero. All rights reserved.
//

#import "TemperatureService.h"
static TemperatureService *tempService = nil;

@interface TemperatureService ()

@end

@implementation TemperatureService

+ (id) getSharedInstance{
    if (!tempService) {
        tempService = [[self allocWithZone:NULL]init];
        [tempService initiate];
    }
    return tempService;
}

- (void) initiate {
    tempConvertService = [[TempConvertProxy alloc] initWithUrl:@"http://www.w3schools.com/webservices/tempconvert.asmx" AndDelegate:self];
}

- (void) celsiusToFahrenheit: (NSString*) celsius {
    [tempConvertService CelsiusToFahrenheit:celsius];
}

- (void) fahrenheitToCelsius: (NSString*) fahrenheit {
    [tempConvertService FahrenheitToCelsius:fahrenheit];
}

//Service stuff
- (void) proxydidFinishLoadingData:(id)data InMethod:(NSString *)method {
    NSLog(@"Service %@ Done!",method);
    if([method isEqualToString:@"CelsiusToFahrenheit"]){
        [self.delegate returnFahrenheit:data];
    } else if([method isEqualToString:@"FahrenheitToCelsius"]) {
        [self.delegate returnCelsius:data];
    } else {
        NSLog(@"Data: %@", data);
    }
}
- (void) proxyRecievedError:(NSException *)ex InMethod:(NSString *)method {
    NSLog(@"Exception in service %@",method);
}

@end
