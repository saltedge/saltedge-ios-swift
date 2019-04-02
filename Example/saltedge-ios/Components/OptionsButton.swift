//
//  OptionsButton.swift
//  saltedge-ios_Example
//
//  Created by Vlad Somov.
//  Copyright (c) 2019 Salt Edge. All rights reserved.
//

import UIKit
import SaltEdge

final class OptionsButton: UIButton {
    let availableOptions: [SEProviderFieldOption]
    let fieldName: String
    init(availableOptions: [SEProviderFieldOption], fieldName: String) {
        self.availableOptions = availableOptions
        self.fieldName = fieldName
        super.init(frame: .zero)
        setTitleColor(UIColor.blue, for: .normal)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
