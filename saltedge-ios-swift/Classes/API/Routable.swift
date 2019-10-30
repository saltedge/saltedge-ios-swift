//
//  Routable.swift
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

struct APIEndpoints {
    static let rootURL: URL = URL(string: "https://www.saltedge.com")!
    static let baseURL: URL = rootURL.appendingPathComponent("api/v5")
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

protocol Routable {
    var method: HTTPMethod { get }
    var query: String { get }
    var headers: Headers { get }
    var parameters: ParametersEncodable? { get }
}

extension Routable {
    func asURLRequest() -> URLRequest {
        var request = URLRequest(url: url.appendingPathComponent(query))
        request.httpMethod = method.rawValue

        if let params = parameters {
            do {
                let encodedParams = try params.encode()
                if let url = request.url, let p = encodedParams as? [URLQueryItem] {
                    var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
                    components?.queryItems = p
                    request.url = components?.url
                } else if let p = encodedParams as? Data {
                    request.httpBody = p
                }
            } catch {
                print(error)
            }
        }

        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        return request
    }

    var url: URL {
        return APIEndpoints.baseURL
    }
}
