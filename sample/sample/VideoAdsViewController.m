//
//  VideoAdsViewController.m
//  sample
//
//  Created by Vladas Drejeris on 15/07/15.
//  Copyright (c) 2015 adform. All rights reserved.
//

#import "VideoAdsViewController.h"
#import <AdformAdvertising/AdformAdvertising.h>

@interface VideoAdsViewController ()

@end

@implementation VideoAdsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Create a new banner.
    AFAdHesion *adHesion = [[AFAdHesion alloc] initWithMasterTagId:142494 position:AFAdPositionTop presentingViewController:self];
    
    // Define custom size of the banner.
    adHesion.adSize = CGSizeMake(320, 240);
    
    // To enable video fallback uncomment this line of code.
    // adHesion.videoSettings.fallbackMasterTagId = [self fallbackMasterTag];
    
    // Setup video settings.
    adHesion.videoSettings.closeButtonBehavior = AFVideoAdCloseButtonBehaviorAllways;
    adHesion.videoSettings.controlsStyle = AFVideoPlayerControlsStyleMinimal;
    
    // Add the ad view to view hierarchy.
    [self.view addSubview:adHesion];
    
    // Start loading.
    [adHesion loadAd];
}

- (NSInteger )fallbackMasterTag {
    return 142493;
}

@end
