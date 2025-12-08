//
//  AFCollectionViewMediator.swift
//  sample
//
//  Created by Laurynas Letkauskas on 2021-02-26.
//

import Foundation
import AdformAdvertising.AFAdInterstitial

private let kAdCellIdentifier = "AdCellIdentifier"

enum AFScrollingDirection: Int {
    case down
    case up
    case left
    case right
    
    func isPositive() -> Bool {
        return self == .down || self == .right
    }
}

/**
 A helper class used to present ads in
 */
class AFCollectionViewMediator: NSObject {
    
    /**
     A reference to the collection view which is used to display ads.
     */
    var collectionView: UICollectionView
    /**
     Mandatory reference to view controller presenting the collection view.
     It is used for modal presentations by the ad view.
     */
    var presentingViewController: UIViewController
    /**
     The delegate object.
     
     Methods are called to provide control over ad display.
     
     @see AFCollectionViewMediatorDelegate
     */
    weak var delegate: AFCollectionViewMediatorDelegate?
    /**
     AFCollectionViewMediatorDelegate uses only one instance of AFAdInterstitial, you cannot acces it directly, but you can set the 'adViewDelegate' property of the mediator
     to be informed about the state changes of that ad view.
     
     @see AFAdInterstitialDelegate
     */
    weak var adViewDelegate: AFAdInlineDelegate?
    /**
     This property determines how often ad views are displayed to the user.
     
     For example, if you set adFrequency = 5, it means that after 5 normal pages a page ad view will be displayed.
     
     Default value - 3.
     */
    var adFrequency: Int = 3
    /**
     Setting this property to TRUE enables debug mode on the page ad view.
     
     Default value - FALSE.
     */
    var debugMode: Bool = false
    
    
    
    /// Master tag id.
    private var mid = 0
    /// Counter used to determine how many pages user has viewed.
    private var pageViews = 0
    /// An index path of the ad.
    private var adIndexPath: IndexPath?
    /// A page ad view used to display ads.
    private var adView: AFAdInterstitial?
    /// Reference to currently displayed ad cell.
    private var adCell: AFAdCollectionViewCell?
    /// Scrolling direction.
    private var scrollDirection: AFScrollingDirection = .right
    /// Internal flags used to control ad insert, remove and update.
    var removeAd = false
    var insertAd = false
    var ignoreRemoveAd = false
    var reloadAdAfterRemove = true

    private weak var originalDatasource: UICollectionViewDataSource?
    private weak var originalDelegate: UICollectionViewDelegate?
    private var lastContentOffset = CGPoint.zero
    
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
     init(
        masterTagId mid: Int,
        collectionView: UICollectionView,
        presenting presentingViewController: UIViewController
    ) {
        self.mid = mid
        self.collectionView = collectionView
        self.presentingViewController = presentingViewController
        super.init()
        setCollectionView()
        setPresentingViewController()
    }
    
    /**
     Initializes an AFPageViewControllerMediator with the given master tag id, ad frequency and collection view.
     
     Master tag id is used to initialize AFPageAdView.
     
     @param mid An integer representing Adform master tag id.
     @param debugMode Enables debug mode.
     @param collectionView A collection view used to display ads.
     @param presentingViewController The view controller presenting the collection view.
     
     @return A newly initialized ad view.
     */
     init(
        masterTagId mid: Int,
        adFrequency: Int,
        collectionView: UICollectionView,
        presenting presentingViewController: UIViewController
    ) {
        self.mid = mid
        self.collectionView = collectionView
        self.presentingViewController = presentingViewController
        super.init()
        setCollectionView()
        setPresentingViewController()
    }
    
    func reset() {
        pageViews = 0
    }
    
