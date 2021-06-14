//
//  AFCollectionViewMediator.m
//  AdformAdvertising
//
//  Created by Vladas Drejeris on 31/03/15.
//  Copyright (c) 2015 Adform. All rights reserved.
//

#import "AFCollectionViewMediator.h"

#define IS_IOS7_OR_LATER (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1)

typedef NS_ENUM(NSInteger, AFScrollingDirection) {
    AFScrollingDirectionDown,
    AFScrollingDirectionUp,
    AFScrollingDirectionLeft,
    AFScrollingDirectionRight
};

static inline BOOL AFScrollDirectionIsPositive(AFScrollingDirection direction) {
    
    return (direction == AFScrollingDirectionDown || direction == AFScrollingDirectionRight);
}

static NSString * const kAdCellIdentifier = @"AdCellIdentifier";

@interface AFAdCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) AFAdInterstitial *adView;

@end

@implementation AFAdCollectionViewCell

- (void)setAdView:(AFAdInterstitial *)adView {
    
    _adView = adView;
    _adView.frame = self.contentView.bounds;
    
    [self.contentView addSubview:adView];
}

@end

@interface AFCollectionViewMediator () <AFAdInterstitialDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate> {
    
@private
    /// Master tag id.
    NSInteger _mid;
    /// Counter used to determine how many pages user has viewed.
    NSInteger _pageViews;
    /// An index path of the ad.
    NSIndexPath *_adIndexPath;
    /// A page ad view used to display ads.
    AFAdInterstitial *_adView;
    /// Reference to currently displayed ad cell.
    AFAdCollectionViewCell *_adCell;
    /// Scrolling direction.
    AFScrollingDirection _scrollDirection;
    
    /// Internal flags used to control ad insert, remove and update.
    struct {
        unsigned int removeAd:1;
        unsigned int insertAd:1;
        unsigned int ignoreRemoveAd:1;
        unsigned int reloadAdAfterRemove:1;
    } _flags;
}

@property (nonatomic, assign) id <UICollectionViewDataSource> originalDatasource;
@property (nonatomic, assign) id originalDelegate;

@property (nonatomic) CGPoint lastContentOffset;

@end

@implementation AFCollectionViewMediator

- (instancetype)initWithMasterTagId:(NSInteger )mid {
    
    if (self = [super init]) {
        _mid = mid;
        _adFrequency = 3;
        _pageViews = 0;
        _scrollDirection = AFScrollingDirectionRight;
        
        _flags.removeAd = NO;
        _flags.insertAd = NO;
        _flags.ignoreRemoveAd = NO;
        _flags.reloadAdAfterRemove = YES;
    }
    
    return self;
}

- (instancetype)initWithMasterTagId:(NSInteger )mid
                        adFrequency:(NSInteger )adFrequency
                     collectionView:(UICollectionView *)collectionView
           presentingViewController:(UIViewController *)presentingViewController{
    
    if (self = [self initWithMasterTagId:mid]) {
        self.adFrequency = adFrequency;
        
        self.collectionView = collectionView;
        self.presentingViewController = presentingViewController;
    }
    return self;
}

- (instancetype)initWithMasterTagId:(NSInteger )mid
                     collectionView:(UICollectionView *)collectionView
           presentingViewController:(UIViewController *)presentingViewController{
    
    if (self = [self initWithMasterTagId:mid]) {
        self.collectionView = collectionView;
        self.presentingViewController = presentingViewController;
    }
    return self;
}

- (void)dealloc {
    
    _collectionView.delegate = nil;
    _collectionView.dataSource = nil;
}

- (void )initAdView {
    
    AFAdInterstitial *adView = [[AFAdInterstitial alloc] initWithFrame:self.collectionView.bounds masterTagId:_mid presentingViewController:self.presentingViewController];
    adView.adTransitionStyle = AFAdTransitionStyleNone;
    adView.autoresizingMask = (UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);
    adView.translatesAutoresizingMaskIntoConstraints = YES;
    adView.delegate = self;
    _adView = adView;
}

- (void)reset {
    
    _pageViews = 0;
}

