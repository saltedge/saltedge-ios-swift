//
//  AppDelegate.swift
//  saltedge-ios_Example
//
//  Created by Vlad Somov.
//  Copyright (c) 2019 Salt Edge. All rights reserved.
//

import UIKit
import PKHUD
import SaltEdge
import SafariServices

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    static let returnToApplicationUrl: String = "saltedge://sdk.example" // the URL has to have a host, otherwise won't be a valid URL on the backend
    static let customerIdPrefix: String = "ios-sdk-customer-identifier"

    var window: UIWindow?

    var tabBar: UITabBarController? {
        return window?.rootViewController as? UITabBarController
    }
    
    var createViewController: CreateViewController? {
        if let tabBar = tabBar,
            let tabBarVCs = tabBar.viewControllers,
            let createVC = tabBarVCs[1].children[0] as? CreateViewController {
            return createVC
        }
        return nil
    }
    
    var connectViewController: ConnectViewController? {
        if let tabBar = tabBar,
            let tabBarVCs = tabBar.viewControllers,
            let connectVC = tabBarVCs[0].children[0] as? ConnectViewController {
            return connectVC
        }
        return nil
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {

        if let connectionSecret = url.connectionSecret {
           UserDefaultsHelper.append(connectionSecret: connectionSecret)
        }
        
        if let safariVc = UIWindow.topViewController as? SFSafariViewController {
            safariVc.dismiss(animated: true)
        }

        if let connectVC = connectViewController {
            connectVC.dismiss(animated: true)

            let alert = UIAlertController(title: "Redirect", message: "Redirect finished.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
            connectVC.present(alert, animated: true)
            connectVC.switchToConnectionsController()
        }

        if let createVC = createViewController {
            HUD.show(.labeledProgress(title: "Fetching OAuth Connection", subtitle: nil))
            SERequestManager.shared.handleOpen(url: url, connectionFetchingDelegate: createVC)
        }
        return true
    }

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let appId: String = "application-id"
        let appSecret: String = "application-secret"

        // By default SSL Pinning is enabled, to disable it use:
        // SERequestManager.shared.set(sslPinningEnabled: false)

        SERequestManager.shared.set(appId: appId, appSecret: appSecret)

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.rootViewController = MainTabBarViewController()

        if let secret = UserDefaultsHelper.customerSecret {
            SERequestManager.shared.set(customerSecret: secret)
        } else {
            let params = SECustomerParams(identifier: "\(AppDelegate.customerIdPrefix)-\(UUID().uuidString)")
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
