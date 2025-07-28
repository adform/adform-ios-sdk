# 📘 Adform OpenRTB Bid Loader Integration Guide

This guide explains how to integrate and use the OpenRTBBidLoader in your iOS project for loading native ads via OpenRTB protocol.

## Requirements

- Use Xcode 16.0 or higher
- Requires deployment target 12.0 or later
- Adform Advertising SDK integrated in your project

## 🚀 Integration Steps

#### 1. Add the Adform Advertising SDK to Your Project

Using Swift Package Manager:

```swift
dependencies: [
    .package(url: "https://github.com/adform/adform-ios-sdk", .upToNextMajor(from: "2.19.0"))
]                                                                            
```

#### 2. Create an OpenRTB Request

The OpenRTBBidLoader requires an OpenRTB request object that specifies the ad request details:

```swift
        // Create a native ad request.
        let nativeAd = AFNative()
        let nativeRequest = AFNativeRequest()

        // Create assets for the native ad (e.g., main image)
        let nativeAsset = AFNativeRequestAsset()
        nativeAsset.rtbId = "0"
        nativeAsset.required = true
        nativeAsset.img = AFRequestImgAsset()
        nativeAsset.img?.heightMin = 166
        nativeAsset.img?.widthMin = 200
        nativeAsset.img?.type = 3
        
        // Add the asset to the request
        nativeRequest.assets = [nativeAsset]
        nativeAd.request = nativeRequest
        
        // Create an impression
        let imp = AFImp()
        imp.rtbId = "1"
        imp.tagId = "YOUR_TAG_ID"
        imp.native = nativeAd
        
        // Build the complete request
        let builder = AFOpenRTBRequestBuilder(
            rtbId: "YOUR_REQUEST_ID",
            imps: [imp]
        )
        let request = builder.createOpenRtbRequest()
```

#### 3. Create and Use the OpenRTBBidLoader

Once you have your request object, you can request an ad using OpenRTBBidLoader:

```swift
        AFOpenRTBBidLoader.requestAd(request) { response, error in
            print("Native ad response: \(response), error: \(error)")
        }
```
