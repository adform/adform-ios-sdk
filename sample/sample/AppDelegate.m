//
//  AppDelegate.m
//  sample
//
//  Created by Vladas Drejeris on 04/05/15.
//  Copyright (c) 2015 Adform. All rights reserved.
//

#import "AppDelegate.h"
#import "CollectionPagerViewController.h"
#import "AdformAdvertising/AdformAdvertising.h"
#import <GoogleMobileAds/GoogleMobileAds.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [AdformSDK requestTrackingPermissions:^(BOOL granted) {
            NSLog(@"Tracking permission granted: %@", granted ? @"YES" : @"NO");
        }];
    });
    
    [[GADMobileAds sharedInstance] startWithCompletionHandler:^(GADInitializationStatus * _Nonnull status) {
        NSDictionary *statuses = [status adapterStatusesByClassName];
        for (NSString *key in statuses.allKeys) {
            GADAdapterStatus *adapterStatus = statuses[key];
            NSLog(@"Adapter Name: %@, Description: %@, Latency: %f", key, adapterStatus.description, adapterStatus.latency);
        }
    }];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
