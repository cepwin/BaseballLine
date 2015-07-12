//
//  AppDelegate.swift
//  BaseballLine
//
//  Created by Wendy Sarrett on 6/14/15.
//  Copyright (c) 2015 Wendy Sarrett. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    
    private var backgroundTask: UIBackgroundTaskIdentifier = UIBackgroundTaskInvalid
    var window: UIWindow?
    
    var controller = MasterViewController()



    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        let tabBarController = self.window!.rootViewController as! TabBarController
        let navigationController = tabBarController.viewControllers?[0] as! UINavigationController
        self.controller = navigationController.topViewController as! MasterViewController
        let configParent = tabBarController.viewControllers?[1] as! UINavigationController
        let configMenu = configParent.topViewController as! ConfigChoiceViewController
        return true
    }
    
    
    func registerBackgroundTask() {
        backgroundTask = UIApplication.sharedApplication().beginBackgroundTaskWithExpirationHandler {
            [unowned self] in
            self.endBackgroundTask()
        }
        assert(backgroundTask != UIBackgroundTaskInvalid)
    }
    
    func endBackgroundTask() {
        UIApplication.sharedApplication().endBackgroundTask(backgroundTask)
        backgroundTask = UIBackgroundTaskInvalid
    }
    
    func application(application: UIApplication,
        handleWatchKitExtensionRequest userInfo: [NSObject : AnyObject]?, reply: (([NSObject : AnyObject]!) -> Void)!) {
            registerBackgroundTask()
            NSLog("in handle code")
            let tabBarController = self.window!.rootViewController as! TabBarController
            
            let request = userInfo as? NSDictionary
            
            let content = request?.objectForKey("content") as! String
            
            if content == "getdata" {
                let url = NSURL(string: "https://erikberg.com/mlb/standings.json")
                let request = NSMutableURLRequest(URL: url!)
                let bundle = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleShortVersionString") as! String
                var userAgent = "BaseballLine/\(bundle)(cepwin@gmail.com)"
                request.setValue(userAgent, forHTTPHeaderField: "User-Agent")
                var loadTeams = false
                if tabBarController.teamHandler.count == 0 {
                    loadTeams = true
                }
                NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {(response, data, error) in
                    let httpResponse = response as! NSHTTPURLResponse
                    if(httpResponse.statusCode == 429) {
                        let dictionary:NSDictionary = httpResponse.allHeaderFields
                        let times = dictionary.valueForKey("xmlstats-api-remaining")!.integerValue as NSInteger
                        if(times == 0) {
                            let date = NSDate().timeIntervalSince1970 as NSTimeInterval
                            let xmlReset:NSString? = dictionary.valueForKey("xmlstats-api-reset") as? NSString
                            if(xmlReset != nil) {
                                let  distance = date.distanceTo((xmlReset)!.doubleValue) as Double
                                NSLog("waiting \(distance) seconds to retry")
                                reply(["content":["error!":"error"]])
                                self.endBackgroundTask()
                                
                            }
                        }
                        reply(["error" : "timeout retry"])
                        self.endBackgroundTask()

                    }
                    if(error == nil) {
                        println(NSString(data: data, encoding: NSUTF8StringEncoding))
                        var error:NSError? = nil
                        
                        self.controller.parsedObject = NSJSONSerialization.JSONObjectWithData(data, options:   NSJSONReadingOptions.AllowFragments, error:&error) as! NSDictionary
                        if(error == nil) {
                            let res1 = self.controller.parsedObject.mutableArrayValueForKey("standing")
                            self.controller.loadDataIntoObjs(res1)
                            //            self.transData = ["myData":self.teamDictSM]
                            reply(["content":self.controller.teamDictSM])
                            self.endBackgroundTask()
                            
                        }
                        reply(["error" : "error parsing data"])
                        self.endBackgroundTask()
                    }
                    else {
                        reply(["content":["error!":"error"]])
                        self.endBackgroundTask()
                        
                    }
                    reply(["error" : "error with response"])
                    self.endBackgroundTask()

                }
            }
            else {
                reply(["success":"yes"])
                endBackgroundTask()
                
            }
            
    }
    


    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

