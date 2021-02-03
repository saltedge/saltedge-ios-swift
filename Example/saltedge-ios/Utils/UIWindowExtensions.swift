//
//  UIWindowExtensions.swift
//  saltedge-ios_Example
//
//  Created by Constantin Chelban on 3/2/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import UIKit

extension UIWindow {
    static var topViewController: UIViewController? {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.window?.rootViewController as? UITabBarController
    }
}
