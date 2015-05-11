//
//  DataViewController.h
//  sample
//
//  Created by Vladas Drejeris on 25/03/15.
//  Copyright (c) 2015 Adform. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DataViewController : UIViewController

@property (nonatomic, assign) NSInteger previousIndex;
@property (strong, nonatomic) IBOutlet UILabel *dataLabel;
@property (strong, nonatomic) id dataObject;

@end