#pragma mark - Setters and getters

- (void)setCollectionView:(UICollectionView *)collectionView {
    
    _collectionView = collectionView;
    [_collectionView registerClass:[AFAdCollectionViewCell class] forCellWithReuseIdentifier:kAdCellIdentifier];
    
    self.originalDatasource = _collectionView.dataSource;
    self.originalDelegate = _collectionView.delegate;
    
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
}

- (void)setPresentingViewController:(UIViewController *)presentingViewController {
    
    _presentingViewController = presentingViewController;
    
    if (!_adView) {
        [self initAdView];
    }
    
    [_adView loadAd];
}

#pragma mark - Ads injection

- (BOOL )shouldShowAd {
    
    if (_adIndexPath == nil && _adView.isLoaded) {
        if ([self.delegate respondsToSelector:@selector(collectionViewMediator:shouldShowAdAtIndexPath:)]) {
            NSIndexPath *visibleItemIndexPath = [self indexPathForVisibleItem];
            NSIndexPath *indexPath;
            if (AFScrollDirectionIsPositive(_scrollDirection)) {
                indexPath = [NSIndexPath indexPathForItem:(visibleItemIndexPath.item + 1) inSection:visibleItemIndexPath.section];
            } else {
                if (visibleItemIndexPath.item == 0) {
                    return NO;
                }
                indexPath = [NSIndexPath indexPathForItem:(visibleItemIndexPath.item - 1) inSection:visibleItemIndexPath.section];
            }
            return [self.delegate collectionViewMediator:self shouldShowAdAtIndexPath:indexPath];
        } else {
            return _pageViews >= _adFrequency;
        }
    } else {
        return NO;
    }
}

- (AFAdCollectionViewCell *)adCellFromCollectionView:(UICollectionView *)collectionView forIndex:(NSIndexPath *)indexPath {
    
    _adCell = [collectionView dequeueReusableCellWithReuseIdentifier:kAdCellIdentifier forIndexPath:indexPath];
    _adCell.adView = _adView;
    
    return _adCell;
}

- (void)insertAdAfterIndexPath:(NSIndexPath *)anIndexPath {
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:(anIndexPath.item + 1) inSection:anIndexPath.section];
    _adIndexPath = indexPath;
    
    if (IS_IOS7_OR_LATER) {
        [UIView performWithoutAnimation:^{
            [self.collectionView insertItemsAtIndexPaths:@[_adIndexPath]];
        }];
    } else {
        [self.collectionView insertItemsAtIndexPaths:@[_adIndexPath]];
    }
    
    [self stopScroll];
}

- (void)insertAdBeforeIndexPath:(NSIndexPath *)anIndexPath {
    
    _adIndexPath = anIndexPath;
    _flags.ignoreRemoveAd = YES;
    
    if (IS_IOS7_OR_LATER) {
        [UIView performWithoutAnimation:^{
            [self.collectionView insertItemsAtIndexPaths:@[_adIndexPath]];
        }];
    } else {
        [self.collectionView insertItemsAtIndexPaths:@[_adIndexPath]];
    }
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:(anIndexPath.item + 1) inSection:anIndexPath.section];
    [self scrollToItemAtIndex:indexPath animated:NO];
    
    [self stopScroll];
}

- (void)removeAdAnimated:(BOOL )animated {
    
    NSIndexPath *indexPathToRemove = _adIndexPath;
    NSIndexPath *visibleItemIdexPath = [self indexPathForVisibleItem];
    _adIndexPath = nil;

    // We must decrement page views count, because collection view reloads after we remove the cell.
    // Therefore, pageViews counter will increase by one even if user still sees the same view.
    _pageViews --;
    
    if (!animated && IS_IOS7_OR_LATER) {
        [UIView performWithoutAnimation:^{
            [self.collectionView deleteItemsAtIndexPaths:@[indexPathToRemove]];
        }];
    } else {
        
        CATransition *transition = [CATransition animation];
        transition.type = kCATransitionFade;
        transition.duration = 0.3;
        
        [self.collectionView.layer addAnimation:transition forKey:@"transition"];
        [self.collectionView deleteItemsAtIndexPaths:@[indexPathToRemove]];
    }
    
    if ([self indexPath:visibleItemIdexPath isAfterIndexPath:indexPathToRemove]) {
        visibleItemIdexPath = [NSIndexPath indexPathForItem:(visibleItemIdexPath.item - 1) inSection:visibleItemIdexPath.section];
        [self scrollToItemAtIndex:visibleItemIdexPath animated:NO];
    }
    
    // We must remove ad view from the cell view, because when removed cell view becomes hidden and ad view doesn't load if its superview is hidden.
    [_adView removeFromSuperview];
    
    if (_flags.reloadAdAfterRemove) {
        [_adView loadAd];
        _flags.reloadAdAfterRemove = NO;
    }
}

