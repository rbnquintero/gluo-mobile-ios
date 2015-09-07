//
//  TemperatureService.h
//  ControllerTest
//
//  Created by Ruben Quintero on 9/7/15.
//  Copyright (c) 2015 Ruben Quintero. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TempConvertProxy.h"
@protocol TemperatureServiceDelegate <NSObject>
@required
- (void) returnCelsius: (NSString*) celsius;
- (void) returnFahrenheit: (NSString*) fahrenheit;
@end

@interface TemperatureService : NSObject<Wsdl2CodeProxyDelegate> {
    TempConvertProxy *tempConvertService;
}
@property(nonatomic,strong) id<TemperatureServiceDelegate> delegate;

+(id) getSharedInstance;
- (void) celsiusToFahrenheit: (NSString*) celsius;
- (void) fahrenheitToCelsius: (NSString*) fahrenheit;

@end