//
//  ConnectionsViewController.swift
//  saltedge-ios_Example
//
//  Created by Vlad Somov.
//  Copyright (c) 2019 Salt Edge. All rights reserved.
//

import UIKit
import SaltEdge
import PKHUD

class ConnectionsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    private var connections: [SEConnection] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ConnectionCell")
        tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshConnections()
    }
    
    @IBAction func refreshPressed(_ sender: Any) {
        refreshConnections()
    }
    
    func refreshConnections() {
        guard let connectionsSecrets = UserDefaultsHelper.connectionSecrets else { return }
        
        connections = []
        tableView.reloadData()
        
        if connectionsSecrets.isEmpty {
            HUD.flash(.label("No Connections Found"), delay: 1.0)
        } else {
            HUD.show(.labeledProgress(title: "Fetching Connections", subtitle: nil))
        }
        for connectionSecret in connectionsSecrets {
            SERequestManager.shared.getConnection(with: connectionSecret) { [weak self] response in
                switch response {
                case .success(let value):
                    self?.connections.append(value.data)
                    self?.tableView.reloadData()
                    if self?.connections.count == connectionsSecrets.count {
                        HUD.hide(animated: true)
                    }
                case .failure(let error):
                    HUD.flash(.labeledError(title: "Error", subtitle: error.localizedDescription), delay: 3.0)
                }
            }
        }
    }
}

extension ConnectionsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return connections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ConnectionCell", for: indexPath)
        
        let connection = connections[indexPath.row]
        
        cell.textLabel?.text = connection.providerName
        
        return cell
    }
}

extension ConnectionsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let connection = connections[indexPath.row]
        
        guard let accountsVC = AccountsViewController.create(with: connection) else { return }
        
        navigationController?.pushViewController(accountsVC, animated: true)
    }
}
