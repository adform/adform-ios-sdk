# 📘 Adform Native Mediation Adapter Integration Guide

This guide explains how to integrate the Adform Native Mediation Adapter into your iOS project, using OpenRTB for loading native ads via Google Mobile Ads mediation.

## Requirements

- Use Xcode 16.0 or higher
- Requires deployment target 12.0 or later
- Google Mobile Ads SDK (12.6.0+ recommended)
- Mediation Adapter integrated in the mediation waterfall

## 🚀 Integration Steps

#### 1. Add the Adform Advertising SDK and Admob Mediation package to Your Project

We recommend using Swift Package Manager for easy integration.

```swift
dependencies: [
    .package(url: "https://github.com/adform/adform-ios-sdk", .upToNextMajor(from: "2.21.0"))
]
```

#### 2. Configure Admob mediation

For a full guide on how to set up mediation in AdMob, refer to the official documentation:

[Set up mediation in AdMob](https://support.google.com/admob/answer/13412127#zippy=)
[Set up a custom event](https://support.google.com/admob/answer/13407144?sjid=18215975188649201795-EU)

You would need to set up **Custom Events** manually in your mediation configuration, use the **class name** of the adapter:
`AdformAdmob.AdmobNativeAdapter`

In the AdMob mediation network UI, configure the `parameter` value with:
`id=<request_id>,tagid=<tag_id>`
For example: `id=1234,tagid=567890`

#### 3. Implement AdMob native ads.

Here is a guide how to implement AdMob native ads:
[Native AdMob ads setup in android](https://developers.google.com/admob/ios/native)

### 🔧 Optional: Custom Adapter Extension for Native Asset Changes

If you want to customize which native assets are requested from Adform or how they are mapped, you can subclass `AdmobNativeAdapter` and override key methods:

#### Steps:

1.  **Subclass the Adapter**
```
class CustomAdformNativeAdapter: AdformNativeAdapter {
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
        
        return [
            mainImageAsset,
            titleAsset
        ]
    }
}
```

2.  **Register your custom adapter class name in mediation configuration or custom event:**

Please use `YourAppName.CustomAdformNativeAdapter` instead of `AdformAdmob.AdmobNativeAdapter`