- (void)handleCell:(UICollectionViewCell *)cell didEndDisplayingForIndexPath:(NSIndexPath *)indexPath {
    
    if ([cell isKindOfClass:[AFAdCollectionViewCell class]]) {
        
        // If ad collection view cell was removed we should remove the ad from collection view.
        // To do so we must set removeAd flag - TRUE. Ad will be removed when user stops scrolling.
        _flags.removeAd = YES;
        
        // User has seen our ad we should reload it.
        _flags.reloadAdAfterRemove = YES;
        
    }
}

- (void)stopScroll {
    
    CGPoint offset = self.collectionView.contentOffset;
    offset.x -= 1.0;
    offset.y -= 1.0;
    [self.collectionView setContentOffset:offset animated:NO];
    offset.x += 1.0;
    offset.y += 1.0;
    [self.collectionView setContentOffset:offset animated:NO];
}

- (void)scrollToItemAtIndex:(NSIndexPath *)indexPath animated:(BOOL )animated {
    
    CGPoint origin = [self.collectionView layoutAttributesForItemAtIndexPath:indexPath].frame.origin;
    UIEdgeInsets contentInsets = self.collectionView.contentInset;
    CGPoint contentOffset = self.collectionView.contentOffset;
    CGSize size = self.collectionView.bounds.size;
    
    if (_scrollDirection == AFScrollingDirectionLeft || _scrollDirection == AFScrollingDirectionRight) {
        float page = floorf(origin.x / size.width);
        contentOffset.x = page * size.width + contentInsets.left;
    } else {
        float page = floorf(origin.y / size.height);
        contentOffset.y = page * size.height + contentInsets.top;
    }
    
    [self.collectionView setContentOffset:contentOffset animated:animated];
}

- (void)scrollingStarted {
    
    self.lastContentOffset = self.collectionView.contentOffset;
    
    // We must update the collection view when it stops scrolling,
    // otherwise we may mess up the animations or create a condition when cell insertion or deletion logic
    // interupts internal collection view logic and app may crash.
    
    if ([self shouldShowAd]) {
        
        // If content cell was removed check if we should insert ad to the next page.
        // If ad should be displayed we must set insertAd flag - TRUE. Ad will be inserted when user stops scrolling.
        _flags.insertAd = YES;
    }
    else if (_adIndexPath && ![[self.collectionView indexPathsForVisibleItems] containsObject:_adIndexPath] && !_flags.removeAd) {
        
        // If ad was inserted but user is moving away from it, we should remove the ad.
        _flags.removeAd = YES;
    }
    
    [self updateCollectionView];
}

- (void)didScroll {
    
    CGPoint contentOffset = self.collectionView.contentOffset;
    
    if (contentOffset.y > self.lastContentOffset.y) {
        _scrollDirection = AFScrollingDirectionDown;
    } else if (contentOffset.y < self.lastContentOffset.y) {
        _scrollDirection = AFScrollingDirectionUp;
    } else if (contentOffset.x > self.lastContentOffset.x) {
        _scrollDirection = AFScrollingDirectionRight;
    } else {
        _scrollDirection = AFScrollingDirectionLeft;
    }
}

