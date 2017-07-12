//
//  AdhesionViewController.m
//  sample
//
//  Created by Vladas Drejeris on 04/05/15.
//  Copyright (c) 2015 Adform. All rights reserved.
//

#import "AdhesionViewController.h"

@interface AdhesionViewController () <AFAdInlineDelegate>

@property (nonatomic, strong) AFAdHesion *adHesion;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *labelTopConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *labelBottomConstraint;

@end

@implementation AdhesionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Create and setu the ad view.
    self.adHesion = [[AFAdHesion alloc] initWithMasterTagId:[self masterTag] position:self.adPosition presentingViewController:self];
    
    if (self.adPosition == AFAdPositionTop) {
        self.adHesion.delegate = self;
    } else {
        self.adHesion.hidesOnSwipe = true;
    }

    // This line of code enables multiple ad size support.
    self.adHesion.additionalDimmensionsEnabled = true;
    
    // Add it to view hierarchy and initiate ad loading.
    [self.view addSubview:self.adHesion];
    [self.adHesion loadAd];
}

- (NSInteger )masterTag {
    
    return 142493;
}

- (void)updateViewConstraints {
    if (self.adHesion.position == AFAdPositionTop && (self.adHesion.state == AFAdStateInShowTransition || self.adHesion.state == AFAdStateVisible)) {
        self.labelTopConstraint.constant = self.adHesion.adSize.height;
    } else {
        self.labelTopConstraint.constant = 8;
    }
    
    [super updateViewConstraints];
}

#pragma mark - AFAdInlineDelegate

- (void)adInlineWillShow:(AFAdInline *)adInline {
    [self.view setNeedsUpdateConstraints];
    
    [UIView animateWithDuration:AFAdViewAnimationDuration
                     animations:^{
                         [self.view layoutIfNeeded];
                     }];
}

- (void)adInlineWillHide:(AFAdInline *)adInline {
    [self.view setNeedsUpdateConstraints];
    
    [UIView animateWithDuration:AFAdViewAnimationDuration
                     animations:^{
                         [self.view layoutIfNeeded];
                     }];
}

@end