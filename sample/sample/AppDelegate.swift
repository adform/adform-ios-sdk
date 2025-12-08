//
//  AppDelegate.swift
//  sample
//
//  Created by Laurynas Letkauskas on 2021-02-25.
//

import UIKit
import AdformAdvertising
import GoogleMobileAds

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            AdformSDK.requestTrackingPermissions()
        }
        
        MobileAds.shared.start { status in
          // Optional: Log each adapter's initialization latency.
          let adapterStatuses = status.adapterStatusesByClassName
          for adapter in adapterStatuses {
            let adapterStatus = adapter.value
            NSLog("Adapter Name: %@, Description: %@, Latency: %f", adapter.key,
            adapterStatus.description, adapterStatus.latency)
          }

          // Start loading ads here...
        }
        
        return true
    }
}

