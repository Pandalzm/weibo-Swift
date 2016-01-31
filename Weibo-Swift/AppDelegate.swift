//
//  AppDelegate.swift
//  Weibo-Swift
//
//  Created by PandaLZMing on 16/1/21.
//  Copyright © 2016年 PandaLZMing. All rights reserved.
//

import UIKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var tabBarController: CYLTabBarController?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
//        self.window?.backgroundColor = UIColor.grayColor()
        self.window = UIWindow()
        self.window?.frame = UIScreen.mainScreen().bounds
        self.setupViewControllers()
        self.window?.rootViewController = self.tabBarController
        self.window?.makeKeyAndVisible()
        self.customizeInterface()
        return true
    }
    
    func setupViewControllers() {
        CYLPlusButton.registerSubclass()
        let firstViewController: WBTimeLineViewController = WBTimeLineViewController()
        let firstNavigationController: UIViewController = UINavigationController(rootViewController:firstViewController)
        
        let secondViewController: WBMessageViewController = WBMessageViewController()
        let secondNavigationController: UIViewController = UINavigationController(rootViewController: secondViewController)
        
        let thirdViewController: WBDiscoverViewController = WBDiscoverViewController()
        let thirdNavigationController: UIViewController = UINavigationController(rootViewController: thirdViewController)
        
        let fourthViewController: WBProfileViewController = WBProfileViewController()
        let fourthNavigationController: UIViewController = UINavigationController(rootViewController: fourthViewController)
        
        let tabBarController: CYLTabBarController! = CYLTabBarController()
        self.customizeTabBarForController(tabBarController)
        
        tabBarController.viewControllers = [firstNavigationController, secondNavigationController, thirdNavigationController, fourthNavigationController]

        self.tabBarController = tabBarController
    }
    
    func customizeTabBarForController(tabBarController: CYLTabBarController){
        let dict1 = [CYLTabBarItemTitle : "首页", CYLTabBarItemImage : "tabbar_home_os7", CYLTabBarItemSelectedImage : "tabbar_home_selected_os7"]
        let dict2 = [CYLTabBarItemTitle : "消息", CYLTabBarItemImage : "tabbar_message_center_os7", CYLTabBarItemSelectedImage : "tabbar_message_center_selected_os7"]
        let dict3 = [CYLTabBarItemTitle : "发现", CYLTabBarItemImage : "tabbar_discover_os7", CYLTabBarItemSelectedImage : "tabbar_discover_selected_os7"]
        let dict4 = [CYLTabBarItemTitle : "我的", CYLTabBarItemImage : "tabbar_profile_os7", CYLTabBarItemSelectedImage : "tabbar_profile_selected_os7"]
        
        let tabBarItemsAttributes = [dict1, dict2, dict3, dict4]
        tabBarController.tabBarItemsAttributes = tabBarItemsAttributes
    }
    
    func customizeInterface() {
        self.setupTabBarItemTextAttributes()
    }
    
    func setupTabBarItemTextAttributes() {
        let normalAttrs = [NSForegroundColorAttributeName : UIColor.grayColor()]
        let selectedAttrs = [NSForegroundColorAttributeName : UIColor.orangeColor()]
        
        let tabBar: UITabBarItem = UITabBarItem.appearance()
        tabBar.setTitleTextAttributes(normalAttrs, forState: .Normal)
        tabBar.setTitleTextAttributes(selectedAttrs, forState: .Highlighted)
//        
//        let tabBarAppearance: UITabBar = UITabBar.appearance()
//        tabBarAppearance.backgroundImage = UIImage(named: "")
    
    
    }

}

