//
//  AdInlineViewController.h
//  sample
//
//  Created by Vladas Drejeris on 04/05/15.
//  Copyright (c) 2015 Adform. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AdformAdvertising/AdformAdvertising.h>

@interface AdInlineViewController : UIViewController

@property (nonatomic, weak) IBOutlet UITextView *textView;
@property (nonatomic, strong) AFAdInline *adInline;

@end
