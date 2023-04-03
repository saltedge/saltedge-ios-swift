//
//  CodableExtensions.swift
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

struct JSONCodingKeys: CodingKey {
    var stringValue: String
    var intValue: Int?

    init?(stringValue: String) {
        self.stringValue = stringValue
    }

    init?(intValue: Int) {
        self.init(stringValue: "\(intValue)")
        self.intValue = intValue
    }
}

// MARK: - Decoding Extensions
public extension KeyedDecodingContainer {
    func decode(_ type: [String: Any].Type, forKey key: K) throws -> [String: Any] {
        let container = try self.nestedContainer(keyedBy: JSONCodingKeys.self, forKey: key)
        return try container.decode(type)
    }

    func decode(_ type: [[String: Any]].Type, forKey key: K) throws -> [[String: Any]] {
        var container = try self.nestedUnkeyedContainer(forKey: key)
        if let decodedData = try container.decode([Any].self) as? [[String: Any]] {
            return decodedData
        } else {
            return []
        }
    }

    func decodeIfPresent(_ type: [String: Any].Type, forKey key: K) throws -> [String: Any]? {
        guard contains(key) else {
            return nil
        }

        guard try decodeNil(forKey: key) == false else {
            return nil
        }

        return try decode(type, forKey: key)
    }

    func decode(_ type: [Any].Type, forKey key: K) throws -> [Any] {
        var container = try self.nestedUnkeyedContainer(forKey: key)
        return try container.decode(type)
    }

    func decodeIfPresent(_ type: [Any].Type, forKey key: K) throws -> [Any]? {
        guard contains(key) else {
            return nil
        }

        guard try decodeNil(forKey: key) == false else {
            return nil
        }

        return try decode(type, forKey: key)
    }

    func decode(_ type: [String: Any].Type) throws -> [String: Any] {
        var dictionary = [String: Any]()
        for key in allKeys {
            if let boolValue = try? decode(Bool.self, forKey: key) {
                dictionary[key.stringValue] = boolValue
            } else if let stringValue = try? decode(String.self, forKey: key) {
                dictionary[key.stringValue] = stringValue
            } else if let intValue = try? decode(Int.self, forKey: key) {
                dictionary[key.stringValue] = intValue
            } else if let doubleValue = try? decode(Double.self, forKey: key) {
                dictionary[key.stringValue] = doubleValue
            } else if let nestedDictionary = try? decode(Dictionary<String, Any>.self, forKey: key) {
                dictionary[key.stringValue] = nestedDictionary
            } else if let nestedArray = try? decode(Array<Any>.self, forKey: key) {
                dictionary[key.stringValue] = nestedArray
            }
        }
        return dictionary
    }
}

public extension UnkeyedDecodingContainer {
    mutating func decode(_ type: [Any].Type) throws -> [Any] {
        var array: [Any] = []
        while isAtEnd == false {
            // See if the current value in the JSON array is `null` first and prevent infite recursion with nested arrays.
            if try decodeNil() {
                continue
            } else if let value = try? decode(Bool.self) {
                array.append(value)
            } else if let value = try? decode(Double.self) {
                array.append(value)
            } else if let value = try? decode(String.self) {
                array.append(value)
            } else if let nestedDictionary = try? decode(Dictionary<String, Any>.self) {
                array.append(nestedDictionary)
            } else if let nestedArray = try? decode(Array<Any>.self) {
                array.append(nestedArray)
            }
        }
        return array
    }

    mutating func decode(_ type: [String: Any].Type) throws -> [String: Any] {
        let nestedContainer = try self.nestedContainer(keyedBy: JSONCodingKeys.self)
        return try nestedContainer.decode(type)
    }
}

// MARK: - Encoding Extensions
extension KeyedEncodingContainer {
    mutating func encodeIfPresent(_ value: [String: Any]?, forKey key: KeyedEncodingContainer<K>.Key) throws {
        guard let safeValue = value, !safeValue.isEmpty else {
            return
        }
        var container = self.nestedContainer(keyedBy: JSONCodingKeys.self, forKey: key)
        for item in safeValue {
            guard let key = JSONCodingKeys(stringValue: item.key) else {
                continue
            }

            if let val = item.value as? Int {
                try container.encodeIfPresent(val, forKey: key)
            } else if let val = item.value as? String {
                try container.encodeIfPresent(val, forKey: key)
            } else if let val = item.value as? Double {
                try container.encodeIfPresent(val, forKey: key)
            } else if let val = item.value as? Float {
                try container.encodeIfPresent(val, forKey: key)
            } else if let val = item.value as? Bool {
                try container.encodeIfPresent(val, forKey: key)
            } else if let val = item.value as? [Any] {
                try container.encodeIfPresent(val, forKey: key)
            } else if let val = item.value as? [String: Any] {
                try container.encodeIfPresent(val, forKey: key)
            }
        }
    }

    mutating func encodeIfPresent(_ value: [Any]?, forKey key: KeyedEncodingContainer<K>.Key) throws {
        guard let safeValue = value else {
            return
        }
        if let val = safeValue as? [Int] {
            try self.encodeIfPresent(val, forKey: key)
        } else if let val = safeValue as? [String] {
            try self.encodeIfPresent(val, forKey: key)
        } else if let val = safeValue as? [Double] {
            try self.encodeIfPresent(val, forKey: key)
        } else if let val = safeValue as? [Float] {
            try self.encodeIfPresent(val, forKey: key)
        } else if let val = safeValue as? [Bool] {
            try self.encodeIfPresent(val, forKey: key)
        } else if let val = value as? [[String: Any]] {
            var container = self.nestedUnkeyedContainer(forKey: key)
            try container.encode(contentsOf: val)
        }
    }
}

extension UnkeyedEncodingContainer {
    mutating func encode(contentsOf sequence: [[String: Any]]) throws {
        for dict in sequence {
            try self.encodeIfPresent(dict)
        }
    }

    mutating func encodeIfPresent(_ value: [String: Any]) throws {
        var container = self.nestedContainer(keyedBy: JSONCodingKeys.self)
        for item in value {
            guard let key = JSONCodingKeys(stringValue: item.key) else {
                continue
            }
            if let val = item.value as? Int {
                try container.encodeIfPresent(val, forKey: key)
            } else if let val = item.value as? String {
                try container.encodeIfPresent(val, forKey: key)
            } else if let val = item.value as? Double {
                try container.encodeIfPresent(val, forKey: key)
            } else if let val = item.value as? Float {
                try container.encodeIfPresent(val, forKey: key)
            } else if let val = item.value as? Bool {
                try container.encodeIfPresent(val, forKey: key)
            } else if let val = item.value as? [Any] {
                try container.encodeIfPresent(val, forKey: key)
            } else if let val = item.value as? [String: Any] {
                try container.encodeIfPresent(val, forKey: key)
            }
        }
    }
}
