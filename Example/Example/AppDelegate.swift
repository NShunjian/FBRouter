//
//  AppDelegate.swift
//  Example
//
//  Created by Ori on 2020/5/13.
//  Copyright © 2020 Ori. All rights reserved.
//

import UIKit
import FBRouter


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		// Override point for customization after application launch.
		self.window = UIWindow(frame: UIScreen.main.bounds)
		self.window!.backgroundColor = UIColor.white
        self.window!.rootViewController = UINavigationController.init(rootViewController: ViewController.init())
		self.window!.makeKeyAndVisible()
        
        let urlMappings = ["vc00":"ViewController",
						   "vc01":"ViewController01",
						   "vc02":"ViewController02",
						   "vc03":"ViewController03",
						   "vc04":"ViewController04"]
        FBRouter.router().registURLMapping(urlmappings: urlMappings)
        
		return true
	}
	
	func applicationDidEnterBackground(_ application: UIApplication) {
		
	}
	func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
		
	}
	func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
		
	}
	func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
		return true
	}
	func applicationDidBecomeActive(_ application: UIApplication) {
		
	}
	func applicationWillResignActive(_ application: UIApplication) {
		
	}
	
	func applicationWillTerminate(_ application: UIApplication) {
		
	}



	

}

