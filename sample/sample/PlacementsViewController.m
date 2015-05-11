//
//  PlacementsViewController.m
//  sample
//
//  Created by Vladas Drejeris on 04/05/15.
//  Copyright (c) 2015 Adform. All rights reserved.
//

#import "PlacementsViewController.h"
#import "AdhesionViewController.h"

@interface PlacementsViewController ()

@end

@implementation PlacementsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([segue.identifier isEqualToString:@"AdhesionTop"]) {
        [(AdhesionViewController *)segue.destinationViewController setAdPosition:AFAdPositionTop];
    } else if ([segue.identifier isEqualToString:@"AdhesionBottom"]) {
        [(AdhesionViewController *)segue.destinationViewController setAdPosition:AFAdPositionBottom];
    }
}

@end
