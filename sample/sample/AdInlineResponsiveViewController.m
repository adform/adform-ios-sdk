//
//  AdInlineResponsiveViewController.m
//  sample
//
//  Created by Vladas Drejeris on 04/05/15.
//  Copyright (c) 2015 Adform. All rights reserved.
//

#import "AdInlineResponsiveViewController.h"
#import <AdformAdvertising/AdformAdvertising.h>

@interface AdInlineResponsiveViewController () <AFAdInlineDelegate>

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UILabel *bottomLabel;
@property (nonatomic, weak) IBOutlet UILabel *topLabel;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *verticalSpacing;

@end

@implementation AdInlineResponsiveViewController

- (void)viewDidLoad {
    
    // Ad will be loaded in superclass.
    [super viewDidLoad];
    
    // We also need to update constraints to match labels width to screen size.
    [self updateConstraints];
    
    //Setup ad delegate.
    self.adInline.delegate = self;
    
    // Move ad inline to scrollview.
    [self.scrollView addSubview:self.adInline];
    
    // Set adInline view constraints.
    [self setAdInlineConstraints];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger )masterTag {
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return 4022668;
    } else {
        return 4030444;
    }
}

- (void)updateConstraints {
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.topLabel
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationLessThanOrEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeWidth
                                                         multiplier:1.0
                                                           constant:-16]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.bottomLabel
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationLessThanOrEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeWidth
                                                         multiplier:1.0
                                                           constant:-16]];
}

- (void)setAdInlineConstraints {
    
    self.adInline.translatesAutoresizingMaskIntoConstraints = NO;
    [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:self.adInline
                                                                attribute:NSLayoutAttributeTop
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self.topLabel
                                                                attribute:NSLayoutAttributeBottom
                                                               multiplier:1.0
                                                                 constant:-8]];
    [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:self.adInline
                                                                attribute:NSLayoutAttributeCenterX
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self.scrollView
                                                                attribute:NSLayoutAttributeCenterX
                                                               multiplier:1.0
                                                                 constant:0]];
}

#pragma mark - AFAdInlineDelegate

- (void)adInlineWillShow:(AFAdInline *)adInline {
    
    // When ad is being displayed we should update label constraints to push it down and make place for the ad.
    // This transition is animated.
    [UIView animateWithDuration:kAdViewAnimationDuration
                     animations:^{
                         [self.verticalSpacing setConstant:(self.verticalSpacing.constant + adInline.adSize.height)];
                         [self.scrollView layoutIfNeeded];
                     }];
}

- (void)adInlineWillHide:(AFAdInline *)adInline {
    
    // When ad is being hidden we should update label constraints and put it back to its initial place.
    // This transition is animated.
    [UIView animateWithDuration:kAdViewAnimationDuration
                     animations:^{
                         [self.verticalSpacing setConstant:(self.verticalSpacing.constant - adInline.adSize.height)];
                         [self.scrollView layoutIfNeeded];
                     }];
}

@end
