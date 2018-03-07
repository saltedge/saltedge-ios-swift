//
//  AttemptsViewController.swift
//  saltedge-ios_Example
//
//  Created by Vlad Somov.
//  Copyright (c) 2018 Salt Edge. All rights reserved.
//

import UIKit
import SaltEdge
import PKHUD

final class AttemptsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    private var attempts: [SEAttempt] = []
    private var loginSecret: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "AttemptCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        requestAttempts()
    }
    
    func requestAttempts() {
        HUD.show(.labeledProgress(title: "Fething Attempts", subtitle: nil))
        SERequestManager.shared.getAttempts(for: loginSecret) { [weak self] response in
            switch response {
            case .success(let value):
                self?.attempts = value.data
                self?.tableView.reloadData()
                HUD.hide(animated: true)
            case .failure(let error):
                HUD.flash(.labeledError(title: "Error", subtitle: error.localizedDescription), delay: 3.0)
            }
        }
    }
}

extension AttemptsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return attempts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "AttemptCell")
        
        let attempt = attempts[indexPath.row]
        
        cell.textLabel?.text = attempt.successAt != nil ? attempt.successAt?.description : attempt.failAt?.description
        cell.detailTextLabel?.textColor = attempt.successAt != nil ? .green : .red
        cell.detailTextLabel?.text = attempt.successAt != nil ? "Success" : "Failure"

        return cell
    }
}

extension AttemptsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let attempt = attempts[indexPath.row]
        
        guard let attemptVC = AttemptViewController.create(attemptId: attempt.id, loginSecret: loginSecret) else { return }
        
        navigationController?.pushViewController(attemptVC, animated: true)
    }
}

extension AttemptsViewController {
    static func create(loginSecret: String) -> AttemptsViewController? {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        guard let vc = storyboard.instantiateViewController(withIdentifier: "AttemptsViewController") as? AttemptsViewController else { return nil }
        vc.loginSecret = loginSecret

        return vc
    }
}


