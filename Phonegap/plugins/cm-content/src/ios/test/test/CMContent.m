#import "CMContent.h"
#import "TemperatureService.h"

@implementation CMContent

- (void)getContenido:(CDVInvokedUrlCommand*)command
{
    NSString* title = [command argumentAtIndex:0];
    NSLog(@"String input: %@", title);
    self.callbackId = command.callbackId;
    
    [[TemperatureService getSharedInstance] setDelegate:self];
    [[TemperatureService getSharedInstance] fahrenheitToCelsius:@"104"];
}

- (void)convertirGradosC:(CDVInvokedUrlCommand*)command
{
    self.callbackId = command.callbackId;
    
    NSString* grados = [command argumentAtIndex:0];
    NSLog(@"Grados centígrados a convertir: %@", grados);
    
    [[TemperatureService getSharedInstance] setDelegate:self];
    [[TemperatureService getSharedInstance] celsiusToFahrenheit:grados];
}

- (void)convertirGradosF:(CDVInvokedUrlCommand*)command
{
    self.callbackId = command.callbackId;
    
    NSString* grados = [command argumentAtIndex:0];
    NSLog(@"Grados fahrenheit a convertir: %@", grados);
    
    [[TemperatureService getSharedInstance] setDelegate:self];
    [[TemperatureService getSharedInstance] fahrenheitToCelsius:grados];
}

- (CDVInvokedUrlCommand*)getCDVObj: (NSArray*) args {
    NSLog(@"Converting array to CDVInvokedUrlCommand");
    CDVInvokedUrlCommand* a = [[CDVInvokedUrlCommand alloc] initWithArguments:args callbackId:nil className:nil methodName:nil];
    return a;
}

- (void) returnCelsius:(NSString *)celsius {
    NSLog(@"Returned %@ celsius", celsius);
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:celsius];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:self.callbackId];
}

- (void) returnFahrenheit:(NSString *)fahrenheit {
    NSLog(@"Returned %@ fahrenheit", fahrenheit);
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:fahrenheit];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:self.callbackId];
}

@end