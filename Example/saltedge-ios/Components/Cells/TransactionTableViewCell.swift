//
//  TransactionTableViewCell.swift
//  saltedge-ios_Example
//
//  Created by Vlad Somov.
//  Copyright (c) 2019 Salt Edge. All rights reserved.
//

import UIKit
import SaltEdge

final class TransactionTableViewCell: UITableViewCell {
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
    let amountFormatter: NumberFormatter = {
        let amountFormatter = NumberFormatter()
        amountFormatter.numberStyle = .currency
        return amountFormatter
    }()
    
    func set(with transaction: SETransaction) {
        descriptionLabel.text = transaction.description
        dateLabel.text = DateFormatter.localizedString(from: transaction.madeOn, dateStyle: .medium, timeStyle: .none)
        amountFormatter.currencyCode = transaction.currencyCode
        amountLabel.text = amountFormatter.string(from: NSNumber(value: transaction.amount))
    }
}
