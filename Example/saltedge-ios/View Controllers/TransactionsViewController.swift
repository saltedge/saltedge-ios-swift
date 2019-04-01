//
//  TransactionsViewController.swift
//  saltedge-ios_Example
//
//  Created by Vlad Somov.
//  Copyright (c) 2019 Salt Edge. All rights reserved.
//

import UIKit
import SaltEdge
import PKHUD

final class TransactionsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    private var transactions: [SETransaction] = []
    private var connectionSecret: String!
    private var account: SEAccount!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = account.name
        requestTransactions()
    }
    
    func requestTransactions() {
        HUD.show(.labeledProgress(title: "Fetching Transactions", subtitle: nil))
        let params = SETransactionParams(accountId: account.id)
        SERequestManager.shared.getAllTransactions(for: connectionSecret, params: params) { [weak self] response in
            switch response {
            case .success(let value):
                self?.transactions = value.data
                self?.tableView.reloadData()
                HUD.hide(animated: true)
            case .failure(let error):
                HUD.flash(.labeledError(title: "Error", subtitle: error.localizedDescription), delay: 3.0)
            }
        }
    }
}

extension TransactionsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionCell", for: indexPath) as? TransactionTableViewCell else { return UITableViewCell() }
        
        let transaction = transactions[indexPath.row]
        
        cell.set(with: transaction)
        cell.selectionStyle = .none

        return cell
    }
}

extension TransactionsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95.0
    }
}

extension TransactionsViewController {
    static func create(with connectionSecret: String, account: SEAccount) -> TransactionsViewController? {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        guard let vc = storyboard.instantiateViewController(withIdentifier: "TransactionsViewController") as? TransactionsViewController else { return nil }
        
        vc.connectionSecret = connectionSecret
        vc.account = account
        
        return vc
    }
}

