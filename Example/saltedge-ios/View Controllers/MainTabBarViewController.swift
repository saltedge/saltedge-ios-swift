//
//  MainTabBarViewController.swift
//  saltedge-ios_Example
//
//  Created by Daniel Marcenco on 8/2/19.
//  Copyright (c) 2019 Salt Edge. All rights reserved.
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
        let createVc = storyboard.instantiateViewController(withIdentifier: "CreateViewController")
        let connectionsVc = storyboard.instantiateViewController(withIdentifier: "ConnectionsViewController")

        let controllers = [
            UINavigationController(rootViewController: connectVc),
            UINavigationController(rootViewController: createVc),
            UINavigationController(rootViewController: connectionsVc)
        ]

        viewControllers = controllers
    }
}
