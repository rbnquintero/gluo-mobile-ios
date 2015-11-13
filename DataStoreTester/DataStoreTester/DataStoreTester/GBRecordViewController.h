//
//  GBFirstViewController.h
//  DataStoreTester
//
//  Copyright (c) 2014 Golden Bits Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GB_CarRecordTableView;

@interface GBRecordViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet GB_CarRecordTableView *car_recs_tableview;

@end
