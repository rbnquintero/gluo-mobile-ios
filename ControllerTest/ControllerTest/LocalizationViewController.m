//
//  LocalizationViewController.m
//  ControllerTest
//
//  Created by Ruben Quintero on 11/30/15.
//  Copyright © 2015 Ruben Quintero. All rights reserved.
//

#import "LocalizationViewController.h"

@interface LocalizationViewController ()

@property NSString *locale;

@end

@implementation LocalizationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *langCode = @"es-MX";
    // langCode = @"en";
    self.locale = [NSString stringWithFormat:@"%@", langCode];
    [self changeScreenLanguage:langCode];
    
    // Testing stuff
    // NSUserDefaults (properties)
    NSUserDefaults* sud = [NSUserDefaults standardUserDefaults];
    
    NSLog(@"This is the value: %@", [sud stringForKey:@"key"]);
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

- (IBAction)changeLanguage:(id)sender {
    if([self.locale isEqualToString:@"es-MX"]) {
        self.locale = @"en";
    } else {
        self.locale = @"es-MX";
    }
    [self changeScreenLanguage:self.locale];
}

- (void)changeScreenLanguage:(NSString*) langCode {
    NSLog(@"Locale selected: %@", langCode);
    // Buscamos el bundle de localización que queremos
    NSString *path = [[NSBundle mainBundle] pathForResource:langCode ofType:@"lproj"];
    NSBundle* languageBundle = [NSBundle bundleWithPath:path];
    
    // obtenemos los strings y los asignamos a los botones
    [_buttonLabel setTitle:[languageBundle localizedStringForKey:@"tests.localization.button" value:@"" table:nil] forState:UIControlStateNormal];
    [_descriptionLabel setText:[languageBundle localizedStringForKey:@"tests.localization.description" value:@"" table:nil]];
    [_titleLabel setText:[languageBundle localizedStringForKey:@"tests.localization.title" value:@"" table:nil]];
}
@end
