//
//  GB_Stepper.h
//  DataStoreTester
//
//  Copyright (c) 2014 Golden Bits Software All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GB_StepperCtl : UIView <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIStepper *stepper_ui_ctrl;
@property (weak, nonatomic) IBOutlet UITextField *stepper_number;

@property (nonatomic) int numValue;

- (void)setInitialValue:(int) val;
- (void)initcontrol;
- (void)dismissKeyboard;
- (void)spinnerTextFieldChanged:(NSNotification *)notification;

@end