    private func setCollectionView() {
        collectionView.register(AFAdCollectionViewCell.self, forCellWithReuseIdentifier: kAdCellIdentifier)
        
        self.originalDelegate = collectionView.delegate
        self.originalDatasource = collectionView.dataSource
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func setPresentingViewController() {
        if (adView == nil) {
            initAdView()
        }
        
        adView?.loadAd()
    }
    
    func initAdView() {

        let adView = AFAdInterstitial(frame: collectionView.bounds, masterTagId: mid, presenting: presentingViewController)

        // TODO: Move as a property of mediator.
        //adView.adSize = CGSize(width: 320, height: 480)
        adView.adTransitionStyle = .none
        adView.autoresizingMask = ([.flexibleHeight, .flexibleWidth])
        adView.delegate = self
        self.adView = adView
        
    }
    
    // MARK: - IndexPath Handling
    
    func outerIndexPathFromIndexPath(_ indexPath: IndexPath) -> IndexPath {
        let section = indexPath.section
        var item = indexPath.item
        
        if let adIndexPath = adIndexPath,
           item > adIndexPath.item {
            item -= 1
        }
        
        return IndexPath(item: item, section: section)
    }
    
    func indexPathFromOuterIndexPath(_ indexPath: IndexPath) -> IndexPath {
        let section = indexPath.section
        var item = indexPath.item
        
        if let adIndexPath = adIndexPath,
            item >= adIndexPath.item {
            item += 1
        }
        
        return IndexPath(item: item, section: section)
    }
    
    func indexPath(_ indexPath: IndexPath, isAfterIndexPath otherIndexPath: IndexPath) -> Bool {
        if indexPath.section == otherIndexPath.section {
            return indexPath.row > otherIndexPath.row
        } else {
            return indexPath.section > otherIndexPath.section
        }
    }
    
    func indexPath(after indexPath: IndexPath?) -> IndexPath? {

        // First lets check if next index path fits into the section.
        if ((indexPath?.item ?? 0) + 1) < collectionView.numberOfItems(inSection: indexPath?.section ?? 0) {
            // Return the next indexpath in the same section.
            let nextIndexPath = IndexPath(item: (indexPath?.item ?? 0) + 1, section: indexPath?.section ?? 0)
            return nextIndexPath
        } else if ((indexPath?.section ?? 0) + 1) < collectionView.numberOfSections {
            // Now we must check if there is next section.
            // We pass item = -1, because on next iteration index path item will be incremented and we want to check if item at index 0 is present.
            let nextIndexPath = IndexPath(item: -1, section: (indexPath?.section ?? 0) + 1)
            return self.indexPath(after: nextIndexPath)
        }

        // We have reached the end of collection view
        return nil
    }

    func indexPath(before indexPath: IndexPath?) -> IndexPath? {

        // First lets check if previous index doesn't go out of section bounds.
        if ((indexPath?.item ?? 0) - 1) > 0 {
            // Return the next indexpath in the same section.
            let nextIndexPath = IndexPath(item: (indexPath?.item ?? 0) - 1, section: indexPath?.section ?? 0)
            return nextIndexPath
        } else if ((indexPath?.section ?? 0) - 1) > 0 {
            // Now we must check if there is next section.
            // We pass item = 1, because on next iteration index path item will be decremented and we want to check if item at index 0 is present.
            let nextIndexPath = IndexPath(item: 1, section: (indexPath?.section ?? 0) + 1)
            return self.indexPath(after: nextIndexPath)
        }

        // We have reached the end of collection view
        return nil
    }
    
    func indexPathForVisibleItem() -> IndexPath {
        
        var visibleItemIndexPath: IndexPath
        let indexPathsForVisibleItems = collectionView.indexPathsForVisibleItems
        if scrollDirection.isPositive() {
            visibleItemIndexPath = indexPathsForVisibleItems.last!
        } else {
            visibleItemIndexPath = indexPathsForVisibleItems.first!
        }
        
        return visibleItemIndexPath
    }
    
    func dequeueReusableCellWithReuseIdentifier(_ identifier: String, forIndexPath indexPath: IndexPath) -> UICollectionViewCell {
        collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPathFromOuterIndexPath(indexPath))
    }
    
    
}

