//
//  GB_CarDetailedViewController.h
//  DataStoreTester
//
//  Copyright (c) 2014 Golden Bits Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GB_CarDetailedViewController : UIViewController


@property (weak, nonatomic) IBOutlet UITextView *carDetailInfo;

- (void) setDetailItem:(NSObject*)carDetail;

@end
