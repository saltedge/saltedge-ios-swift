//
//  ProviderCell.swift
//  saltedge-ios_Example
//
//  Created by Alexander Petropavlovsky on 13/06/2019.
//  Copyright (c) 2020 Salt Edge. All rights reserved.
//

import UIKit
import SDWebImageSVGKitPlugin
import SVGKit
import SaltEdge

class ProviderCell : UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var logoImageView: SVGKFastImageView!
    
    var provider: SEProvider? = nil {
        didSet {
            updateUI()
        }
    }
    
    private func updateUI() {
        guard let provider = provider else { return }

        titleLabel.text = provider.name

        if let logoUrl = URL(string: provider.logoURL) {
            logoImageView.sd_setImage(with: logoUrl, completed: nil)
        }
    }
}
