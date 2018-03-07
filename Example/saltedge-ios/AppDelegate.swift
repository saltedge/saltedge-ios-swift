//
//  AppDelegate.swift
//  saltedge-ios_Example
//
//  Created by Vlad Somov.
//  Copyright (c) 2018 Salt Edge. All rights reserved.
//

import UIKit
import PKHUD
import SaltEdge

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    static let applicationURLString: String = "saltedge-api-swift-demo://home.local"; // the URL has to have a host, otherwise won't be a valid URL on the backend

    var window: UIWindow?

    var tabBar: UITabBarController? {
        if let tabBar = window?.rootViewController as? UITabBarController {
            return tabBar
        }
        return nil
    }
    
    var createViewController: CreateViewController? {
        if let tabBar = tabBar, let tabBarVCs = tabBar.viewControllers, let createVC = tabBarVCs[1].childViewControllers[0] as? CreateViewController {
            return createVC
        }
        return nil
    }
    
    var connectViewController: ConnectViewController? {
        if let tabBar = tabBar, let tabBarVCs = tabBar.viewControllers, let connectVC = tabBarVCs[0].childViewControllers[0] as? ConnectViewController {
            return connectVC
        }
        return nil
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        if let createVC = createViewController {
            HUD.show(.labeledProgress(title: "Fetching OAuth Login", subtitle: nil))
            SERequestManager.shared.handleOpen(url: url, loginFetchingDelegate: createVC)
        }
        return true
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let appId: String = "your-app-id"
        let appSecret: String = "your-app-secret"
        let customerId: String = "customer-secret"

        // By default SSL Pinning is enabled to disabled it use:
        // SERequestManager.shared.set(sslPinningEnabled: false)

        SERequestManager.shared.set(appId: appId, appSecret: appSecret)
        
        if let secret = UserDefaultsHelper.customerSecret {
            SERequestManager.shared.set(customerSecret: secret)
        } else {
            let params = SECustomerParams(identifier: customerId)
            SERequestManager.shared.createCustomer(with: params) { response in
                switch response {
                case .success(let value):
                    UserDefaultsHelper.customerSecret = value.data.secret
                    SERequestManager.shared.set(customerSecret: value.data.secret)
                case .failure(let error): print(error)
                }
            }
        }
        
        return true
    }
}

