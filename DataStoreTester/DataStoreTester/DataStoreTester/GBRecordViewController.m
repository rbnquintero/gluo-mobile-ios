//
//  GBFirstViewController.m
//  DataStoreTester
//
//  Copyright (c) 2014 Golden Bits Software. All rights reserved.
//

#include <sys/time.h>

#import "GB_RecordTestConfig.h"
#import "GB_CarDataProtocol.h"
#import "GB_CarsCoreData.h"
#import "GB_CarsSQLite.h"
#import "GB_CarRecordTableView.h"
#import "GBRecordViewController.h"
#import "GB_CarDetailedViewController.h"
#import "Manufacturer.h"
#import "Car.h"
#import "GB_CarInfo.h"

#define CAR_LABEL_TAG       1
#define CACHED_LABEL_TAG    2

@interface GBRecordViewController ()

@end

@implementation GBRecordViewController {
    
    // our generic store interface, can be pointer to
    // core data or SQLite.
    id<GB_CarDataProtocol> _carStore;
    
    NSArray *_carFetchResults;
    
    int _numCarRecs;
}

static NSString *recordCellcacheid = @"RecordCellCacheId";

@synthesize car_recs_tableview;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 480, 44)];
    label.backgroundColor = [UIColor clearColor];
    label.numberOfLines = 2;
    label.font = [UIFont boldSystemFontOfSize: 14.0f];
    //label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    label.text = @"Car Records";
    
    self.navigationItem.titleView = label;

    // Do any additional setup after loading the view, typically from a nib.
    _numCarRecs = 0;
    
    // set the delegates for the tableview to this controller
    car_recs_tableview.delegate = self;
    car_recs_tableview.dataSource = self;
    
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) initCarstore {
    
    if(GB_RecordTestConfig.useCoreData) {
        _carStore = [GB_CarsCoreData sharedManager];
    } else {
        _carStore = [GB_CarsSQLite sharedManager];
    }
    
    // Close and re-open the store.  This insures that we are
    // starting fresh when fetching records.  By fresh I mean anything
    // that might be cached in flushed.
    [_carStore closeStore];
    [_carStore createOpenStore];

    // always re-fetch records, this handles the case where
    // the user switched between CoreData and SQLite or created
    // a new set of records
    [self fetchCarRecords];
}



- (void)viewWillAppear:(BOOL)animated {
    
    [ super viewWillAppear:animated];
    
    
    if(GB_RecordTestConfig.refetchCarRecs) {
        
        [self initCarstore];
    
        [car_recs_tableview reloadData];
        
        [GB_RecordTestConfig setrefetchCarRecs:false];
    }

}




- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // return count of number of car recs fetched
    return _numCarRecs;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // get a cell from our queue
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:recordCellcacheid];
    
    
    // no free cell, let's create one
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:recordCellcacheid];
        
        // Set disclosure mark/arrow on cell
        cell.accessoryType  = UITableViewCellAccessoryDisclosureIndicator;
    }

    
     // access element in array, but first check array bounds
     
     if( indexPath.row >= _carFetchResults.count) {
        // our of range, return nil
        // TODO: Is this the proper return for this delegate?
     }
    
    NSObject *carResultObj = _carFetchResults[indexPath.row];
    NSString *carModelName;
    bool isCached = false;
     
    // pull out field from Car object
    if ( [carResultObj isKindOfClass:[Car class]] ) {
     
        // get car field
        Car *car = (Car*)carResultObj;
        
        isCached = [car isFault] == NO ? true : false;
        
        carModelName = car.model;
    
     } else {
     
         // GB_CarInfo
         GB_CarInfo *gb_car = (GB_CarInfo*)carResultObj;
         
         carModelName = gb_car.modelName;

         isCached = gb_car.manufacturerName != nil ? true : false;
     }
    
    // Is this cached?  If so, then add the text (cached) next
    // to the car name
    if (isCached) {
        
        NSString *modelNameWithSpace = [NSString stringWithFormat:@"%@ ", carModelName];
        
        NSMutableAttributedString *carModelText = [[NSMutableAttributedString alloc]
                                                         initWithString:modelNameWithSpace];
        
        [carModelText addAttribute:NSForegroundColorAttributeName
                             value:[UIColor blackColor] range:NSMakeRange(0, carModelText.length)];
        
        
        // create "(cached" string using different color and font
        NSMutableAttributedString *cachedText = [[NSMutableAttributedString alloc]
                                                   initWithString:@"(cached)"];
        
        [cachedText addAttribute:NSForegroundColorAttributeName
                             value:[UIColor greenColor] range:NSMakeRange(0, cachedText.length)];
        
        UIFont *smallFont = [UIFont systemFontOfSize:12.0];
        
        [cachedText addAttribute:NSFontAttributeName
                           value:smallFont range:NSMakeRange(0, cachedText.length)];
        
        
        [carModelText appendAttributedString:cachedText];
        
        cell.textLabel.text = nil;
        cell.textLabel.attributedText = carModelText;

        
        
    } else {
        cell.textLabel.text = carModelName;
    }

    
    return cell;
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"showDetail" sender:self];
    
    // force reload of cell
    NSArray *cells = [NSArray arrayWithObjects:indexPath, nil];
    [tableView reloadRowsAtIndexPaths:cells withRowAnimation:UITableViewRowAnimationNone];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        
        NSIndexPath *indexPath = [car_recs_tableview indexPathForSelectedRow];
        
        // NOTE: If we're using fetchedResultsController.
        //NSManagedObject *object = [[self fetchedResultsController] objectAtIndexPath:indexPath];
        
        NSObject *oneCarResult = _carFetchResults[indexPath.row];
        
        // If ths is SQLite, then fetch car info
        // This isn't necessary if we're using CoreData because the class
        // already contains the data or if not, it will be faulted in
        // automatically.
        
        if ( [oneCarResult isKindOfClass:[GB_CarInfo class]] ) {
        
            // cast to GB_CarInfo
            GB_CarInfo *gbCar = (GB_CarInfo*)oneCarResult;
            
            // Check if this infomation has been previoulsy fetched.
            // if not then fetch from DB.
            if ( gbCar.manufacturerName == nil ) {
                
                NSInteger fetchMs;
                [_carStore fetchCarDetails:gbCar timeMs:&fetchMs];
                gbCar.fetchTimeMs = fetchMs;
            } else {
                
                // this rec has already been fetched, so set fetch time to zero
                gbCar.fetchTimeMs = 0;
            }
        }
        
        // set object to detailed view
        [[segue destinationViewController] setDetailItem:oneCarResult];
    }
}


- (bool) fetchCarRecords {

    
    if( _carStore == nil)
        return false;
    
    _numCarRecs = 0;

    
    // let ARC do it's thing
    _carFetchResults = nil;
    
    // To keep ARC happy, we need to return the pointer into a temp
    // var.  This helps ARC know who is using the returned pointer to
    // the NSArray.
    NSArray *tempArray = nil;
    
    NSInteger fetchMs;
    
    // set number of records fetched
    //_carFetchResults = [_carStore fetchCars:&_numCarRecs];
    _numCarRecs = [_carStore fetchCars:&tempArray timeMs:&fetchMs];
    
    _carFetchResults = tempArray;
    
    
    // set fetch time in MSec and number of records fetched
    //self.navigationItem.
    UILabel *title = (UILabel *)self.navigationItem.titleView;
    NSString *storeType = GB_RecordTestConfig.useCoreData ? @"CoreData" : @"Sqlite";
    
    title.text = [NSString stringWithFormat:@"%d Car Records\nTook %ld msecs (%@)",
                                          _numCarRecs, (long)fetchMs, storeType];
    
    return false;
}


@end
