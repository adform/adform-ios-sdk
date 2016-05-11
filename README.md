Adform Advertising iOS SDK
==============

Adform brings brand advertising to the programmatic era at scale, making display advertising simple, relevant and rewarding!

### [IMPORTANT - IOS9 Support](https://github.com/adform/adform-ios-sdk/wiki/Getting-Started#ios-9-support)

### [Getting Started](https://github.com/adform/adform-ios-sdk/wiki/Getting-Started)

**Basic integrations**

* [Integrating Inline Ad](https://github.com/adform/adform-ios-sdk/wiki/Integrating-Inline-Ad)
* [Integrating Full Screen Overlay Ad](https://github.com/adform/adform-ios-sdk/wiki/Integrating-Full-Screen-Overlay-Ad)
* [Integrating Adhesion Ad](https://github.com/adform/adform-ios-sdk/wiki/Integrating-AdHesion-Ad)
* [Integrating Interstitial Ad](https://github.com/adform/adform-ios-sdk/wiki/Integrating-Interstitial-Ad)
* [Integrating Video Ad](https://github.com/adform/adform-ios-sdk/wiki/Video-Ad-Integration)

**Advanced integrations**

* [Advanced Inline Ad Integration](https://github.com/adform/adform-ios-sdk/wiki/Advanced-Inline-Ad-Integration)
* [Integrating Inline Ads in UITableView](https://github.com/adform/adform-ios-sdk/wiki/Integrating-Inline-Ads-in-UITableView)
* [Advanced Full Screen Overlay Ad Integration](https://github.com/adform/adform-ios-sdk/wiki/Advanced-Full-Screen-Overlay-Ad-Integration)
* [Advanced Interstitial Ad Integration](https://github.com/adform/adform-ios-sdk/wiki/Advanced-Interstitial-Ad-Integration)

**Other**

* [Adding Custom Values](https://github.com/adform/adform-ios-sdk/wiki/Adding-custom-values)
* [Adding Keywords](https://github.com/adform/adform-ios-sdk/wiki/Adding-keywords)
* [Adding Key Value Pairs](https://github.com/adform/adform-ios-sdk/wiki/Adding-key-value-pairs)
* [Location Tracking](https://github.com/adform/adform-ios-sdk/wiki/Location-Tracking)
* [Security](https://github.com/adform/adform-ios-sdk/wiki/Security)
* [Ad Tags](https://github.com/adform/adform-ios-sdk/wiki/Ad-Tags)

# Release Notes

# 2.5

### New Features

* Included Adform Header Bidding SDK v.1.0;
* Add additional 'price' and 'customData' parameters to ad views for header bidding support.

### Bug Fixes

* Minor bug fixes;

This part lists release notes from all versions of Adform Mobile Advertising iOS SDK.

# 2.3.1

### New Features

* Added an option to AdHesion ads to enable close button. By default it is disabled.
* Added autohide feature to AdHesion ads. If enabled, AdHesion ad will hide when user interacts wit the application and reveal itself when the interaction ends.

### Bug Fixes

* Minnor bug fixes.

# 2.3

### New Features

* Smart ad size feature - now ad views can dynamically adapt to multiple screen sizes when used with smart ad size. For more details check [Smart ad size](https://github.com/adform/adform-ios-sdk/wiki/Advanced-Inline-Ad-Integration#smart-ad-size).
* Ad tag support - now ad views can load html or url ad tags provided by developer. For more details check [Ad Tags](https://github.com/adform/adform-ios-sdk/wiki/Ad-Tags).
* MRAID viewable percentage support - now MRAID banners may listen for viewablePercentageChange event or use getViewablePercentage() method to know how much of the creative is viewable.  

### Bug Fixes

* Minnor bug fixes.

## 2.2.1

### Bug Fixes

* Fixed a bug where ads were not loading on iOS 6 and 7. 

## 2.2

### New Features

* Multiple sizes support.
* Mraid resize function.
* HTTPS control.

### Bug Fixes

* Minor bug fixes.

## 2.1.3

* Fixes Xcode 7 warnings

## 2.1.2

* Adds ability to choose how to open external links

## 2.1.1

* iOS 9 compatibility update

## 2.1

* Video Ads Support (VAST compatible)
* Targeting by Keywords and Key Values added

## 2.0.2

* Bug Fixes
* 3rd Party Ads Support

## 2.0.1

* Bug Fixes

## 2.0

### New Features

* New formats introduced: Adhesion, Overlay and Interstitial;
* Open RTB protocol support;
* Performance improvements;

### Additional dependencies

Don't forget to add new dependencies to your project if you are updating our SDK from older version or start using cocoapods.

* CoreLocation.framework

## 0.2.1

### New Features

* Added interstitial ads animation control;

## 0.2

### New Features

* Added interstitial ads support;

### Additional dependencies

Don't forget to add new dependencies to your project if you are updating our SDK from 0.1.x version.

* EventKit.framework
* EventKitUI.framework
* MediaPlayer.framework
* CoreTelephony.framework


## 0.1.2

### New Features

* Added refresh Rate override option;
* Added AFBannerViewDelegate protocol;

## 0.1.1

### Bug Fixes

* NewRelic library made as optional;

## 0.1.0

### New Features

* First release;
