Adform Advertising iOS SDK
==============

Adform brings brand advertising to the programmatic era at scale, making display advertising simple, relevant and rewarding!

### [Getting Started](https://github.com/adform/adform-ios-sdk-dev/wiki/Getting-Started)

**Basic integrations**

* [Integrating Inline Ad](https://github.com/adform/adform-ios-sdk-dev/wiki/Integrating-Inline-Ad)
* [Integrating Full Screen Overlay Ad](https://github.com/adform/adform-ios-sdk-dev/wiki/Integrating-Full-Screen-Overlay-Ad)
* [Integrating Adhesion Ad](https://github.com/adform/adform-ios-sdk-dev/wiki/Integrating-AdHesion-Ad)
* [Integrating Interstitial Ad](https://github.com/adform/adform-ios-sdk-dev/wiki/Integrating-Interstitial-Ad)

**Advanced integrations**

* [Advanced Inline Ad Integration](https://github.com/adform/adform-ios-sdk-dev/wiki/Advanced-Inline-Ad-Integration)
* [Integrating Inline Ads in UITableView](https://github.com/adform/adform-ios-sdk-dev/wiki/Integrating-Inline-Ads-in-UITableView)
* [Advanced Full Screen Overlay Ad Integration](https://github.com/adform/adform-ios-sdk-dev/wiki/Advanced-Full-Screen-Overlay-Ad-Integration)
* [Advanced Interstitial Ad Integration](https://github.com/adform/adform-ios-sdk-dev/wiki/Advanced-Interstitial-Ad-Integration)

**Other**

* [Adding Custom Values](https://github.com/adform/adform-ios-sdk-dev/wiki/Adding-custom-values)
* [Location Tracking](https://github.com/adform/adform-ios-sdk-dev/wiki/Location-Tracking)


# Aditional info


POST Request example:

```
http://adx.adform.net/adx/mobile/api/?rnd=[random_number]
```

```json
{
    "version": "1.0",
    "user_agent": "Mozilla/5.0 (iPad; U; CPU OS 3_2_1 like Mac OS X; en-us) AppleWebKit/531.21.10 (KHTML, like Gecko) Mobile/7B405",
    "accepted_languages": "en-GB",
    "master_tag_id": 123456,
    "type": "inline",
    "width": 120,
    "height": 50,
    "aid": "1E2DFA89-496A-47FD-9941-DF1FC4E6484A",
    "publisher_id": 654321,
    "dmp_profile": [
        { "name": "param_name", "value": "param_value" },
        { "name": "param_name", "value": "param_value" },
        { "name": "param_name", "value": "param_value" }
    ]
}
```
New request example:
```json
{
  "app": {
    "bundle": "com.adform.advertising",
    "domain": "advertising.adform.com",
    "name": "APp name",
    "ver": "1.0"
  },
  "device": {
    "carrier": {
      "mcc": 123,
      "mnc": 321,
      "name": "Adform"
    },
    "connectiontype": 6,
    "devicetype": 5,
    "geo": {
      "lat": 45,
      "lon": 56.5,
      "type": 1
    },
    "h": 960,
    "hwv": "6 Plus",
    "ifa": "as8d7a98s7d98a7sd98",
    "language": "en_us",
    "lmt": 1,
    "make": "Apple",
    "model": "iPhone",
    "os": "iOS",
    "osv": "7.1",
    "ppi": 34,
    "pxratio": "2.1",
    "ua": "User agent",
    "w": 640
  },
  "dmp_profile": [
    {
      "name": "param",
      "value": "value"
    }
  ],
  "user_agent": "Mozilla/5.0 (iPad; U; CPU OS 3_2_1 like Mac OS X; en-us) AppleWebKit/531.21.10 (KHTML, like Gecko) Mobile/7B405",
  "accepted_languages": "en-GB",
  "aid": "1E2DFA89-496A-47FD-9941-DF1FC4E6484A",
  "height": 50,
  "master_tag_id": 123456,
  "publisher_id": 10,
  "type": "inline",
  "version": "1.0",
  "width": 320
}
```

NOTE FOR THE FUTURE: if aid not available it probably means that user doesnt want to be tracked

Response example:

```json
{
    "adServing": {
        "version": "1.0",
        "ad": {
            "trackingUrlBase": "http://track.adform.net",
            "refreshInterval": 15,
            "tagData": {
                "impressionUrl": "url",
                "src": "<script type=\"text/javascript\" src=\"http://37.157.0.44/mobilesdk/banner.js\"></script>"
            }
        }
    }
}
```

# Release Notes

This part lists release notes from all versions of Adform Mobile Advertising iOS SDK.

## 1.0

### New Features



## 0.2.1

### New Features

* Added interstitial ads animation controll;

## 0.2

### New Features

* Added interstitial ads support;

### Additional dependencies

Don't forget to add new dependancies to your project if you are updating our SDK from 0.1.x version.

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
