//
//  MainTabBarViewController.swift
//  saltedge-ios_Example
//
//  Created by Daniel Marcenco on 8/2/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import SaltEdge

final class MainTabBarViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewControllers()
    }

    private func setupViewControllers() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let connectVc = storyboard.instantiateViewController(withIdentifier: "ConnectViewController")
        let connectionsVc = storyboard.instantiateViewController(withIdentifier: "ConnectionsViewController")

        var controllers = [
            UINavigationController(rootViewController: connectVc),
            UINavigationController(rootViewController: connectionsVc)
        ]

        if !SERequestManager.shared.isPartner {
            let createVc = storyboard.instantiateViewController(withIdentifier: "CreateViewController")
            controllers.insert(UINavigationController(rootViewController: createVc), at: 1)
        }

        viewControllers = controllers
    }
}
