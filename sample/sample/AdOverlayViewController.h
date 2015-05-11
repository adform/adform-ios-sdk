//
//  AdOverlayViewController.h
//  sample
//
//  Created by Vladas Drejeris on 04/05/15.
//  Copyright (c) 2015 Adform. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AdformAdvertising/AdformAdvertising.h>

extern const NSInteger kMasterTag;

@interface AdOverlayViewController : UIViewController

// AFAdOverlay placement requires strong reference to it, otherwise the object will be released by arc before loading and displaying the ad.
@property (nonatomic, strong) AFAdOverlay *adOverlay;

@end
