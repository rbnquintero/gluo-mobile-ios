//
//  GBSecondViewController.m
//  DataStoreTester
//
//  Copyright (c) 2014 Golden Bits Software. All rights reserved.
//

#import "GBDataStoreTableSelecion.h"
#import "GB_RecordTestConfig.h"
#import "GBRecordCreateViewController.h"
#import "GBRecordViewController.h"
#import "GB_StepperCtl.h"
#import "GB_CarsCoreData.h"
#import "GB_CarsSQLite.h"
#import "GB_DiagUtil.h"

// the tag is set in the story board
#define FETCH_CAR_RECTAG    100

@interface GBRecordCreateViewController ()

@end

@implementation GBRecordCreateViewController {

    // private vars
    bool _creatingRecs;
    bool _createComplete;
    bool _cancel;
    int _numRecsToCreate;
    
    GB_StepperCtl *_numberSpinnerView;
    
    NSTimer *_memUsageTimer;
    NSInteger _createStartTime;
    NSInteger _storeSizeKBytes;
    
}


- (IBAction)createrecs_but_touchup:(id)sender {
    
    [self dismissKeyboard];
    
    if (![self checkCreateNumber])
        return;
    
    // clear all of our stores
    [self clearAllStores];
    
    _creatingRecs = true;
    _cancel = false;
    [self enableCtrls];
    
    // get the number of records to create;
    _numRecsToCreate = _numberSpinnerView.numValue;
    
    _createComplete = false;
    
    // setup progress bar for the number of recs to create
    [_recordprogress setProgress:(float)0.0 animated:(BOOL)FALSE];
    
    // start thread to create recs
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,
                                             (unsigned long)NULL), ^(void) {
        [self createDataStoreRecsThread];
    });
    
    // get the start time
    _createStartTime = [GB_DiagUtil getCurrentMillsecs];
    
    // blank out creation time info
    _recordCreateTime.text = @"";
    _dataStoreSize.text = @"";
}

- (bool)checkCreateNumber {
    
    if(_numberSpinnerView.numValue == 0) {
    
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Record count is zero"
                                                    message:@"You must enter the number of records to create."
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
        [alert show];
        
        return false;
    }
    
    return true;
}


- (IBAction)cancel_but_touchedup:(id)sender {
    
    // send cancel notification to running thread
    _creatingRecs = false;
    _cancel = true;
    
}


- (IBAction)clear_data_but_touchup:(id)sender {
    
    // when called, clear and delete all of the databases
    // for SQLite and CoreData.
    [self clearAllStores];
}


- (void)clearAllStores {
    
    GB_CarsCoreData *coredataStore = [GB_CarsCoreData sharedManager];
    [coredataStore deleteStore];

    GB_CarsSQLite *sqliteStore = [GB_CarsSQLite sharedManager];
    [sqliteStore deleteStore];
    
    _dataStoreSize.text = @"";
    _recordCreateTime.text = @"";
    
    [GB_RecordTestConfig setrefetchCarRecs:true];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view, typically from a nib.
    [self setBackgrouned];
    
    _creatingRecs = false;
    [self enableCtrls];
    
    //  load our stepper from Mumberctl.xib
    NSArray *subviewArray = [[NSBundle mainBundle] loadNibNamed:@"Numberctl" owner:self options:nil];
    
    _numberSpinnerView = [subviewArray objectAtIndex:0];
    [self.view addSubview:_numberSpinnerView];
    
    [_numberSpinnerView initcontrol];
    [_numberSpinnerView setInitialValue:GB_RecordTestConfig.numRecs];
    
    // move number spinner to location marked by placeholder
    CGRect numSpinnerLoc = _numentry_placeholder.frame;
    _numentry_placeholder.hidden = TRUE;
    
    _numberSpinnerView.frame = numSpinnerLoc;
    
    
    // set the progress bar to 0
    [_recordprogress setProgress:(float)0.0 animated:(BOOL)TRUE];
    
    // update our memory usage
    [self updateSystemInfo];
    
    // blank out creation time info
    _recordCreateTime.text = @"";
    _dataStoreSize.text = @"";
    
    [GB_RecordTestConfig setrefetchCarRecs:true];
    
    // Init and start our timer, every second we'll report the memory
    // usage of the app
    _memUsageTimer = [NSTimer scheduledTimerWithTimeInterval: 1.0
                                                  target: self
                                                selector:@selector(onTimerTic:)
                                                userInfo: nil repeats:YES];
    
    // set our tab bar delegate
    self.tabBarController.delegate = self;
}



