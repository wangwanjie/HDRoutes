//
//  AppDelegate.swift
//  HDRoutes
//
//  Created by VanJay on 2019/7/13.
//  Copyright © 2019 VanJay. All rights reserved.
//

import UIKit
import HDRoutes

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let routes = HDRoutes.globalRoutes()

        routes?.addRoute(pattern: "/user/view/:userID", handler: { (params) -> Bool in
            let userID = params["userID"] // defined in the route by specifying ":userID"

            // present UI for viewing user with ID 'userID'

            return true // return true to say we have handled the route
        })

        // HDRoutes.verboseLoggingEnabled = true

        HDRoutes.routesForScheme("ViPay")?.addRoute(pattern: "/test/:opt(/a)(/b)(/c)", priority: 10, handler: { (params) -> Bool in
            print("打开测试页面\(params)")
            return true
        })

        HDRoutes.globalRoutes()?.addRoute(pattern: "/test1", handler: { (params) -> Bool in
            print("打开测试1页面\(params)")
            return true
        })

        HDRoutes.routesForScheme("ViPay")?.unmatchedURLHandler = { _, _, _ in
            print("无法识别的 ViPay 路由")
        }

        HDRoutes.globalRoutes()?.unmatchedURLHandler = { _, _, _ in
            print("无法识别的路由")
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            _ = HDRoutes.routeURL(URL(string: "ViPay://test/:opt?a=6")!, parameters: ["name": "wangwanjie", "number": 5_201_314])

            _ = HDRoutes.routeURL(URL(string: "/test1?age=27#topic")!, parameters: ["name": "wangwanjie", "number": 5_201_314])

            _ = HDRoutes.routeURL(URL(string: "ViPay://8978998798q")!)
            _ = HDRoutes.routeURL(URL(string: "jhkhjkkk")!)
        }

        HDRoutes.globalRoutes()?.setHandlerBlock({ (_) -> Bool in
            // ...

            true
        }, forKeyedSubscript: "/user/view/:userID")

        return true
    }

    func application(_: UIApplication, open url: URL, options _: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        return HDRoutes.routeURL(url)
    }
}
