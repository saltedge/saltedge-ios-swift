//
//  UIWindowExtensions.swift
//  saltedge-ios_Example
//
//  Created by Constantin Chelban on 3/2/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import UIKit

extension UIApplication {
    static var topViewController: UIViewController? {
        return shared.windows.first?.rootViewController
    }
}
