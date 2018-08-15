//
//  AppDelegate.swift
//  SHVPN
//
//  Created by 王雷 on 2017/8/29.
//  Copyright © 2017年 TouchingApp. All rights reserved.
//

import UIKit


@UIApplicationMain
class AppDelegates: AppDelegate {
    
//    var window: UIWindow?
    
   override func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        super.application(application, didFinishLaunchingWithOptions: launchOptions)
        return true
    }

    
    //设置app颜色样式
    func setAppStyle()
    {
        if IsIOS7
        {
            //背景颜色
            UINavigationBar.appearance().barTintColor = mainNavBarColor
            let font:UIFont = UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline)
            UINavigationBar.appearance().titleTextAttributes=[NSForegroundColorAttributeName:mainColor!,NSFontAttributeName : font ]
            UITabBar.appearance().tintColor=mainNavBarColor
            UITabBar.appearance().backgroundColor=UIColor.white
        }
        else
        {
            UINavigationBar.appearance().tintColor=mainNavBarColor
            UITabBar.appearance().tintColor=mainNavBarColor
            UITabBar.appearance().backgroundColor=UIColor.white
        }
    }
    override func applicationWillResignActive(_ application: UIApplication) {
    
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
        super.applicationWillResignActive(application)
    }
    
    override func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        super.applicationDidEnterBackground(application)
    }
    
    override func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        super.applicationWillEnterForeground(application)
    }
    
    override func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        super.applicationDidBecomeActive(application)
    }
    
    override func applicationWillTerminate(_ application: UIApplication) {
        
         super.applicationWillTerminate(application)
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

}
