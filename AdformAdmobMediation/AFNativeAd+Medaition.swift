import Foundation
import GoogleMobileAds
import AdformAdvertising

extension AFNativeAd: @retroactive MediationNativeAd {
    public var headline: String? {
        let title = getTitle()
        return title
    }
    
    public var images: [NativeAdImage]? {
        if let image = getCachedMainImage() {
            return [NativeAdImage(image: image)]
        } else if let mainImage = NativeAdImage(urlString: getImageUrl()) {
            return [mainImage]
        }
        return nil
    }
    
    public var body: String? {
        let description = getDescription()
        return description
    }
    
    public var icon: NativeAdImage? {
        if let cachedIcon = getCachedIconImage() {
            return NativeAdImage(image: cachedIcon)
        }
        
        let image = NativeAdImage(urlString: getIconUrl())
        return image
            
    }
    
    public var callToAction: String? {
        let callToAction = getCallToAction()
        return callToAction
    }
    
    public var starRating: NSDecimalNumber? {
        let starRating = getStarRating()
        return starRating
    }
    
    public var store: String? {
        nil
    }
    
    public var price: String? {
        getSalePrice()
    }
    
    public var advertiser: String? {
        let sponsoredBy = getSponsoredBy()
        return sponsoredBy
    }
    
    public var extraAssets: [String : Any]? {
        nil
    }
    
    public func handlesUserClicks() -> Bool {
        false
    }
    
    public func handlesUserImpressions() -> Bool {
        false
    }
    
    public var adChoicesView: UIView? {
        nil
    }
    
    public var hasVideoContent: Bool {
        false
    }
    
    /// Tells the receiver that an impression is recorded. This method is called only once per mediated
    /// native ad.
    public func didRecordImpression() {
        recordImpression()
    }
    
    /// Tells the receiver that a user click is recorded on the asset named |assetName|. Full screen
    /// actions should be presented from viewController. This method is called only if
    /// -[GADMAdNetworkAdapter handlesUserClicks] returns NO.
    public func didRecordClickOnAsset(
        with assetName: GADNativeAssetIdentifier,
        view: UIView,
        viewController: UIViewController
    ) {
        recordClick()
    }

}

extension NativeAdImage {
    public convenience init?(urlString: String?) {
        guard let urlString, let url = URL(string: urlString) else {
            return nil
        }
        
        self.init(url: url, scale: 1.0)
    }
}
