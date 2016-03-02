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
    
    // This line of code enables multiple ad size support.
    self.adInline.additionalDimmensionsEnabled = true;
    
    // If you want to define the supported ad sizes uncomment this line of code too.
    // self.adInline.supportedDimmensions = @[AFAdDimension(320, 50), AFAdDimension(320, 100), AFAdDimension(320, 150)];
    
    // Set custom position for the ad.
    self.adInline.frame = CGRectMake((self.view.frame.size.width - self.adInline.adSize.width) / 2, 300, self.adInline.adSize.width, self.adInline.adSize.height);
    
    // Add ad to view hierarchy and initiate loading.
    [self.view addSubview:self.adInline];
    [self.adInline loadAd];
}

- (NSInteger )masterTag {
    
    return 142493;
}

@end
