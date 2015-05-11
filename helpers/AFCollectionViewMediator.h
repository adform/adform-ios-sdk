//
//  AFCollectionViewMediator.h
//  AdformAdvertising
//
//  Created by Vladas Drejeris on 31/03/15.
//  Copyright (c) 2015 Adform. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AdformAdvertising/AdformAdvertising.h>

@protocol AFCollectionViewMediatorDelegate;

/**
 A helper class used to present ads in 
 */
@interface AFCollectionViewMediator : NSObject

/**
 A reference to the collection view which is used to display ads.
 */
@property (nonatomic, strong) UICollectionView *collectionView;

/**
 Mandatory reference to view controller presenting the collection view.
 It is used for modal presentations by the ad view.
 */
@property (nonatomic, weak) UIViewController *presentingViewController;

/**
 The delegate object.
 
 Methods are called to provide control over ad display.
 
 @see AFCollectionViewMediatorDelegate
 */
@property (nonatomic, weak) id <AFCollectionViewMediatorDelegate> delegate;

/**
 AFCollectionViewMediatorDelegate uses only one instance of AFPageAdView, you cannot acces it directly, but you can set the 'adViewDelegate' property of the mediator
 to be informed about the state changes of that ad view.
 
 @see AFAdInterstitialDelegate
 */
@property (nonatomic, weak) id <AFAdInlineDelegate> adViewDelegate;

/**
 This property determines how often ad views are displayed to the user.
 
 For example, if you set adFrequency = 5, it means that after 5 normal pages a page ad view will be displayed.
 
 Default value - 3.
 */
@property (nonatomic, assign) NSInteger adFrequency;

/**
 Setting this property to TRUE enables debug mode on the page ad view.
 
 Default value - FALSE.
 */
@property (nonatomic, assign) BOOL debugMode;

/**
 Initializes an AFPageViewControllerMediator with the given master tag id.
 
 Master tag id is used to initialize AFPageAdView.
 
 @param mid An integer representing Adform master tag id.
 
 @return A newly initialized ad view.
 */
- (instancetype)initWithMasterTagId:(NSInteger )mid;

/**
 Initializes an AFPageViewControllerMediator with the given master tag id, ad frequency and collection view.
 
 Master tag id is used to initialize AFPageAdView.
 
 @param mid An integer representing Adform master tag id.
 @param adFrequency The frequecy of the page ad views.
 @param debugMode Enables debug mode.
 @param collectionView A collection view used to display ads.
 @param presentingViewController The view controller presenting the collection view.
 
 @return A newly initialized ad view.
 */
- (instancetype)initWithMasterTagId:(NSInteger )mid
                        adFrequency:(NSInteger )adFrequency
                          debugMode:(BOOL )debugMode
                     collectionView:(UICollectionView *)collectionView
           presentingViewController:(UIViewController *)presentingViewController;

/**
 Initializes an AFPageViewControllerMediator with the given master tag id, ad frequency and collection view.
 
 Master tag id is used to initialize AFPageAdView.
 
 @param mid An integer representing Adform master tag id.
 @param debugMode Enables debug mode.
 @param collectionView A collection view used to display ads.   
 @param presentingViewController The view controller presenting the collection view.
 
 @return A newly initialized ad view.
 */
- (instancetype)initWithMasterTagId:(NSInteger )mid
                          debugMode:(BOOL )debugMode
                     collectionView:(UICollectionView *)collectionView
           presentingViewController:(UIViewController *)presentingViewController;

/**
 This method resets the internal page views counter, i.e. the next ad view will be displayed after the number of pages set in 'adFrequency" property.
 */
- (void)reset;

/**
 AFCollectionViewMediator uses different internal index paths to communicate with the collection view. Therfore, if you want to access collection view cells directly
 you should first convert the index path you have (outer index path, used by mediator to communicate with datasource provided by you) to the iner index path
 (used by mediator to communicate to collection view). Only then use the index path to intaract direclty to collection view.
 
 You may want this if you are accesing cells directly from collection view, e.g. using 'selectItemAtIndexPath:', 'cellForItemAtIndexPath:' and other similar methods.
 
 @param indexPath An outer index path, you get this index path in all collection view delegate and datasource methods.
 
 @return An internal index path used by collection view directly.
 */
- (NSIndexPath *)indexPathFromOuterIndexPath:(NSIndexPath *)indexPath;

/**
 AFCollectionViewMediator uses different internal index paths to communicate with the collection view. Therfore, if you want to use index paths returned from collection view directly, e.g. from 'indexPathsForSelectedItems:' or 'indexPathsForVisibleItems', to access your datasource you should first convert them using this method.
 
 @param indexPath An index path, used to communicate directly to the collection view, you get this index path by calling various methods to collecion view itself.
 
 @return An internal index path used by collection view directly.
 */
- (NSIndexPath *)outerIndexPathFromIndexPath:(NSIndexPath *)indexPath;

/**
 Helper method for creating collection view cells. You must dequeue collection view cells with internal index paths, therefore if you call 'dequeueReusableCellWithReuseIdentifier:forIndexPath' direclty to collection view
 you must convert the indext path to internal index path using 'indexPathFromOuterIndexPath:' method. 
 
 This helper method is designed to take care of index path conversion for you.
 
 @param identifier The reuse identifier for the specified cell. This parameter must not be nil.
 @param indexPath The index path specifying the location of the cell. The data source receives this information when it is asked for the cell and should just pass it along. This method uses the index path to perform additional configuration based on the cell’s position in the collection view.
 
 @return A valid UICollectionReusableView object.
 */
- (UICollectionViewCell *)dequeueReusableCellWithReuseIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath;

@end

@protocol AFCollectionViewMediatorDelegate <NSObject>

@optional
/**
 Called to determine if ad should be displayed at the index path.
 
 @param mediator A collection view mediator calling the method.
 @param indexPath The index path at which an ad should be displayed.
 
 @return A boolean value indicating if ad should be displayed at the index path.
 */
- (BOOL)collectionViewMediator:(AFCollectionViewMediator *)mediator shouldShowAdAtIndexPath:(NSIndexPath *)indexPath;

@end
