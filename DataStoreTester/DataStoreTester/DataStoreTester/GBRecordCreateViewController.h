//
//  GBSecondViewController.h
//  DataStoreTester
//
//  Copyright (c) 2014 Golden Bits Software All rights reserved.
//

#import <UIKit/UIKit.h>

@class GBDataStoreTableSelecion;

@interface GBRecordCreateViewController : UIViewController <UITabBarControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *numentry_placeholder;

@property (weak, nonatomic) IBOutlet UIProgressView *recordprogress;
@property (weak, nonatomic) IBOutlet UIButton *create_testrecs;
@property (weak, nonatomic) IBOutlet UILabel *create_recsLabel;
@property (weak, nonatomic) IBOutlet GBDataStoreTableSelecion *datastore_selection;
@property (weak, nonatomic) IBOutlet UIButton *cancel_recs;
@property (weak, nonatomic) IBOutlet UIButton *clear_data_button;
@property (weak, nonatomic) IBOutlet UILabel *memoryUsage;
@property (weak, nonatomic) IBOutlet UILabel *recordCreateTime;
@property (weak, nonatomic) IBOutlet UILabel *dataStoreSize;
@property (weak, nonatomic) IBOutlet UILabel *cpuUsage;

- (void)onTimerTic:(NSTimer *)timer;

@end
