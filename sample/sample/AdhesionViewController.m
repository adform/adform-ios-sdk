//
//  AdhesionViewController.m
//  sample
//
//  Created by Vladas Drejeris on 04/05/15.
//  Copyright (c) 2015 Adform. All rights reserved.
//

#import "AdhesionViewController.h"

@interface AdhesionViewController ()

@property (nonatomic, strong) AFAdHesion *adHesion;

@end

@implementation AdhesionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Create and setu the ad view.
    self.adHesion = [[AFAdHesion alloc] initWithMasterTagId:[self masterTag] position:self.adPosition presentingViewController:self];
    
    // This line of code enables multiple ad size support.
    self.adHesion.additionalDimmensionsEnabled = true;
    
    // Add it to view hierarchy and initiate ad loading.
    [self.view addSubview:self.adHesion];
    [self.adHesion loadAd];
}

- (NSInteger )masterTag {
    
    return 142493;
}

@end