//
//  SEConnectResponse.swift
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

public struct SEConnectResponse: Decodable {
    public enum Stage: String, Decodable {
        /** Fetching data is in progress */
        case fetching
        /** A change in the data we store for the connection has occured */
        case success
        /** An error has occured during fetching process */
        case error
    }
    
    public let connectionId: String?
    public let duplicatedConnectionId: String?
    public let stage: Stage
    public let secret: String?
    public let customFields: [String: String]?
    
    private enum CodingKeys: String, CodingKey {
        case connectionId = "connection_id"
        case duplicatedConnectionId = "duplicated_connection_id"
        case stage
        case secret
        case customFields = "custom_fields"
    }
}
