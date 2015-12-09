//
//  CoreDataViewController.m
//  ControllerTest
//
//  Created by Ruben Quintero on 9/23/15.
//  Copyright © 2015 Ruben Quintero. All rights reserved.
//

#import "CoreDataViewController.h"
#import "AAAEmployeeMO.h"

@interface CoreDataViewController ()

@property CoreDataService* coreDataService;
@property NSMutableArray *employeeList;
@property (nonatomic,strong) UILongPressGestureRecognizer *lpgr;

@end

@implementation CoreDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGestures:)];
    self.lpgr.minimumPressDuration = 1.0f;
    self.lpgr.allowableMovement = 100.0f;
    [self.tableView addGestureRecognizer:self.lpgr];
    
    // CoreDataService init
    self.coreDataService = [[CoreDataService alloc] init];
    [self.coreDataService setDelegate:self];
    [self.coreDataService fetchAllPersons];
    
    // NSUserDefaults (properties)
    NSUserDefaults* sud = [NSUserDefaults standardUserDefaults];
    
    [sud setObject:@"value" forKey:@"key"];
    [sud synchronize];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)crearRegistro:(id)sender {
    NSString *nombre = self.nombreField.text;
    NSString *apellido = self.apellidoField.text;
    
    if ([nombre length]>0 && [apellido length]>0) {
        [self.coreDataService saveNew:nombre :apellido];
        [self.coreDataService fetchAllPersons];
        [self.nombreField setText:@""];
        [self.apellidoField setText:@""];
    }
}

- (void) showPersonas:(NSArray *) personas {
    NSString* message = nil;
    if(personas.count > 0) {
        message = [NSString stringWithFormat:@"Personas registradas: %lu", (unsigned long)personas.count];
        [self.noRegistrosLabel setText:message];
        self.tableView.hidden = NO;
        self.employeeList = [[NSMutableArray alloc] initWithArray:personas];
        [self.tableView reloadData];
    } else {
        message = @"No hay personas registradas";
        [self.noRegistrosLabel setText:message];
        self.tableView.hidden = YES;
    }
    NSLog(@"%@",message);
}

// LONG PRESS ON TABLE VIEW CELL
- (void) handleLongPressGestures:(UILongPressGestureRecognizer *)sender {
    if ([sender isEqual:self.lpgr]) {
        if (sender.state == UIGestureRecognizerStateBegan) {
            NSLog(@"Long pressed");
        }
    }
}


// FOR EMPLOYEE TABLEVIEW
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.employeeList count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"employeeIdentifier" forIndexPath:indexPath];
    AAAEmployeeMO* employee = [self.employeeList objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", employee.firstName, employee.lastName];
    NSLog(@"Cell: %ld", (long)indexPath.row);
    return cell;
}

- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        AAAEmployeeMO *employee = [_employeeList objectAtIndex:indexPath.row];
        NSLog(@"Employee a eliminar: %@", [employee getName]);
        NSArray* updatedList = [self.coreDataService deleteOnePerson:employee];
        self.employeeList = [[NSMutableArray alloc] initWithArray:updatedList];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self.coreDataService fetchAllPersons];
    } else {
        NSLog(@"Unhandled editing style! %d", editingStyle);
    }
}

@end