- (void)viewDidUnload {
    
    // stop our timer
    [_memUsageTimer invalidate];
    _memUsageTimer = nil;

}

- (void)enableCtrls {
    
    _recordprogress.hidden = !_creatingRecs;
    _recordprogress.userInteractionEnabled = _creatingRecs ? YES : NO;
    
    _create_testrecs.hidden = _creatingRecs;
    
    _create_recsLabel.hidden = !_creatingRecs;
    _create_recsLabel.userInteractionEnabled = _creatingRecs ? NO : YES;
    
    _cancel_recs.hidden = !_creatingRecs;
    _cancel_recs.userInteractionEnabled = _creatingRecs ? YES : NO;
    
    _clear_data_button.hidden = _creatingRecs;
    
}


- (void)createDataStoreRecsThread {

    float progress;
    id<GB_CarDataProtocol> carStore;
    int progressCnt, insertCnt;
    
    // disable the tab bar while we're creating records.
    self.tabBarController.tabBar.userInteractionEnabled = NO;
    
    _createComplete = false;
    _storeSizeKBytes = 0;
    
    
    if(GB_RecordTestConfig.useCoreData) {
        
        carStore = [GB_CarsCoreData sharedManager];
        
        // depending if we're using Core Data or SQLite,
        // we'll need to modify the progress and insert counts;
        progressCnt = 2000;
        insertCnt = 50000;
        
    } else {
        
        carStore = [GB_CarsSQLite sharedManager];
        
        // For SQLite, we can only insert a max number of
        // values at one time. There's limit to what SQLite can handle
        progressCnt = 1000;
        insertCnt = 100;
    }
   
    // delete any previous store, start from scratch
    [carStore deleteStore];
    
    // let's create our store
    [carStore createOpenStore];
    
    for(int cnt = 0; cnt < _numRecsToCreate; cnt++) {
    
        if(_cancel)
            break;
        
        // create our car
        if ( ![carStore createOneCar:cnt] ) {
            NSLog(@"Failed to create car using CoreData");
            break;
        }

        // update progress bar
        if( cnt % progressCnt == 0) {
            progress = (float)cnt / (float)_numRecsToCreate;
            
            // update UI
            [self updateRecProgress:(float)progress];
        }
        
        // save every so often
        if(cnt % insertCnt == 0) {
            // save everything...
            [carStore saveStore];
        }
    }
    
    // update UI, 100% we're done
    [self updateRecProgress:(float)100.0];
    
    if (!_cancel) {
        // save everything...
        [carStore saveStore];
    }
    
    // close the store and flush records to the persitent store
    [carStore closeStore];
    
    // if we canceled, then delete store
    if(_cancel) {
        [carStore deleteStore];
    }
    
    
    // before we free resources, get the store size
    _storeSizeKBytes = [carStore getDataStoreSizeKBytes];

    dispatch_sync(dispatch_get_main_queue(), ^{
        [self recordCreateComplete];
    });
}


- (void)updateRecProgress:(float)progress
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [_recordprogress setProgress:(float)progress animated:(BOOL)TRUE];
    });
}



-(void)recordCreateComplete {
    
    _creatingRecs = false;
    _createComplete = true;
    
    // set progress bar to 0
    [_recordprogress setProgress:(float)0.0 animated:(BOOL)FALSE];
    
    [self enableCtrls];
    
    NSInteger createElapse = [GB_DiagUtil getCurrentMillsecs] -  _createStartTime ;
    
    NSString *createTimeInfo;
    NSString *storeSizeMsg = @"";
    
    if(!_cancel) {
        createTimeInfo = [NSString stringWithFormat:
                                @"Create Time: %ld Msecs.",
                                (long)createElapse ];
        
        storeSizeMsg = [NSString stringWithFormat:@"Store size: %ld KBytes", (long)_storeSizeKBytes];
        
    } else {
        createTimeInfo = @"Creation cancelled";
    }
    
    _recordCreateTime.text = createTimeInfo;
    
    _dataStoreSize.text = storeSizeMsg;
    
    // enable the tab bar while we're creating records.
    self.tabBarController.tabBar.userInteractionEnabled = YES;
}


