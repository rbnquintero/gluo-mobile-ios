//
//  LocationViewController.h
//  ControllerTest
//
//  Created by Ruben Quintero on 8/27/15.
//  Copyright (c) 2015 Ruben Quintero. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocationHandler.h"

@interface LocationViewController : UIViewController<LocationHandlerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *latitudeLabel;
@property (weak, nonatomic) IBOutlet UILabel *longitudeLabel;
@property (weak, nonatomic) IBOutlet UILabel *precisionLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@end
