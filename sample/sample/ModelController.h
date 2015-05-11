//
//  ModelController.h
//  sample
//
//  Created by Vladas Drejeris on 25/03/15.
//  Copyright (c) 2015 Adform. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DataViewController, AFPageAdView;

@interface ModelController : NSObject <UIPageViewControllerDataSource>

- (NSInteger )count;
- (DataViewController *)viewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard;
- (NSUInteger)indexOfViewController:(DataViewController *)viewController;

@end

