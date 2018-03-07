//
//  LoginsViewController.swift
//  saltedge-ios_Example
//
//  Created by Vlad Somov.
//  Copyright (c) 2018 Salt Edge. All rights reserved.
//

import UIKit
import SaltEdge
import PKHUD

class LoginsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    private var logins: [SELogin] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "LoginCell")
        tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshLogins()
    }
    
    @IBAction func refreshPressed(_ sender: Any) {
        refreshLogins()
    }
    
    func refreshLogins() {
        guard let loginsSecrets = UserDefaultsHelper.logins else { return }
        
        logins = []
        tableView.reloadData()
        
        if loginsSecrets.isEmpty {
            HUD.flash(.label("No Logins Found"), delay: 1.0)
        } else {
            HUD.show(.labeledProgress(title: "Fetching Logins", subtitle: nil))
        }
        for loginSecret in loginsSecrets {
            SERequestManager.shared.getLogin(with: loginSecret) { [weak self] response in
                switch response {
                case .success(let value):
                    self?.logins.append(value.data)
                    self?.tableView.reloadData()
                    if self?.logins.count == loginsSecrets.count {
                        HUD.hide(animated: true)
                    }
                case .failure(let error):
                    HUD.flash(.labeledError(title: "Error", subtitle: error.localizedDescription), delay: 3.0)
                }
            }
        }
    }
}

extension LoginsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return logins.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LoginCell", for: indexPath)
        
        let login = logins[indexPath.row]
        
        cell.textLabel?.text = login.providerName
        
        return cell
    }
}

extension LoginsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let login = logins[indexPath.row]
        
        guard let accountsVC = AccountsViewController.create(with: login) else { return }
        
        navigationController?.pushViewController(accountsVC, animated: true)
    }
}
