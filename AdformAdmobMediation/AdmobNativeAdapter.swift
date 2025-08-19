import Foundation
import GoogleMobileAds
import AdformAdvertising

open class AdmobNativeAdapter: NSObject, MediationAdapter {
    
    // MARK: - Dependencies
    
    public weak var mediationEventDelegate: MediationNativeAdEventDelegate?
    
    // MARK: - Configuration
    
    required public override init() {
        
    }
    
    public static func setUp(
        with configuration: MediationServerConfiguration,
        completionHandler: @escaping GADMediationAdapterSetUpCompletionBlock
    ) {
        completionHandler(nil)
    }
    
    public static func adapterVersion() -> VersionNumber {
        return VersionNumber(majorVersion: 1, minorVersion: 0, patchVersion: 0)
    }
    
    public static func adSDKVersion() -> VersionNumber {
        let versionAndBuild = AdformSDK.sdkVersion().components(separatedBy: " ")
        let versionComponents = versionAndBuild.first?.components(separatedBy: ".")
        guard
            let versionComponents,
            versionComponents.count >= 3,
            let majorVersion = Int(versionComponents[0]),
            let minorVersion = Int(versionComponents[1]),
            let patchVersion = Int(versionComponents[2])
        else {
            return VersionNumber()
        }
        return VersionNumber(majorVersion: majorVersion, minorVersion: minorVersion, patchVersion: patchVersion)
    }
    
    public static func networkExtrasClass() -> (any AdNetworkExtras.Type)? {
        return nil
    }
    
    // MARK: - Ad loading
    
    open func makeAdAssets() -> [AFNativeRequestAsset] {
        let mainImageAsset = AFNativeRequestAsset()
        mainImageAsset.rtbId = "0"
        mainImageAsset.required = false
        mainImageAsset.img = AFRequestImgAsset()
        mainImageAsset.img?.heightMin = 166
        mainImageAsset.img?.widthMin = 200
        mainImageAsset.img?.type = 3
        
        let titleAsset = AFNativeRequestAsset()
        titleAsset.rtbId = "1"
        titleAsset.required = false
        titleAsset.data = AFRequestDataAsset()
        titleAsset.data?.type = 2
        
        let descriptionAsset = AFNativeRequestAsset()
        descriptionAsset.rtbId = "2"
        descriptionAsset.required = false
        descriptionAsset.data = AFRequestDataAsset()
        descriptionAsset.data?.type = 2
        
        let sponsoredByAsset = AFNativeRequestAsset()
        sponsoredByAsset.rtbId = "3"
        sponsoredByAsset.required = false
        sponsoredByAsset.data = AFRequestDataAsset()
        sponsoredByAsset.data?.type = 1
        
        let appIconAsset = AFNativeRequestAsset()
        appIconAsset.rtbId = "4"
        appIconAsset.required = false
        appIconAsset.img = AFRequestImgAsset()
        appIconAsset.img?.heightMin = 10
        appIconAsset.img?.widthMin = 10
        appIconAsset.img?.type = 1
        
        let callToActionAsset = AFNativeRequestAsset()
        callToActionAsset.rtbId = "5"
        callToActionAsset.required = false
        callToActionAsset.data = AFRequestDataAsset()
        callToActionAsset.data?.type = 12
        
        let ratingAsset = AFNativeRequestAsset()
        ratingAsset.rtbId = "6"
        ratingAsset.required = false
        ratingAsset.data = AFRequestDataAsset()
        ratingAsset.data?.type = 3
        
        let salePrice = AFNativeRequestAsset()
        salePrice.rtbId = "7"
        salePrice.required = false
        salePrice.data = AFRequestDataAsset()
        salePrice.data?.type = 7
        
        return [
            mainImageAsset,
            titleAsset,
            descriptionAsset,
            sponsoredByAsset,
            appIconAsset,
            callToActionAsset,
            ratingAsset,
            salePrice
        ]
    }
    
    open func makeAdImpression(
        for adConfiguration: AFAdConfiguration
    ) -> AFImp {
        let nativeRequest = AFNativeRequest()
        nativeRequest.assets = makeAdAssets()
        
        let nativeAd = AFNative()
        nativeAd.request = nativeRequest
        
        let imp = AFImp()
        imp.rtbId = "1"
        imp.tagId = adConfiguration.tagId
        imp.native = nativeAd
        
        return imp
    }
    
    open func makeOpenRTBRequest(for adConfiguration: AFAdConfiguration) -> AFOpenRtbRequest {
        let impression = makeAdImpression(for: adConfiguration)
        let request = AFOpenRTBRequestBuilder(
            rtbId: adConfiguration.adId,
            imps: [impression]
        ).createOpenRtbRequest()
        return request
    }
    
    public func loadNativeAd(
        for adConfiguration: MediationNativeAdConfiguration,
        completionHandler: @escaping GADMediationNativeLoadCompletionHandler
    ) {
        guard let afAdConfiguration = adConfiguration.afAdConfiguration else {
            _ = completionHandler(nil, NSError(
                domain: kAFErrorDomain,
                code: AFHBErrorCode.invalidNativeAdConfigurationError.rawValue,
                userInfo: [NSLocalizedDescriptionKey: "Invalid ad configuration retrieved from adomob mediation"]
            ))
            return
        }
        
        let request = makeOpenRTBRequest(for: afAdConfiguration)
        let nativeAdAssetIds = AFNativeAdAssetIds()
        nativeAdAssetIds.mainImageId = request.mainImageAssetId()
        nativeAdAssetIds.appIconImageId = request.appIconImageAssetId()
        nativeAdAssetIds.descriptionId = request.descriptionAssetId()
        nativeAdAssetIds.ctaId = request.callToActionAssetId()
        nativeAdAssetIds.sponsoredById = request.sponsoredByAssetId()
        nativeAdAssetIds.ratingId = request.starRatingAssetId()
        nativeAdAssetIds.salePriceId = request.salePriceAssetId()
        
        AFOpenRTBBidLoader.requestAd(request) { [weak self] response, error in
            guard error == nil else {
                _ = completionHandler(nil, error)
                return
            }
            guard let nativeResponse = response?.seatBid?.first?.bid?.first?.nativeResponse else {
                _ = completionHandler(nil, NSError(
                    domain: kAFErrorDomain,
                    code: AFHBErrorCode.invalidServerResponseError.rawValue,
                    userInfo: [NSLocalizedDescriptionKey: "Native ad not found in response"]
                ))
                return
            }
            let nativeAd = AFNativeAd(nativeResponse: nativeResponse, assetIds: nativeAdAssetIds)
            self?.loadImages(for: nativeAd) { _ in
                self?.mediationEventDelegate = completionHandler(nativeAd, nil)
            }
        }
    }
    
    private func loadImages(
        for nativeAd: AFNativeAd,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        nativeAd.downloadMainImage { mainImageError in
            nativeAd.downloadIconImage { iconError in
                if let error = mainImageError ?? iconError {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
        }
    }
}
