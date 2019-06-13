//
//  ProviderCell.swift
//  saltedge-ios_Example
//
//  Created by Alexander Petropavlovsky on 13/06/2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import SVGKit
import SaltEdge
import SDWebImageSVGCoder

class ProviderCell : UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var logoImageView: SVGKFastImageView!
    
    var provider: SEProvider? = nil {
        didSet {
            updateUI()
        }
    }
    
    private func updateUI() {
        titleLabel.text = provider?.name
//        logoImageView.sd_adjustContentMode = true // make `contentMode` works
        logoImageView.sd_setImage(with: provider?.logoURL, completed: nil)
    }
}
