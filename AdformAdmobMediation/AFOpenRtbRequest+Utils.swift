import Foundation
import AdformAdvertising

extension AFOpenRtbRequest {
    enum AssetCategory {
        case image, data
    }
    
    func findAsset(category: AssetCategory, type: Int) -> AFNativeRequestAsset? {
        guard
            let nativeAssets = imps?.first?.native?.request?.assets
        else {
            return nil
        }
        
        for asset in nativeAssets {
            switch category {
            case .image where asset.img != nil && asset.img?.type?.intValue == type:
                return asset
            case .data where asset.data != nil && asset.data?.type?.intValue == type:
                return asset
            default:
                continue
            }
        }
        
        return nil
    }
    
    func mainImageAssetId() -> String? {
        return findAsset(category: .image, type: 3)?.rtbId
    }
    
    func appIconImageAssetId() -> String? {
        return findAsset(category: .image, type: 1)?.rtbId
    }
    
    func descriptionAssetId() -> String? {
        return findAsset(category: .data, type: 2)?.rtbId
    }
    
    func callToActionAssetId() -> String? {
        return findAsset(category: .data, type: 12)?.rtbId
    }
    
    func sponsoredByAssetId() -> String? {
        return findAsset(category: .data, type: 1)?.rtbId
    }
    
    func starRatingAssetId() -> String? {
        return findAsset(category: .data, type: 3)?.rtbId
    }
    
    func salePriceAssetId() -> String? {
        return findAsset(category: .data, type: 7)?.rtbId
    }
}
