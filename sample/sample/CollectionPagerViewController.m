//
//  CollectionPagerViewController.m
//  sample
//
//  Created by Vladas Drejeris on 04/05/15.
//  Copyright (c) 2015 Adform. All rights reserved.
//

#import "CollectionPagerViewController.h"
#import <AdformAdvertising/AdformAdvertising.h>
#import "AFCollectionViewMediator.h"

static NSInteger const kMasterTag = 142636;

@interface CollectionPagerViewController () <UICollectionViewDelegateFlowLayout, AFCollectionViewMediatorDelegate>

@property (nonatomic, strong) NSArray *datasource;
@property (nonatomic, strong) AFCollectionViewMediator *mediator;

@end

@implementation CollectionPagerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Setup data source.
    [self setupDatasource];
    
    // Create ad mediator for collection view.
    self.mediator = [[AFCollectionViewMediator alloc] initWithMasterTagId:kMasterTag
                                                              adFrequency:3
                                                                debugMode:false
                                                           collectionView:self.collectionView
                                                 presentingViewController:self];
    self.mediator.delegate = self;
}

#pragma mark - AFCollectionViewMediatorDelegate

// Uncomment to show ads at specific pages.
//- (BOOL )collectionViewMediator:(AFCollectionViewMediator *)mediator shouldShowAdAtIndexPath:(NSIndexPath *)indexPath {
//
//    return (indexPath.row == 1) || (indexPath.row == 5);
//}

#pragma mark - Collection view

/**
 There can be any implementation of UICollectionView here.
 There is only one condition for it, collection view should 
 show only one cell (page) at a time, otherwise mediator may work 
 incorrectly.
 */

- (void)setupDatasource {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    _datasource = [[dateFormatter monthSymbols] copy];
}

- (NSInteger )numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

- (NSInteger )collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return _datasource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [self.mediator dequeueReusableCellWithReuseIdentifier:@"CellIdentifier" forIndexPath:indexPath];
    
    UILabel *label = (UILabel *)[cell.contentView viewWithTag:1];
    label.text = [[_datasource[indexPath.row] description] uppercaseString];
    
    return cell;
}

- (CGSize )collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(self.collectionView.frame.size.width, self.collectionView.frame.size.height);
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
    [self.collectionView performBatchUpdates:^{
        [self.collectionViewLayout invalidateLayout];
        [self.collectionView reloadData];
    }
                                  completion:^(BOOL finished) {
                                      [self.collectionView scrollToItemAtIndexPath:self.collectionView.indexPathsForVisibleItems.firstObject
                                                                  atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                                                                          animated:YES];
                                  }];
}

@end
