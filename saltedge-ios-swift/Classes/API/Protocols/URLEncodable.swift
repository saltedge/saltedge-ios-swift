//
//  URLEncodable.swift
//
//  Copyright (c) 2019 Salt Edge. https://saltedge.com
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

import Foundation

protocol URLEncodable: DictionaryRepresentable {
    func encode() -> Any
}

extension URLEncodable {
    func encode() -> Any {
        return self.dictionaryRepresentation.map { (key, value) in URLQueryItem(name: key, value: "\(value)") }
    }
}

protocol DictionaryRepresentable {
    var dictionaryRepresentation: [String: Any] { get }
}

extension DictionaryRepresentable {
    var dictionaryRepresentation: [String: Any] {
        let mirror = Mirror(reflecting: self)
        var result: [String: Any] = [:]
        
        for attribute in mirror.children {
            if let label = attribute.label,
                let value = unwrap(attribute.value) {
                result[label.toSnakeCase] = value
            }
        }
        return result
    }
    
    private func unwrap(_ any: Any) -> Any? {
        let mi = Mirror(reflecting: any)
        if mi.displayStyle != .optional {
            return any
        }
        if mi.children.count == 0 {
            return nil
        }
        let (_, value) = mi.children.first!
        return value
    }
}

private extension String {
    var toSnakeCase: String {
        var result = self
        for char in result.unicodeScalars {
            if CharacterSet.uppercaseLetters.contains(char) {
                result = result.replacingOccurrences(of: "\(char)", with: "_\(char)".lowercased())
            }
        }
        return result
    }
}