- (void)updateCollectionView {
    
    if (_flags.removeAd) {
        _flags.removeAd = NO;
        if (_flags.ignoreRemoveAd) {
            _flags.ignoreRemoveAd = NO;
        } else {
            [self removeAdAnimated:NO];
        }
    }
    
    if (_flags.insertAd) {
        _flags.insertAd = NO;
        NSArray *visibleItems = [self.collectionView indexPathsForVisibleItems];
        NSIndexPath *lastItem = [visibleItems lastObject];
        if (_scrollDirection == AFScrollingDirectionDown || _scrollDirection == AFScrollingDirectionRight) {
            [self insertAdAfterIndexPath:lastItem];
        } else {
            [self insertAdBeforeIndexPath:lastItem];
        }
    }
}

#pragma mark - NSIndexPath handling

- (NSIndexPath *)outerIndexPathFromIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger section = indexPath.section;
    NSInteger item = indexPath.item;
    
    if (_adIndexPath && item > _adIndexPath.item) {
        item --;
    }
    
    NSIndexPath *anIndexPath = [NSIndexPath indexPathForItem:item inSection:section];
    
    return anIndexPath;
}

- (NSIndexPath *)indexPathFromOuterIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger section = indexPath.section;
    NSInteger item = indexPath.item;
    
    if (_adIndexPath && item >= _adIndexPath.item) {
        item ++;
    }
    
    NSIndexPath *anIndexPath = [NSIndexPath indexPathForItem:item inSection:section];
    
    return anIndexPath;
}

- (BOOL)indexPath:(NSIndexPath *)indexPath isAfterIndexPath:(NSIndexPath *)otherIndexPath {
    
    if (indexPath.section == otherIndexPath.section) {
        return (indexPath.row > otherIndexPath.row);
    } else {
        return (indexPath.section > otherIndexPath.section);
    }
}

- (NSIndexPath *)indexPathForVisibleItem {
    
    NSIndexPath *visibleItemIndexPath;
    NSArray *indexPathsForVisibleItems = [self.collectionView indexPathsForVisibleItems];
    
    if (AFScrollDirectionIsPositive(_scrollDirection)) {
        visibleItemIndexPath = [indexPathsForVisibleItems lastObject];
    } else {
        visibleItemIndexPath = [indexPathsForVisibleItems firstObject];
    }
    
    return visibleItemIndexPath;
}

- (NSIndexPath *)indexPathAfterIndexPath:(NSIndexPath *)indexPath {
    
    // First lets check if next index path fits into the section.
    if ((indexPath.item + 1) < [self.collectionView numberOfItemsInSection:indexPath.section]) {
        // Return the next indexpath in the same section.
        NSIndexPath *nextIndexPath = [NSIndexPath indexPathForItem:(indexPath.item + 1) inSection:indexPath.section];
        return nextIndexPath;
    } else if ((indexPath.section + 1) < [self.collectionView numberOfSections]) {
        // Now we must check if there is next section.
        // We pass item = -1, because on next iteration index path item will be incremented and we want to check if item at index 0 is present.
        NSIndexPath *nextIndexPath = [NSIndexPath indexPathForItem:-1 inSection:(indexPath.section + 1)];
        return [self indexPathAfterIndexPath:nextIndexPath];
    }
    
    // We have reached the end of collection view
    return nil;
}

- (NSIndexPath *)indexPathBeforeIndexPath:(NSIndexPath *)indexPath {
    
    // First lets check if previous index doesn't go out of section bounds.
    if ((indexPath.item - 1) > 0) {
        // Return the next indexpath in the same section.
        NSIndexPath *nextIndexPath = [NSIndexPath indexPathForItem:(indexPath.item - 1) inSection:indexPath.section];
        return nextIndexPath;
    } else if ((indexPath.section - 1) > 0) {
        // Now we must check if there is next section.
        // We pass item = 1, because on next iteration index path item will be decremented and we want to check if item at index 0 is present.
        NSIndexPath *nextIndexPath = [NSIndexPath indexPathForItem:1 inSection:(indexPath.section + 1)];
        return [self indexPathAfterIndexPath:nextIndexPath];
    }
    
    // We have reached the end of collection view
    return nil;
}

