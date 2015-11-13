//
//  CoreDataViewController.h
//  ControllerTest
//
//  Created by Ruben Quintero on 9/23/15.
//  Copyright © 2015 Ruben Quintero. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataService.h"

@interface CoreDataViewController : UIViewController<CoreDataServiceDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nombreField;
@property (weak, nonatomic) IBOutlet UITextField *apellidoField;
@property (weak, nonatomic) IBOutlet UILabel *noRegistrosLabel;

- (IBAction)crearRegistro:(id)sender;

@end
