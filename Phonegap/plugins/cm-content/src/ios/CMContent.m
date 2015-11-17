#import "CMContent.h"

@implementation CMContent

- (void)getContenido:(CDVInvokedUrlCommand*)command
{
    NSString* callbackId = command.callbackId;
    NSString* title = [command argumentAtIndex:0];
    NSString* message = [command argumentAtIndex:1];
    NSString* button = [command argumentAtIndex:2];
    NSLog(@"String input: %@", title);
    
}
@end