- (void)onTimerTic:(NSTimer *)timer {
    
      [self updateSystemInfo];
}

-(void) updateSystemInfo {
    
    NSInteger appMemoryUsage = [GB_DiagUtil getMemoryUsage];
    float cpuUsage = [GB_DiagUtil getCpuUsage];
    
    NSString *cpuUsageInfo = [NSString stringWithFormat: @"App CPU usage: %.0f%% ", cpuUsage];

    
    NSString *memUpdate = [NSString stringWithFormat:@"App mem used: %ld Mbytes",
                           (long)appMemoryUsage / 1048000];
    
    
    // set label
    _memoryUsage.text = memUpdate;
    
    // cpu usage
    _cpuUsage.text = cpuUsageInfo;
}


- (void)dismissKeyboard {
    
    for (UIView* view in self.view.subviews) {
		if ([view isKindOfClass:[GB_StepperCtl class]])
            [ (GB_StepperCtl*)view dismissKeyboard];
	}
}

- (void)touchesEnded: (NSSet *)touches withEvent: (UIEvent *)event {
    
    [self dismissKeyboard];
}


- (void)didReceiveMemoryWarning
{
    static bool displayAlert = true;
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    if (!displayAlert)
        return;
    
    // popup warning
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"MEMORY WARNING"
                                                    message:@"Received memory warning."
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    
    displayAlert = false;
}


- (id) getCurrentStoreInstance {
   
    id<GB_CarDataProtocol> curStore;
    
    if(GB_RecordTestConfig.useCoreData) {
    
        curStore = [GB_CarsCoreData sharedManager];
 
    } else {
    
        curStore = [GB_CarsSQLite sharedManager];
    }
    
    return curStore;
}

// our tab bar controller delegate
- (void) tabBarController:(UITabBarController *)tabBarController
                   didSelectViewController:(UIViewController *)viewController{
    
}

// called before the view controller for the tab is displayed
 -(BOOL)tabBarController:(UITabBarController *)tabBarController
                          shouldSelectViewController:(UIViewController *)viewController {
     
     // which tab is selected?
     UITabBarItem *selectedTab = tabBarController.tabBar.selectedItem;
  
     // is this the Fetch car tab?
     if(selectedTab.tag == FETCH_CAR_RECTAG) {
         [GB_RecordTestConfig setrefetchCarRecs:true];
     }
     
     
     return TRUE;
 }

- (void) setBackgrouned {

    CAGradientLayer *bgLayer = [self blueGradient];
    bgLayer.frame = self.view.bounds;
    [self.view.layer insertSublayer:bgLayer atIndex:0];
}


//Blue gradient background
- (CAGradientLayer*) blueGradient {
    
    //UIColor *colorOne = [UIColor colorWithRed:(120/255.0) green:(135/255.0) blue:(150/255.0) alpha:1.0];
    //UIColor *colorTwo = [UIColor colorWithRed:(57/255.0)  green:(79/255.0)  blue:(96/255.0)  alpha:1.0];
    
    
    UIColor *colorOne = [UIColor colorWithRed:( 0.85) green:(0.924) blue:(0.972) alpha:1.0];
    
    UIColor *colorTwo = [UIColor colorWithRed:( 0.141)  green:(0.6 )  blue:(1)  alpha:1.0];
    
    
    NSArray *colors = [NSArray arrayWithObjects:(id)colorOne.CGColor, colorTwo.CGColor, nil];
    NSNumber *stopOne = [NSNumber numberWithFloat:0.0];
    NSNumber *stopTwo = [NSNumber numberWithFloat:1.0];
    
    NSArray *locations = [NSArray arrayWithObjects:stopOne, stopTwo, nil];
    
    CAGradientLayer *headerLayer = [CAGradientLayer layer];
    headerLayer.colors = colors;
    headerLayer.locations = locations;
    
    return headerLayer;
}


// don't support rotation
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return NO;
}



@end
