//
//  CoreDataViewController.m
//  ControllerTest
//
//  Created by Ruben Quintero on 9/23/15.
//  Copyright © 2015 Ruben Quintero. All rights reserved.
//

#import "CoreDataViewController.h"

@interface CoreDataViewController ()

@property CoreDataService* coreDataService;

@end

@implementation CoreDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.coreDataService = [[CoreDataService alloc] init];
    [self.coreDataService setDelegate:self];
    [self.coreDataService fetchAllPersons];
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
    
    [self.coreDataService saveNew:nombre :apellido];
}

- (void) showPersonas:(NSArray *) personas {
    if(personas.count > 0) {
        NSLog(@"Personas registradas: %lu", (unsigned long)personas.count);
    } else {
        NSLog(@"No hay personas registradas");
    }
}

@end
