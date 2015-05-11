//
//  AdInlineViewController.m
//  sample
//
//  Created by Vladas Drejeris on 04/05/15.
//  Copyright (c) 2015 Adform. All rights reserved.
//

#import "AdInlineViewController.h"

@interface AdInlineViewController ()

@end

@implementation AdInlineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Create and setup ad inline view.
    self.adInline = [[AFAdInline alloc] initWithMasterTagId:[self masterTag] presentingViewController:self];
    self.adInline.debugMode = YES;
    
    // Set custom position for the ad.
    self.adInline.frame = CGRectMake((self.view.frame.size.width - self.adInline.adSize.width) / 2, 300, self.adInline.adSize.width, 0);
    
    // Add ad to view hierarchy and initiate loading.
    [self.view addSubview:self.adInline];
    [self.adInline loadAd];
}

- (NSInteger )masterTag {
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return 4016318;
    } else {
        return 4030568;
    }
}

@end
