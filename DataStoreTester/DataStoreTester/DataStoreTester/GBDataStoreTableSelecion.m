//
//  GBDataStoreTableSelecion.m
//  DataStoreTester
//
//  Copyright (c) 2014 Golden Bits Software. All rights reserved.
//

#import "GB_RecordTestConfig.h"
#import "GBDataStoreTableSelecion.h"

#define COREDATA_ROW        0
#define SQLITE_ROW          1



@implementation GBDataStoreTableSelecion


static NSString *cellcacheid = @"CellCacheId";

// NOT called since we're loaing from XIB/NIB/Storyboard.
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    
    
    return self;
}


- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        NSLog(@"DataTableStoreSelection init");
        
        // set the data source and delegate to this class
        self.dataSource = self;
        self.delegate = self;
    }
    
    return self;
}




- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    

    // get a cell from our queue
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellcacheid];
    

    // no free cell, let's create one
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:cellcacheid];
    }
    
    // remove checkmark
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    
    switch ( indexPath.row ) {
            
        case COREDATA_ROW:
            
            cell.textLabel.text = @"Core Data";
            
            // is this our current selection?
            if(GB_RecordTestConfig.useCoreData) {
                
                // set our checkmark to indicate cell is selected
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                
                // Tell the table view this row is selected.
                [tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:COREDATA_ROW
                        inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];

            }
            
            break;
            
            
        case SQLITE_ROW:
            
            cell.textLabel.text = @"SQLite";
            
            // is this our current selection?
            if(!GB_RecordTestConfig.useCoreData) {
                
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                [tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:SQLITE_ROW
                            inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];

            }
            
            break;
            
            
        default:
            
            NSLog(@"Invalid row");
            break;
    }

    
    return cell;
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // set the check mark for the newly selected row
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    bool useCoreData = (indexPath.row == COREDATA_ROW) ? true : false;
    
    [GB_RecordTestConfig setuseCoreData:useCoreData];
    
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
}


- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // set the check mark for the newly selected row
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    cell.accessoryType = UITableViewCellAccessoryNone;
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
