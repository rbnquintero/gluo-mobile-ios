#import <Cordova/CDV.h>
#import "TemperatureService.h"

@interface CMContent : CDVPlugin<TemperatureServiceDelegate>

@property (nonatomic, strong) NSString* callbackId;

- (void)getContenido:(CDVInvokedUrlCommand*)command;
- (void)convertirGradosC:(CDVInvokedUrlCommand*)command;
- (void)convertirGradosF:(CDVInvokedUrlCommand*)command;

- (CDVInvokedUrlCommand*)getCDVObj:(NSArray*) args;

@end