//
//  LocalizationViewController.h
//  ControllerTest
//
//  Created by Ruben Quintero on 11/30/15.
//  Copyright © 2015 Ruben Quintero. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LocalizationViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIButton *buttonLabel;
- (IBAction)changeLanguage:(id)sender;

@end