extension AFCollectionViewMediator: UICollectionViewDelegate, UICollectionViewDataSource,
                                    UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
     CGSize(width: self.collectionView.frame.size.width, height: self.collectionView.frame.size.height)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard var numberOfItemsInSection = originalDatasource?.collectionView(collectionView, numberOfItemsInSection: section) else {
            print("Original datasource failed to get number of items in section: \(section)")
            return 0
        }
        
        if let adIndexPath = adIndexPath,
           adIndexPath.section == section {
            numberOfItemsInSection += 1
        }
        
        return numberOfItemsInSection
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath == adIndexPath {
            // Return a collection view cell with page ad view.
            // When ad is displayed we must clear pageViews counter.
            pageViews = 0
            return adCell(fromCollectionView: collectionView, forIndex: indexPath)
        } else {
            // When we display content cell we must increase pageViews count.

            pageViews += 1
            let outerIndexPath = outerIndexPathFromIndexPath(indexPath)
            guard let cell = originalDatasource?.collectionView(collectionView, cellForItemAt: outerIndexPath) else {
                print("originalDatasource failed to dequeue cell for item at indexPath: \(indexPath)")
                return UICollectionViewCell()
            }
            return cell
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        originalDatasource?.numberOfSections?(in: collectionView) ?? 1
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        return (originalDatasource?.collectionView?(collectionView, viewForSupplementaryElementOfKind: kind, at: indexPath))!
    }
    
    func adCell(fromCollectionView collectionView: UICollectionView, forIndex index: IndexPath) -> AFAdCollectionViewCell {
        guard let adCell = collectionView.dequeueReusableCell(withReuseIdentifier: kAdCellIdentifier, for: index) as? AFAdCollectionViewCell else {
            fatalError("Failed to dequeue cell with identifier: \(kAdCellIdentifier) at index: \(index)")
        }
        self.adCell = adCell
        self.adCell?.adView = adView
        
        return adCell
    }
    
    func insertAd(after anIndexPath: IndexPath) {

        let indexPath = IndexPath(item: (anIndexPath.item) + 1, section: anIndexPath.section)
        adIndexPath = indexPath

        UIView.performWithoutAnimation({ [self] in
            collectionView.insertItems(at: [adIndexPath!])
        })
        stopScroll()
    }
    
    func insertAd(before anIndexPath: IndexPath) {

        adIndexPath = anIndexPath
        ignoreRemoveAd = true

        UIView.performWithoutAnimation({ [self] in
            collectionView.insertItems(at: [adIndexPath!])
        })
        let indexPath = IndexPath(item: (anIndexPath.item) + 1, section: anIndexPath.section)
        scrollToItem(atIndex: indexPath, animated: false)

        stopScroll()
    }
    
    func removeAd(animated: Bool) {

        let indexPathToRemove = adIndexPath
        var visibleItemIdexPath = indexPathForVisibleItem()
        adIndexPath = nil

        // We must decrement page views count, because collection view reloads after we remove the cell.
        // Therefore, pageViews counter will increase by one even if user still sees the same view.
        pageViews -= 1

        if !animated {
            UIView.performWithoutAnimation({ [self] in
                collectionView.deleteItems(at: [indexPathToRemove].compactMap { $0 })
            })
        } else {

            let transition = CATransition()
            transition.type = .fade
            transition.duration = 0.3

            collectionView.layer.add(transition, forKey: "transition")
            collectionView.deleteItems(at: [indexPathToRemove].compactMap { $0 })
        }

        if indexPath(visibleItemIdexPath, isAfterIndexPath: indexPathToRemove!) {
            visibleItemIdexPath = IndexPath(item: (visibleItemIdexPath.item) - 1, section: visibleItemIdexPath.section)
            scrollToItem(atIndex: visibleItemIdexPath, animated: false)
        }

        // We must remove ad view from the cell view, because when removed cell view becomes hidden and ad view doesn't load if its superview is hidden.
        adView?.removeFromSuperview()

        if reloadAdAfterRemove {
            adView?.loadAd()
            reloadAdAfterRemove = false
        }
    }
    
    func scrollToItem(atIndex indexPath: IndexPath?, animated: Bool) {

        var origin: CGPoint? = nil
        if let indexPath = indexPath {
            origin = collectionView.layoutAttributesForItem(at: indexPath)?.frame.origin
        }
        let contentInsets = collectionView.contentInset
        var contentOffset = collectionView.contentOffset
        let size = collectionView.bounds.size

        if scrollDirection == .left || scrollDirection == .right {
            let page = floorf(Float((origin?.x ?? 0.0) / size.width))
            contentOffset.x = CGFloat(page) * size.width + contentInsets.left
        } else {
            let page = floorf(Float((origin?.y ?? 0.0) / size.height))
            contentOffset.y = CGFloat(page) * size.height + contentInsets.top
        }

        collectionView.setContentOffset(contentOffset, animated: animated)
    }
    
    func scrollingStarted() {

        lastContentOffset = collectionView.contentOffset

        // We must update the collection view when it stops scrolling,
        // otherwise we may mess up the animations or create a condition when cell insertion or deletion logic
        // interupts internal collection view logic and app may crash.

        if shouldShowAd() {

            // If content cell was removed check if we should insert ad to the next page.
            // If ad should be displayed we must set insertAd flag - TRUE. Ad will be inserted when user stops scrolling.
            insertAd = true
        } else if (adIndexPath != nil) && !collectionView.indexPathsForVisibleItems.contains(adIndexPath!) && !removeAd {

            // If ad was inserted but user is moving away from it, we should remove the ad.
            removeAd = true
        }

        updateCollectionView()
    }
    
    func shouldShowAd() -> Bool {
        if adIndexPath == nil && adView?.isLoaded ?? false {
            let visibleItemIndexPath = indexPathForVisibleItem()
            var indexPath: IndexPath
            if scrollDirection.isPositive() {
                indexPath = IndexPath(item: (visibleItemIndexPath.item) + 1, section: visibleItemIndexPath.section)
            } else {
                if visibleItemIndexPath.item == 0 {
                    return false
                }
                indexPath = IndexPath(item: (visibleItemIndexPath.item) - 1, section: visibleItemIndexPath.section)
            }
            return ((delegate?.collectionViewMediator(self, shouldShowAdAt: indexPath)) != nil)
        } else {
            return pageViews >= adFrequency
        }
    }
    
    func didScroll() {
        let contentOffset = collectionView.contentOffset
        if contentOffset.y > lastContentOffset.y {
            scrollDirection = .down
        } else if contentOffset.y < lastContentOffset.y {
            scrollDirection = .up
        } else if contentOffset.x > lastContentOffset.x {
            scrollDirection = .right
        } else {
            scrollDirection = .left
        }
    }
    
    func stopScroll() {
        var offset = collectionView.contentOffset
        offset.x -= 1.0
        offset.y -= 1.0
        collectionView.setContentOffset(offset, animated: false)
        offset.x += 1.0
        offset.y += 1.0
        collectionView.setContentOffset(offset, animated: false)
    }

    func updateCollectionView() {
        if removeAd {
            removeAd = false
            if ignoreRemoveAd {
                ignoreRemoveAd = false
            } else {
                removeAd(animated: false)
            }
        }
        if insertAd {
            insertAd = false
            let visibleItems = collectionView.indexPathsForVisibleItems
            if let lastItem = visibleItems.last {
                if scrollDirection == .down || scrollDirection == .right {
                    insertAd(after: lastItem)
                } else {
                    insertAd(before: lastItem)
                }
            }
        }
    }
}

