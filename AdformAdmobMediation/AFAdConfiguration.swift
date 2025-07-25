import Foundation
import GoogleMobileAds
import AdformAdvertising

public struct AFAdConfiguration {
    var adId: String
    var tagId: String
    var parameters: [String: String]
    
    init?(rawValue: String) {
        let rawParameters = rawValue.components(separatedBy: ",")
        guard rawParameters.count >= 2 else {
            return nil
        }
        
        let parameters: [String: String] = rawParameters.reduce(into: [:]) { partialResult, parameter in
            let keyValue = parameter.components(separatedBy: "=")
            if keyValue.count == 2 {
                partialResult[keyValue[0].lowercased()] = keyValue[1]
            }
        }
        
        self.parameters = parameters
        guard let adId = parameters["id"] else {
            return nil
        }
        self.adId = adId
        
        guard let tagId = parameters["tagid"] else {
            return nil
        }
        self.tagId = tagId
    }
}

extension MediationNativeAdConfiguration {
    var afAdConfiguration: AFAdConfiguration? {
        guard let rawValue = credentials.settings["parameter"] as? String else {
            return nil
        }
        
        return AFAdConfiguration(rawValue: rawValue)
    }
}
