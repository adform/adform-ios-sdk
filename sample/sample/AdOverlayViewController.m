//
//  AdOverlayViewController.m
//  sample
//
//  Created by Vladas Drejeris on 04/05/15.
//  Copyright (c) 2015 Adform. All rights reserved.
//

#import "AdOverlayViewController.h"

NSInteger const kMasterTag = 142636;

@interface AdOverlayViewController ()

@end

@implementation AdOverlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Initialize AFAdOverlay object with master tag.
    self.adOverlay = [[AFAdOverlay alloc] initWithMasterTagID:kMasterTag];
    
    // Display the ad at least 2 seconds after pushing the view controller.
    [self.adOverlay showFromViewController:self];
}

@end
