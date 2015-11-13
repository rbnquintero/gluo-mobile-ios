//
//  GB_Stepper.m
//  DataStoreTester
//
//  Copyright (c) 2014 Golden Bits Software. All rights reserved.
//

#import "GB_StepperCtl.h"

// NOTE: Should make configuratble based on screen resolution
#define TOPBOT_BORDER       6
#define LEFTRIGHT_BORDER    6
#define CTRL_SEPERATION     5

@implementation GB_StepperCtl

- (IBAction)valuechanged:(id)sender {
    
    // set new value in text box
      _stepper_number.text = [NSString stringWithFormat:@"%.0lf",
                              _stepper_ui_ctrl.value];
    
}

- (IBAction)textNewNumber:(id)sender {
    
    // new number entered... validate
    // set spinner
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        NSLog(@"initialization");
    }
    
    [[NSNotificationCenter defaultCenter]  addObserver:self
                                              selector:@selector(spinnerTextFieldChanged:)
                                                  name:UITextFieldTextDidChangeNotification
                                                object:_stepper_number];
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    
    [[NSNotificationCenter defaultCenter]  addObserver:self
                                            selector:@selector(spinnerTextFieldChanged:)
                                            name:UITextFieldTextDidChangeNotification
                                            object:_stepper_number];
    return self;
}

- (void)initcontrol;
{
    _stepper_number.delegate = self;
}

- (void)dismissKeyboard {
    
    // is this a valid number?
    BOOL isValid = [self getNumberFromText:_stepper_number.text];
    
    if(!isValid) {
        // error with format of nubmer, highlight
        // text and don't dismiss keyboard
        _stepper_number.textColor = [UIColor redColor];

    }
    
    [_stepper_number resignFirstResponder];
}

- (void)spinnerTextFieldChanged:(NSNotification *)notification {
    
    if(notification.object) {
        
        UITextField *textField = (UITextField*)notification.object;
        
        BOOL isValid = [self getNumberFromText:[textField text]];
        
        if(isValid) {
            textField.textColor = [UIColor blackColor];
        } else {
            textField.textColor = [UIColor redColor];
        }
    }
}





- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

// It is important for you to hide keyboard

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // is this a valid number?
    BOOL isValid = [self getNumberFromText:textField.text];
    

    if(!isValid) {
        // error with format of nubmer, highlight
        // text and don't dismiss keyboard
        textField.textColor = [UIColor redColor];
        return NO;
    }
    
    
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)getNumberFromText:(NSString*)textStr {
    
    // check lengh, if zero then set spinner to zero
    if( [textStr length] == 0) {
        _stepper_ui_ctrl.value = 0;
        return TRUE;
    }
    
    // convert text to number
    NSNumberFormatter * formatter = [NSNumberFormatter new];
    
    //... build string
    NSNumber * num = [formatter numberFromString:textStr];
    BOOL isNumeric = (num != nil);
    
    if(isNumeric) {
        // set number info spinner control
        _stepper_ui_ctrl.value = [num intValue];
    }
    
    return isNumeric;
}


- (void)setInitialValue:(int) val
{
    _stepper_ui_ctrl.value = val;
    _stepper_number.text = [NSString stringWithFormat:@"%d", val];
}

- (int)numValue {
    return _stepper_ui_ctrl.value;
}


// move the text field and stepper around and resize to
// fit within the frame.
-(void)setMoveControls
{
    
    // get the control's frame
    CGRect frameRect = self.frame;
    
    // center vertically, leaving border width top and bottom
    CGFloat newHeight = frameRect.size.height - (2 * TOPBOT_BORDER);
    
    // center horizontally leaving boarder with on right left side
    CGFloat newWidth = frameRect.size.width - (2 * LEFTRIGHT_BORDER);
    
    //  number entry should be 80% of width
    CGFloat editBoxWidth = (newWidth * .65) - CTRL_SEPERATION;
    
    // now figure out origin
    CGRect editBoxFrame;
    
    // NOTE: You can't change the size of the stepper, just the postion
    CGRect stepperFrame = _stepper_ui_ctrl.frame;
    
    editBoxFrame.origin.x = LEFTRIGHT_BORDER;
    editBoxFrame.origin.y = TOPBOT_BORDER;
    editBoxFrame.size.height = newHeight;
    editBoxFrame.size.width = editBoxWidth;
    
    stepperFrame.origin.x = LEFTRIGHT_BORDER + editBoxWidth + CTRL_SEPERATION;
    
    // center horizontally
    stepperFrame.origin.y = (frameRect.size.height - stepperFrame.size.height) / 2;

 
    // set the frames of the sub controls
    _stepper_ui_ctrl.frame = stepperFrame;
    _stepper_number.frame = editBoxFrame;
    
}



// Resize the views and buttons when this is called
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // move the game view and buttons accordingly
    [self setMoveControls];
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