- (NSInteger )distanceBetweenIndexPath:(NSIndexPath *)indexPath andIndexPath:(NSIndexPath *)otherIndexPath {
    
    NSInteger result = 0;
    NSIndexPath *firstIndexPath;
    NSIndexPath *secondIndexPath;

    if (indexPath.section < otherIndexPath.section) {
        firstIndexPath = indexPath;
        secondIndexPath = otherIndexPath;
    } else if (indexPath.section == otherIndexPath.section) {
        if (indexPath.item <= otherIndexPath.item) {
            firstIndexPath = indexPath;
            secondIndexPath = otherIndexPath;
        } else {
            firstIndexPath = otherIndexPath;
            secondIndexPath = indexPath;
        }
    } else {
        firstIndexPath = otherIndexPath;
        secondIndexPath = indexPath;
    }
    
    if (firstIndexPath.section == secondIndexPath.section) {
        result = ABS(firstIndexPath.item - secondIndexPath.item);
    } else {
        for (NSInteger i = firstIndexPath.section; i <= secondIndexPath.section; i ++) {
            if (i == firstIndexPath.section) {
                result += [self.collectionView numberOfItemsInSection:i] - firstIndexPath.item - 1;
            } else if (i == secondIndexPath.section) {
                result += secondIndexPath.item;
            } else {
                result += [self.collectionView numberOfItemsInSection:i];
            }
        }
    }
    
    return result;
}

#pragma mark - AFPageAdViewDelegate

