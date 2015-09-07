//
//  WebServiceViewController.h
//  ControllerTest
//
//  Created by Ruben Quintero on 9/7/15.
//  Copyright (c) 2015 Ruben Quintero. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TemperatureService.h"

@interface WebServiceViewController : UIViewController<TemperatureServiceDelegate>
@property (weak, nonatomic) IBOutlet UITextField *fahrenheitField;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
- (IBAction)convertirGrados:(id)sender;

@end
