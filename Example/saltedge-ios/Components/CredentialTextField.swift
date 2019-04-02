//
//  CredentialTextField.swift
//  saltedge-ios_Example
//
//  Created by Vlad Somov.
//  Copyright (c) 2019 Salt Edge. All rights reserved.
//

import UIKit

final class CredentialTextField: UITextField {
    private(set) var fieldName: String
    
    init(placeholder: String, fieldName: String) {
        self.fieldName = fieldName
        super.init(frame: .zero)
        self.placeholder = placeholder
        autocapitalizationType = .none
        borderStyle = .roundedRect
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
