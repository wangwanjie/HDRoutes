//
//  HDRoutesUtil.swift
//  HDRoutes
//
//  Created by VanJay on 2019/7/13.
//  Copyright © 2019 Fnoz. All rights reserved.
//

import UIKit

class HDRoutesUtil {
    // MARK: - public methods

    /// 获取当前页面
    class func currentTopViewController() -> UIViewController {
        let rootViewController = UIApplication.shared.keyWindow?.rootViewController
        return currentTopViewController(rootViewController: rootViewController!)
    }

    /// 打印日志
    class func printLog<T>(_ message: T, file _: String = #file, method _: String = #function, line _: Int = #line) {
        guard HDRoutes.verboseLoggingEnabled else {
            return
        }

        print("[HDRoutes]: \(message)")
    }

    // MARK: - private methods

    private class func currentTopViewController(rootViewController: UIViewController) -> UIViewController {
        if rootViewController.isKind(of: UITabBarController.self) {
            let tabBarController = rootViewController as! UITabBarController
            return currentTopViewController(rootViewController: tabBarController.selectedViewController!)
        } else if rootViewController.isKind(of: UINavigationController.self) {
            let navigationController = rootViewController as! UINavigationController
            return currentTopViewController(rootViewController: navigationController.visibleViewController!)
        }
        if rootViewController.presentedViewController != nil {
            return currentTopViewController(rootViewController: rootViewController.presentedViewController!)
        }
        return rootViewController
    }
}
