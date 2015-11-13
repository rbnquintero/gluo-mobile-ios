//
//  GB_CarDetailedViewController.m
//  DataStoreTester
//
//  Copyright (c) 2014 Golden Bits Software. All rights reserved.
//

#import "GB_CarDetailedViewController.h"
#import <CoreData/CoreData.h>
#import "GB_CarsCoreData.h"
#import "Car.h"
#import "Manufacturer.h"
#import "CarType.h"
#import "CarDetails.h"
#import "GB_CarInfo.h"
#import "GB_DiagUtil.h"



@interface GB_CarDetailedViewController ()

@end




@implementation GB_CarDetailedViewController {
    
      NSString *_cardetail;
}

@synthesize carDetailInfo;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {

    }
    

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    carDetailInfo.text = _cardetail;
    
    // set the text font, NOTE, need to set the font AFTER
    // the text has beens et.
    [carDetailInfo setFont:[UIFont systemFontOfSize:18]];
}


     

- (void) setDetailItem:(NSObject*)carDetail {
    
    // pull out field from Car object
    if ( [carDetail isKindOfClass:[Car class]] ) {
        
        // get car field
        Car *carCore = (Car*)carDetail;
        
        [self displayCoreDataCar:carCore];
        
    } else {
        
        GB_CarInfo *carSql = (GB_CarInfo*)carDetail;
        
        // display car data
        [self displaySQLiteCar:carSql];
    }
}



// Format of car detail display
// Simple detail form
// model - year
// Price: MSRP
// Type:
// Details:
//   xxx
//   xxx
//   xxx
// Manufacturer - xxx
//   HQ Location: xxx.
//   Employees:

- (void) displayCoreDataCar:(Car*)car {
    
    CarType *type = car.cartype;
    Manufacturer *mfg = car.manufacturer;
    
    NSMutableString *detailInfo = [[NSMutableString alloc] init];
    
    // For CoreData, the fetch time for an indivudal record is really
    // how long the object's member vars and contained objects take to
    // access.  CoreData will fault in those objects that are not in
    // memory.
    NSInteger start = [GB_DiagUtil getCurrentMillsecs];
    
    [detailInfo appendFormat:@"Model Name: %@\nYear: %@\n",  car.model, car.year];
    [detailInfo appendFormat:@"Price: %@\n", car.msrp];
    
    // append car type info
    [detailInfo appendFormat:@"Type: %@\nDesc: %@\nDetails:\n", type.type, type.type_desc ];
    
    // details:
    for(CarDetails *detailEntry in car.cardetails) {
        [detailInfo appendFormat:@"    %@ - %@, %@\n", detailEntry.detailgroup,
         detailEntry.info_1, detailEntry.info_2 ];
    }
    
    [detailInfo appendFormat:@"Manufacturer:\n    Name: %@\n    HQ Location: %@\n    Employees: %@\n\n",
                 mfg.name, mfg.hq_location, mfg.num_employees];
    
    NSInteger elapseTime = [GB_DiagUtil getCurrentMillsecs] - start;
    
    
    NSString *fetchTime = [NSString stringWithFormat:@"\n==>Fetch time %ld msec\n\n", (long)elapseTime];
    
    [detailInfo insertString:fetchTime atIndex:0];
    
    _cardetail = (NSString*)detailInfo;
}


- (void) displaySQLiteCar:(GB_CarInfo*)car {
    
    NSMutableString *detailInfo = [[NSMutableString alloc] init];
    
    [detailInfo appendFormat:@"Model Name: %@\nYear: %d\n", car.modelName, (int)car.year];
    
    [detailInfo appendFormat:@"Price: %d\n", (int)car.price];
    
    
    // append car type info
    [detailInfo appendFormat:@"Type: %@\nDesc: %@\nDetails:\n", car.typeName, car.typeDesc];
    
    // details:
    NSString *detailGrp, *detail_1, *detail_2;
    
    detailGrp = car.detailDict[DETAIL_GROUP_KEY];
    detail_1  = car.detailDict[INFO_1_KEY];
    detail_2  = car.detailDict[INFO_2_KEY];
    
    [detailInfo appendFormat:@"    %@ - %@, %@\n", detailGrp,
                 detail_1, detail_2];


    [detailInfo appendFormat:@"Manufacturer:\n    Name: %@\n    HQ Location: %@\n    Employees: %d\n",
             car.manufacturerName, car.manufacturerHQloc, (int)car.numEmployees];
    
    NSString *fetchTime = [NSString stringWithFormat:@"\n==>Fetch time %ld msec\n\n", (long)car.fetchTimeMs];
    
    [detailInfo insertString:fetchTime atIndex:0];

    
    _cardetail = (NSString*)detailInfo;
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
