//
//  AppDelegate.swift
//  SimpleList
//
//  Created by Theo WU on 20/07/2016.
//  Copyright © 2016 Theo WU. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let dataModel = DataModel()

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        let notificationSettings = UIUserNotificationSettings(forTypes: [.Alert, .Sound], categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(notificationSettings)
        
//        let date = NSDate(timeIntervalSinceNow: 5)
//        
//        let localNotification = UILocalNotification()
//        localNotification.fireDate = date
//        localNotification.timeZone = NSTimeZone.defaultTimeZone()
//        localNotification.alertBody = "I am a local notification!"
//        localNotification.soundName = UILocalNotificationDefaultSoundName
//        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
        
        
        let navigationController = window!.rootViewController as! UINavigationController
        let controller = navigationController.viewControllers[0] as! AllListsViewController
        controller.dataModel = dataModel
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        dataModel.saveSimpleLists()
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        dataModel.saveSimpleLists()
    }
    
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        print("didReceiveLocalNotification \(notification)")
    }
}

