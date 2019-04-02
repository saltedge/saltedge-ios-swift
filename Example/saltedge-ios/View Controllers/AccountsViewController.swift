//
//  AccountsViewController.swift
//  saltedge-ios_Example
//
//  Created by Vlad Somov.
//  Copyright (c) 2019 Salt Edge. All rights reserved.
//

import UIKit
import SaltEdge
import PKHUD

final class AccountsViewController: UIViewController {
    private enum ConnectAction {
        case reconnect
        case refresh
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    private var accounts: [SEAccount] = []
    private var connection: SEConnection!
    private var connectionProvider: SEProvider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "AccountCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = connection.providerName
        reloadAccounts()
    }
    
    @IBAction func actionsPressed(_ sender: Any) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let remove = UIAlertAction(title: "Remove", style: .destructive) { [weak self] action in
            self?.removeConnection()
        }
        let reconnect = UIAlertAction(title: "Reconnect", style: .default) { [weak self] action in
            self?.chooseMethodFotAction(for: .reconnect)
        }
        let refresh = UIAlertAction(title: "Refresh", style: .default) { [weak self] action in
            self?.chooseMethodFotAction(for: .refresh)
        }
        let viewAttempts = UIAlertAction(title: "View Attempts", style: .default) { [weak self] action in
            guard let weakSelf = self, let attemtsVC = AttemptsViewController.create(connectionSecret: weakSelf.connection.secret) else { return }
            
            weakSelf.navigationController?.pushViewController(attemtsVC, animated: true)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        for action in [remove, reconnect, refresh, viewAttempts, cancel] {
            actionSheet.addAction(action)
        }
        
        present(actionSheet, animated: true)
    }
    
    private func removeConnection() {
        HUD.show(.labeledProgress(title: "Removing connection", subtitle: nil))
        
        SERequestManager.shared.removeConnection(with: connection.secret) { [weak self] response in
            switch response {
            case .success(let value):
                guard let weakSelf = self else { return }
                if value.data.removed {
                    var connections = UserDefaultsHelper.connections
                    if let index = connections?.firstIndex(of: weakSelf.connection.secret) {
                        connections?.remove(at: index)
                        UserDefaultsHelper.connections = connections
                    }
                    weakSelf.navigationController?.popViewController(animated: true)
                }
                HUD.hide(animated: true)
            case .failure(let error):
                HUD.flash(.labeledError(title: "Error", subtitle: error.localizedDescription), delay: 3.0)
            }
        }
    }

    private func chooseMethodFotAction(for connectAction: ConnectAction) {
        let actionSheet = UIAlertController(title: "Choose a method for action", message: nil, preferredStyle: .alert)
        let webViewActions = UIAlertAction(title: "Web View", style: .default) { [weak self] action in
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate, let connectVC = appDelegate.connectViewController else { return }
            
            connectVC.requestToken(connection: self?.connection, refresh: connectAction == .refresh)
            self?.tabBarController?.selectedIndex = 0
        }
        let apiAction = UIAlertAction(title: "API", style: .default) { [weak self] action in
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate, let createVC = appDelegate.createViewController else { return }
            
            if connectAction == .reconnect {
                createVC.connection = self?.connection
                self?.tabBarController?.selectedIndex = 1
            } else {
               self?.refreshConnectionUsingAPI()
            }
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        for action in [webViewActions, apiAction, cancel] {
            actionSheet.addAction(action)
        }
        
        present(actionSheet, animated: true)
    }
    
    private func reloadAccounts() {
        HUD.show(.labeledProgress(title: "Fetching Accounts", subtitle: nil))
        SERequestManager.shared.getProvider(code: connection.providerCode) { response in
            switch response {
            case .success(let value):
                self.connectionProvider = value.data
                self.requestAccounts()
            case .failure(let error):
                HUD.flash(.labeledError(title: "Error", subtitle: error.localizedDescription), delay: 3.0)
            }
        }
    }
    
    private func requestAccounts() {
        SERequestManager.shared.getAllAccounts(for: connection.secret, params: nil) { [weak self] response in
            switch response {
            case .success(let value):
                self?.accounts = value.data
                self?.tableView.reloadData()
                HUD.hide(animated: true)
            case .failure(let error):
                HUD.flash(.labeledError(title: "Error", subtitle: error.localizedDescription), delay: 3.0)
            }
        }
    }
    
    private func refreshConnectionUsingAPI() {
        HUD.show(.labeledProgress(title: "Refreshing...", subtitle: nil))

        let params = SEConnectionRefreshParams(attempt: SEAttempt(returnTo: AppDelegate.applicationURLString))

        SERequestManager.shared.refreshConnection(
            with: connection.secret,
            params: connectionProvider.isOAuth ? params :nil,
            fetchingDelegate: self
        ) { response in
            switch response {
            case .success(let value):
                // Nothing here. Need to wait for SEconnectionFetchingDelegate callbacks
                print(value.data)
            case .failure(let error):
                HUD.flash(.labeledError(title: "Error", subtitle: error.localizedDescription), delay: 3.0)
                print(response)
            }
        }
    }
}

extension AccountsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accounts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "AccountCell")
        
        let account = accounts[indexPath.row]
        
        cell.textLabel?.text = account.name
        cell.detailTextLabel?.text = "\(account.balance) \(account.currencyCode.uppercased())"
        
        return cell
    }
}

extension AccountsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let account = accounts[indexPath.row]
        guard let transactionsVC = TransactionsViewController.create(with: connection.secret, account: account) else { return }
        
        navigationController?.pushViewController(transactionsVC, animated: true)
    }
}


extension AccountsViewController {
    static func create(with connection: SEConnection) -> AccountsViewController? {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        guard let vc = storyboard.instantiateViewController(withIdentifier: "AccountsViewController") as? AccountsViewController else { return nil }
        
        vc.connection = connection
        
        return vc
    }
}

extension AccountsViewController: SEConnectionFetchingDelegate {
    func failedToFetch(connection: SEConnection?, message: String) {
        HUD.flash(.labeledError(title: "Error", subtitle: message), delay: 3.0)
    }
    
    func interactiveInputRequested(for connection: SEConnection) {
        // not possible, we only refresh connections here in this view controller
    }
    
    func successfullyFinishedFetching(connection: SEConnection) {
        self.connection = connection
        reloadAccounts()
    }
}