extension AFCollectionViewMediator: UIScrollViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        originalDelegate?.scrollViewWillEndDragging?(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        updateCollectionView()
        originalDelegate?.scrollViewDidEndDecelerating?(scrollView)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        didScroll()
        originalDelegate?.scrollViewDidScroll?(scrollView)
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        originalDelegate?.scrollViewDidZoom?(scrollView)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        scrollingStarted()
        originalDelegate?.scrollViewWillBeginDragging?(scrollView)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        originalDelegate?.scrollViewDidEndDragging?(scrollView, willDecelerate: decelerate)
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        originalDelegate?.scrollViewWillBeginDecelerating?(scrollView)
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        originalDelegate?.scrollViewDidEndScrollingAnimation?(scrollView)
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        originalDelegate?.viewForZooming?(in: scrollView)
    }
    
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        originalDelegate?.scrollViewWillBeginZooming?(scrollView, with: view)
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        originalDelegate?.scrollViewDidEndZooming?(scrollView, with: view, atScale: scale)
    }
    
    func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        ((originalDelegate?.scrollViewShouldScrollToTop?(scrollView)) != nil)
    }
    
    func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        originalDelegate?.scrollViewDidScrollToTop?(scrollView)
    }
}

extension AFCollectionViewMediator: AFAdInterstitialDelegate {
    func adInterstitial(_ adInterstitial: AFAdInterstitial, didReceiveCloseCommandWithCompletionHandler completionHandler: @escaping (Bool) -> Void) {
        var indexPath: IndexPath?
        if scrollDirection == .right || scrollDirection == .down {
            indexPath = self.indexPath(after: indexPath)
            if indexPath == nil {
                indexPath = self.indexPath(before: adIndexPath)
            }
        } else {
            indexPath = self.indexPath(before: adIndexPath)
            if indexPath == nil {
                indexPath = self.indexPath(after: adIndexPath)
            }
        }

        collectionView.isUserInteractionEnabled = false
        scrollToItem(atIndex: indexPath, animated: true)

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.3 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: { [self] in
            // Fix for a strange issue with setContentOffset animations. If we try to animate manually
            // collectionView:didEndDisplayingCell:forItemAtIndexPath gets called at the begining of the animation. Therefore, we use standard
            // content offset animation and finish ad close with delay.
            updateCollectionView()
            collectionView.isUserInteractionEnabled = true
            completionHandler(true)
        })
    }
}

extension AFCollectionViewMediator: AFAdInlineDelegate {
    func adInlineDidLoadAd(_ adInline: AFAdInline) {
        adViewDelegate?.adInlineDidLoadAd?(adInline)
    }
    
    func adInlineDidFail(toLoadAd adView: AFAdInline, withError error: Error) {

        adViewDelegate?.adInlineDidFail?(toLoadAd: adView, withError: error)

    }

    func adInlineWillShow(_ adView: AFAdInline) {

        adViewDelegate?.adInlineWillShow?(adView)

    }

    func adInlineWillHide(_ adView: AFAdInline) {

        adViewDelegate?.adInlineWillHide?(adView)

    }

    func adInlineWillPresentModalView(_ adView: AFAdInline) {

        adViewDelegate?.adInlineWillPresentModalView?(adView)

    }

    func adInlineWillDismissModalView(_ adView: AFAdInline) {

        adViewDelegate?.adInlineWillDismissModalView?(adView)

    }

    func adInlineWillOpenExternalBrowser(_ adView: AFAdInline) {

        adViewDelegate?.adInlineWillOpenExternalBrowser?(adView)

    }
}
