//
//  URLExtensions.swift
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

extension URL {
    var queryParameters: [String: String]? {
        guard let components = URLComponents(url: self, resolvingAgainstBaseURL: true), let queryItems = components.queryItems else {
            return nil
        }
        
        var parameters = [String: String]()
        for item in queryItems {
            parameters[item.name] = item.value
        }
        
        return parameters
    }
}

// MARK: SEWebView URL extensions
extension URL {
    /**
     Determines whether a URL object is a Salt Edge Connect callback URL.
     
     **YES** if the URL object has the scheme equal to *seCallbackScheme* and the host equal to *seCallbackHost*, otherwise returns **NO**.
     */
    var isCallback: Bool {
        return self.scheme == seCallbackScheme && self.host == seCallbackHost
    }
    
    /**
     Provided the URL object is a Salt Edge Connect callback URL, this method will return the payload within the callback, if any.
     
     returns **SEConnectResponse** object containing the callback parameters or an **Error**.
     */
    var callbackParameters: (SEConnectResponse?, Error?) {
        guard let decodedString = lastPathComponent.removingPercentEncoding else { return (nil, NSError(domain: "Cannot remove percent encoding", code: 0, userInfo: nil) as Error) }
        
        let jsonData = decodedString.data(using: .utf8)
        
        let decoder = JSONDecoder()
        
        let (data, error) = handleResponse(from: jsonData, error: nil, decoder: decoder)
        
        if let data = data, error == nil {
            do {
                let tokenResponse = try decoder.decode(SEResponse<SEConnectResponse>.self, from: data)
                return (tokenResponse.data, nil)
            } catch {
                return (nil, error)
            }
        }
        
        return (nil, error)
    }
}