- (void)adInterstitial:(AFAdInterstitial *)adInterstitial didReceiveCloseCommandWithCompletionHandler:(void (^)(BOOL))completionHandler {
    
    NSIndexPath *indexPath;
    if (_scrollDirection == AFScrollingDirectionRight || _scrollDirection == AFScrollingDirectionDown) {
        indexPath = [self indexPathAfterIndexPath:_adIndexPath];
        if (!indexPath) {
            indexPath = [self indexPathBeforeIndexPath:_adIndexPath];
        }
    } else {
        indexPath = [self indexPathBeforeIndexPath:_adIndexPath];
        if (!indexPath) {
            indexPath = [self indexPathAfterIndexPath:_adIndexPath];
        }
    }
    
    self.collectionView.userInteractionEnabled = NO;
    [self scrollToItemAtIndex:indexPath animated:YES];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // Fix for a strange issue with setContentOffset animations. If we try to animate manually
        // collectionView:didEndDisplayingCell:forItemAtIndexPath gets called at the begining of the animation. Therefore, we use standard
        // content offset animation and finish ad close with delay.
        [self updateCollectionView];
        self.collectionView.userInteractionEnabled = YES;
        completionHandler(true);
    });
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    
    if ([self.originalDelegate respondsToSelector:@selector(scrollViewWillEndDragging:withVelocity:targetContentOffset:)]) {
        [self.originalDelegate scrollViewWillEndDragging:scrollView withVelocity:velocity targetContentOffset:targetContentOffset];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    [self updateCollectionView];
    
    if ([self.originalDelegate respondsToSelector:@selector(scrollViewDidEndDecelerating:)]) {
        [self.originalDelegate scrollViewDidEndDecelerating:scrollView];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    [self didScroll];
    
    if ([self.originalDelegate respondsToSelector:@selector(scrollViewDidScroll:)]) {
        [self.originalDelegate scrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    
    if ([self.originalDelegate respondsToSelector:@selector(scrollViewDidZoom:)]) {
        [self.originalDelegate scrollViewDidZoom:scrollView];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    [self scrollingStarted];
    
    if ([self.originalDelegate respondsToSelector:@selector(scrollViewWillBeginDragging:)]) {
        [self.originalDelegate scrollViewWillBeginDragging:scrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    if ([self.originalDelegate respondsToSelector:@selector(scrollViewDidEndDragging:willDecelerate:)]) {
        [self.originalDelegate scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    
    if ([self.originalDelegate respondsToSelector:@selector(scrollViewWillBeginDecelerating:)]) {
        [self.originalDelegate scrollViewWillBeginDecelerating:scrollView];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    
    if ([self.originalDelegate respondsToSelector:@selector(scrollViewDidEndScrollingAnimation:)]) {
        [self.originalDelegate scrollViewDidEndScrollingAnimation:scrollView];
    }
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    
    if ([self.originalDelegate respondsToSelector:@selector(viewForZoomingInScrollView:)]) {
        return [self.originalDelegate viewForZoomingInScrollView:scrollView];
    } else {
        return nil;
    }
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view {
    
    if ([self.originalDelegate respondsToSelector:@selector(scrollViewWillBeginZooming:withView:)]) {
        [self.originalDelegate scrollViewWillBeginZooming:scrollView withView:view];
    }
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
    
    if ([self.originalDelegate respondsToSelector:@selector(scrollViewDidEndZooming:withView:atScale:)]) {
        [self.originalDelegate scrollViewDidEndZooming:scrollView withView:view atScale:scale];
    }
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView {
    
    if ([self.originalDelegate respondsToSelector:@selector(scrollViewShouldScrollToTop:)]) {
        return [self.originalDelegate scrollViewShouldScrollToTop:scrollView];
    } else {
        return YES;
    }
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView {
    
    if ([self.originalDelegate respondsToSelector:@selector(scrollViewDidScrollToTop:)]) {
        [self.originalDelegate scrollViewDidScrollToTop:scrollView];
    }
}

#pragma Flow layout delegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.originalDelegate respondsToSelector:@selector(collectionView:layout:sizeForItemAtIndexPath:)]) {
        return [self.originalDelegate collectionView:collectionView layout:collectionViewLayout sizeForItemAtIndexPath:[self outerIndexPathFromIndexPath:indexPath]];
    } else {
        return [(UICollectionViewFlowLayout *)collectionViewLayout itemSize];
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    if ([self.originalDelegate respondsToSelector:@selector(collectionView:layout:insetForSectionAtIndex:)]) {
        return [self.originalDelegate collectionView:collectionView layout:collectionViewLayout insetForSectionAtIndex:section];
    } else {
        return [(UICollectionViewFlowLayout *)collectionViewLayout sectionInset];
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    if ([self.originalDelegate respondsToSelector:@selector(collectionView:layout:minimumLineSpacingForSectionAtIndex:)]) {
        return [self.originalDelegate collectionView:collectionView layout:collectionViewLayout minimumLineSpacingForSectionAtIndex:section];
    } else {
        return [(UICollectionViewFlowLayout *)collectionViewLayout minimumLineSpacing];
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    if ([self.originalDelegate respondsToSelector:@selector(collectionView:layout:minimumInteritemSpacingForSectionAtIndex:)]) {
        return [self.originalDelegate collectionView:collectionView layout:collectionViewLayout minimumInteritemSpacingForSectionAtIndex:section];
    } else {
        return [(UICollectionViewFlowLayout *)collectionViewLayout minimumInteritemSpacing];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    if ([self.originalDelegate respondsToSelector:@selector(collectionView:layout:referenceSizeForHeaderInSection:)]) {
        return [self.originalDelegate collectionView:collectionView layout:collectionViewLayout referenceSizeForHeaderInSection:section];
    } else {
        return [(UICollectionViewFlowLayout *)collectionViewLayout headerReferenceSize];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    
    if ([self.originalDelegate respondsToSelector:@selector(collectionView:layout:referenceSizeForFooterInSection:)]) {
        return [self.originalDelegate collectionView:collectionView layout:collectionViewLayout referenceSizeForFooterInSection:section];
    } else {
        return [(UICollectionViewFlowLayout *)collectionViewLayout footerReferenceSize];
    }
}

#pragma mark - UICollectionViewDataSource

- (UICollectionViewCell *)dequeueReusableCellWithReuseIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath {
    
    return [self.collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:[self indexPathFromOuterIndexPath:indexPath]];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    NSInteger number = [self.originalDatasource collectionView:collectionView numberOfItemsInSection:section];
    
    if (_adIndexPath && _adIndexPath.section == section) {
        // If ad view is inserted to the collection view we must increase its item count in that section.

        number ++;
    }
    return number;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([indexPath isEqual:_adIndexPath]) {
        // Return a collection view cell with page ad view.
        // When ad is displayed we must clear pageViews counter.
        
        _pageViews = 0;
        return [self adCellFromCollectionView:collectionView forIndex:indexPath];
    } else {
        // When we display content cell we must increase pageViews count.
        
        _pageViews ++;
        NSIndexPath *outerIndexPath = [self outerIndexPathFromIndexPath:indexPath];
        UICollectionViewCell *cell = [self.originalDatasource collectionView:collectionView cellForItemAtIndexPath:outerIndexPath];
        return cell;
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    if ([self.originalDatasource respondsToSelector:@selector(numberOfSectionsInCollectionView:)]) {
        return [self.originalDatasource numberOfSectionsInCollectionView:collectionView];
    } else {
        return 1;
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.originalDatasource respondsToSelector:@selector(collectionView:viewForSupplementaryElementOfKind:atIndexPath:)]) {
        return [self.originalDatasource collectionView:collectionView viewForSupplementaryElementOfKind:kind atIndexPath:indexPath];
    } else {
        return nil;
    }
}

#pragma mark - UICollectionViewDelegate

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.originalDelegate respondsToSelector:@selector(collectionView:shouldHighlightItemAtIndexPath:)]) {
        return [self.originalDelegate collectionView:collectionView shouldHighlightItemAtIndexPath:[self outerIndexPathFromIndexPath:indexPath]];
    } else {
        return YES;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath {

    if ([self.originalDelegate respondsToSelector:@selector(collectionView:didHighlightItemAtIndexPath:)]) {
        [self.originalDelegate collectionView:collectionView shouldHighlightItemAtIndexPath:[self outerIndexPathFromIndexPath:indexPath]];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.originalDelegate respondsToSelector:@selector(collectionView:didUnhighlightItemAtIndexPath:)]) {
        [self.originalDelegate collectionView:collectionView didUnhighlightItemAtIndexPath:indexPath];
    }
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.originalDelegate respondsToSelector:@selector(collectionView:shouldSelectItemAtIndexPath:)]) {
        return [self.originalDelegate collectionView:collectionView shouldSelectItemAtIndexPath:[self outerIndexPathFromIndexPath:indexPath]];
    } else {
        return YES;
    }
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.originalDelegate respondsToSelector:@selector(collectionView:shouldDeselectItemAtIndexPath:)]) {
        return [self.originalDelegate collectionView:collectionView shouldDeselectItemAtIndexPath:[self outerIndexPathFromIndexPath:indexPath]];
    } else {
        return YES;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.originalDelegate respondsToSelector:@selector(collectionView:didSelectItemAtIndexPath:)]) {
        [self.originalDelegate collectionView:collectionView didSelectItemAtIndexPath:[self outerIndexPathFromIndexPath:indexPath]];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.originalDelegate respondsToSelector:@selector(collectionView:didDeselectItemAtIndexPath:)]) {
        [self.originalDelegate collectionView:collectionView didDeselectItemAtIndexPath:[self outerIndexPathFromIndexPath:indexPath]];
    }
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.originalDelegate respondsToSelector:@selector(collectionView:willDisplayCell:forItemAtIndexPath:)]) {
        [self.originalDelegate collectionView:collectionView willDisplayCell:cell forItemAtIndexPath:[self outerIndexPathFromIndexPath:indexPath]];
    }
}

- (void)collectionView:(UICollectionView *)collectionView willDisplaySupplementaryView:(UICollectionReusableView *)view forElementKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.originalDelegate respondsToSelector:@selector(collectionView:willDisplaySupplementaryView:forElementKind:atIndexPath:)]) {
        [self.originalDelegate collectionView:collectionView willDisplaySupplementaryView:view forElementKind:elementKind atIndexPath:[self outerIndexPathFromIndexPath:indexPath]];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [self handleCell:cell didEndDisplayingForIndexPath:indexPath];
    
    if ([self.originalDelegate respondsToSelector:@selector(collectionView:didEndDisplayingCell:forItemAtIndexPath:)]) {
        [self.originalDelegate collectionView:collectionView didEndDisplayingCell:cell forItemAtIndexPath:[self outerIndexPathFromIndexPath:indexPath]];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingSupplementaryView:(UICollectionReusableView *)view forElementOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.originalDelegate respondsToSelector:@selector(collectionView:didEndDisplayingSupplementaryView:forElementOfKind:atIndexPath:)]) {
        [self.originalDelegate collectionView:collectionView didEndDisplayingSupplementaryView:view forElementOfKind:elementKind atIndexPath:[self outerIndexPathFromIndexPath:indexPath]];
    }
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.originalDelegate respondsToSelector:@selector(collectionView:shouldShowMenuForItemAtIndexPath:)]) {
        return [self.originalDelegate collectionView:collectionView shouldShowMenuForItemAtIndexPath:[self outerIndexPathFromIndexPath:indexPath]];
    } else {
        return NO;
    }
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
    
    if ([self.originalDelegate respondsToSelector:@selector(collectionView:canPerformAction:forItemAtIndexPath:withSender:)]) {
        return [self.originalDelegate collectionView:collectionView canPerformAction:action forItemAtIndexPath:[self outerIndexPathFromIndexPath:indexPath] withSender:sender];
    } else {
        return NO;
    }
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
    
    if ([self.originalDelegate respondsToSelector:@selector(collectionView:performAction:forItemAtIndexPath:withSender:)]) {
        [self.originalDelegate collectionView:collectionView performAction:action forItemAtIndexPath:[self outerIndexPathFromIndexPath:indexPath] withSender:sender];
    }
}

