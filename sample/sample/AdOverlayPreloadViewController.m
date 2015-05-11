//
//  AdOvrelayPreloadViewController.m
//  sample
//
//  Created by Vladas Drejeris on 04/05/15.
//  Copyright (c) 2015 Adform. All rights reserved.
//

#import "AdOverlayPreloadViewController.h"

@interface AdOverlayPreloadViewController () <AFAdOverlayDelegate>

@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *indicatorView;
@property (nonatomic, weak) IBOutlet UIButton *showButton;

@end

@implementation AdOverlayPreloadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.adOverlay.delegate = self;
    
    [self.indicatorView startAnimating];
    
    // Initiate overlay ad loading
    [self.adOverlay preloadAd];
}

- (IBAction)showAd:(id)sender {
    
    [self.adOverlay showFromViewController:self];
    
    self.showButton.hidden = YES;
}

#pragma mark - AFAdOverlayDelegate

- (void)adOverlayDidLoadAd:(AFAdOverlay *)adOverlay {
    
    [self.indicatorView stopAnimating];
    self.showButton.hidden = NO;
}

@end
