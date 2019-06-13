//
//  LocaleExtensions.swift
//  saltedge-ios_Example
//
//  Created by Alexander Petropavlovsky on 13/06/2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation

extension Locale {
    static var preferredLanguageCode: String {
        return String(Locale.preferredLanguages[0].prefix(2))
    }
}