- (UICollectionViewTransitionLayout *)collectionView:(UICollectionView *)collectionView transitionLayoutForOldLayout:(UICollectionViewLayout *)fromLayout newLayout:(UICollectionViewLayout *)toLayout {
    
    if ([self.originalDelegate respondsToSelector:@selector(collectionView:transitionLayoutForOldLayout:newLayout:)]) {
        return [self.originalDelegate collectionView:collectionView transitionLayoutForOldLayout:fromLayout newLayout:toLayout];
    } else {
        return [[UICollectionViewTransitionLayout alloc] initWithCurrentLayout:fromLayout nextLayout:toLayout];
    }
}

- (void)adInlineDidLoadAd:(AFAdInline *)adView {
    
    if ([self.adViewDelegate respondsToSelector:@selector(adInlineDidLoadAd:)]) {
        [self.adViewDelegate adInlineDidLoadAd:adView];
    }
}

- (void)adInlineDidFailToLoadAd:(AFAdInline *)adView withError:(NSError *)error {
    
    if ([self.adViewDelegate respondsToSelector:@selector(adInlineDidFailToLoadAd:withError:)]) {
        [self.adViewDelegate adInlineDidFailToLoadAd:adView withError:error];
    }
}

- (void)adInlineWillShow:(AFAdInline *)adView {
    
    if ([self.adViewDelegate respondsToSelector:@selector(adInlineWillShow:)]) {
        [self.adViewDelegate adInlineWillShow:adView];
    }
}

- (void)adInlineWillHide:(AFAdInline *)adView {
    
    if ([self.adViewDelegate respondsToSelector:@selector(adInlineWillHide:)]) {
        [self.adViewDelegate adInlineWillHide:adView];
    }
}

- (void)adInlineWillPresentModalView:(AFAdInline *)adView {
    
    if ([self.adViewDelegate respondsToSelector:@selector(adInlineWillPresentModalView:)]) {
        [self.adViewDelegate adInlineWillPresentModalView:adView];
    }
}

- (void)adInlineWillDismissModalView:(AFAdInline *)adView {
    
    if ([self.adViewDelegate respondsToSelector:@selector(adInlineWillDismissModalView:)]) {
        [self.adViewDelegate adInlineWillDismissModalView:adView];
    }
}

- (void)adInlineWillOpenExternalBrowser:(AFAdInline *)adView {
    
    if ([self.adViewDelegate respondsToSelector:@selector(adInlineWillOpenExternalBrowser:)]) {
        [self.adViewDelegate adInlineWillOpenExternalBrowser:adView];
    }
}

@end
