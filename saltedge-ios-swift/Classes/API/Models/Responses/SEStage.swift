//
//  SEStage.swift
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

public struct SEStage: Codable {
    public let createdAt: Date
    public let id: String
    public let interactiveFieldsNames: [String]?
    public let interactiveFieldsOptions: [String: Any]?
    public let interactiveHtml: String?
    public let name: String
    public let updatedAt: Date

    enum CodingKeys: String, CodingKey {
        case createdAt = "created_at"
        case id = "id"
        case interactiveFieldsNames = "interactive_fields_names"
        case interactiveFieldsOptions = "interactive_fields_options"
        case interactiveHtml = "interactive_html"
        case name = "name"
        case updatedAt = "updated_at"
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.id, forKey: .id)
        try container.encodeIfPresent(self.createdAt, forKey: .createdAt)
        try container.encodeIfPresent(self.updatedAt, forKey: .updatedAt)
        try container.encodeIfPresent(self.interactiveFieldsNames, forKey: .interactiveFieldsNames)
        try container.encodeIfPresent(self.interactiveFieldsOptions, forKey: .interactiveFieldsOptions)
        try container.encodeIfPresent(self.interactiveHtml, forKey: .interactiveHtml)
        try container.encodeIfPresent(self.name, forKey: .name)
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        createdAt = try container.decode(Date.self, forKey: .createdAt)
        updatedAt = try container.decode(Date.self, forKey: .updatedAt)
        interactiveFieldsNames = try? container.decodeIfPresent([String].self, forKey: .interactiveFieldsNames)
        interactiveFieldsOptions = try? container.decodeIfPresent([String: Any].self, forKey: .interactiveFieldsOptions)
        interactiveHtml = try? container.decodeIfPresent(String.self, forKey: .interactiveHtml)
        name = try container.decode(String.self, forKey: .name)
    }
}
