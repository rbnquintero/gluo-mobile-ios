//
//  DetailViewController.h
//  PruebasGluo
//
//  Created by Ruben Quintero on 8/20/15.
//  Copyright (c) 2015 Ruben Quintero. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end

