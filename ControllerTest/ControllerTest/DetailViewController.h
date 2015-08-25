//
//  DetailViewController.h
//  ControllerTest
//
//  Created by Ruben Quintero on 8/21/15.
//  Copyright (c) 2015 Ruben Quintero. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TestItem.h"

@interface DetailViewController : UIViewController

@property TestItem* testItem;
@property (weak, nonatomic) IBOutlet UIView *mainContainer;

@end
