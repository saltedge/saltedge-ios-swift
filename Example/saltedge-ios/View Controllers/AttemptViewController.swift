//
//  AttemptViewController.swift
//  saltedge-ios_Example
//
//  Created by Vlad Somov.
//  Copyright (c) 2018 Salt Edge. All rights reserved.
//

import UIKit
import SaltEdge
import PKHUD

final class AttemptViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    private var stages: [SEStage] = []
    private var attemptId: String!
    private var loginSecret: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "AttemptCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        requestAttempt()
    }
    
    func requestAttempt() {
        HUD.show(.labeledProgress(title: "Fething Attempt", subtitle: nil))
        SERequestManager.shared.showAttempt(id: attemptId, loginSecret: loginSecret) { [weak self] response in
            switch response {
            case .success(let value):
                if let stages = value.data.stages {
                    self?.stages =  stages
                    self?.tableView.reloadData()
                }
                HUD.hide(animated: true)
            case .failure(let error):
                HUD.flash(.labeledError(title: "Error", subtitle: error.localizedDescription), delay: 3.0)
            }
        }
    }
}

extension AttemptViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "AttemptCell")
        
        let stage = stages[indexPath.row]
        
        cell.textLabel?.text = stage.name
        cell.detailTextLabel?.text = stage.createdAt.description
        
        return cell
    }
}

extension AttemptViewController {
    static func create(attemptId: String, loginSecret: String) -> AttemptViewController? {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        guard let vc = storyboard.instantiateViewController(withIdentifier: "AttemptViewController") as? AttemptViewController else { return nil }
        vc.attemptId = attemptId
        vc.loginSecret = loginSecret
        
        return vc
    }
}



