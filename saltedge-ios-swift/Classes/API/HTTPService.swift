//
//  HTTPService.swift
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
import TrustKit

/**
 Used to represent whether a request was successful or encountered an error.

 - **success:** The request and all post processing operations were successful resulting in the serialization of the
            provided associated value.

 - **failure:** The request encountered an error resulting in a failure. The associated values are the original data
            provided by the server as well as the error that caused the failure.
 */
public enum SEResult<T: Decodable> {
    case success(T)
    case failure(Error)
}

struct SessionManager {
    static var shared: URLSession {
        guard sharedManager == nil else { return sharedManager }
        
        initializeManager()
        return sharedManager
    }
    
    private static var sharedManager: URLSession!
    
    static func initializeManager(isSSLPinningEnabled: Bool = true) {
        sharedManager = createSession(isSSLPinningEnabled: isSSLPinningEnabled)
    }
    
    static func createSession(isSSLPinningEnabled: Bool = true) -> URLSession {
        let config: URLSessionConfiguration = .default
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
    
        return URLSession(
            configuration: config,
            delegate: URLSessionPinningDelegate(isSSLPinningEnabled: isSSLPinningEnabled),
            delegateQueue: nil
        )
    }
}

private class URLSessionPinningDelegate: NSObject, URLSessionDelegate {
    let isSSLPinningEnabled: Bool
    
    init(isSSLPinningEnabled: Bool) {
        self.isSSLPinningEnabled = isSSLPinningEnabled
        super.init()
    }
  
    func urlSession(_ session: URLSession,
                    didReceive challenge: URLAuthenticationChallenge,
                    completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Swift.Void) {
        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust,
            let serverTrust = challenge.protectionSpace.serverTrust {
            
            guard isSSLPinningEnabled else {
                completionHandler(.useCredential, URLCredential(trust: serverTrust))
                return
            }
            
            if !TrustKit.sharedInstance().pinningValidator.handle(challenge, completionHandler: completionHandler) {
                completionHandler(.performDefaultHandling, nil)
            }
        }
    }
}

/**
 ## Example Usage
 ```
 switch response {
     case .success(let value):
         print(value.data) // Contains returned and serialized data from server
         pirnt(value.meta) // *optional* Contains serialized meta returned from server
     case .failure(let error): print(error) // SEError if request failed
 }
 ```
 */
public typealias SEHTTPResponse<T: Decodable> = ((SEResult<SEResponse<T>>) -> Void)?

struct HTTPPaginatedService<T: Decodable> {
    static func makeRequest(_ request: Routable, container: [T] = [], nextPage: String? = nil, completion: SEHTTPResponse<[T]>) {
        var urlRequest = request.asURLRequest()

        if let nextPageParams = nextPage {
            urlRequest.url = URL(string: nextPageParams, relativeTo: APIEndpoints.rootURL)
        }
        
        HTTPService<[T]>.makeRequest(urlRequest) { response in
            switch response {
            case .success(let value):
                var mutableContainer = container
                mutableContainer.append(contentsOf: value.data)
                if let meta = value.meta, let _ = meta.nextId, let nextPage = meta.nextPage {
                    makeRequest(request, container: mutableContainer, nextPage: nextPage, completion: completion)
                } else {
                    let response = SEResponse(data: mutableContainer, meta: value.meta)
                    completion?(.success(response))
                }
            case .failure(let error):
                completion?(.failure(error))
            }
        }
    }
}

struct HTTPService<T: Decodable> {
    static func makeRequest(_ request: Routable, completion: SEHTTPResponse<T>) {
        let urlRequest = request.asURLRequest()
        
        makeRequest(urlRequest, completion: completion)
    }

    static func makeRequest(_ request: URLRequest, completion: SEHTTPResponse<T>) {
        let task = SessionManager.shared.dataTask(with: request) { data, response, error in
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategyFormatters = [DateFormatter.yyyyMMdd, DateFormatter.iso8601DateTime]
            
            let (data, error) = handleResponse(from: data, error: error, decoder: decoder)
            
            guard let jsonData = data, error == nil else {
                DispatchQueue.main.async { completion?(.failure(error!)) }
                return
            }

            do {
                let model = try decoder.decode(SEResponse<T>.self, from: jsonData)
                DispatchQueue.main.async { completion?(.success(model)) }
            } catch {
                DispatchQueue.main.async { completion?(.failure(error)) }
            }
        }

        TrustKitHelper.setup { error in
            if let error = error {
                completion?(.failure(error))
            } else {
                task.resume()
            }
        }
    }
}

func handleResponse(from data: Data?, error: Error?, decoder: JSONDecoder) -> (Data?, Error?) {
    if let error = error {
        return (nil, error)
    }
    
    guard let jsonData = data else {
        // -1017 -- The connection cannot parse the server’s response.
        let error = NSError(domain: "", code: -1017, userInfo: [NSLocalizedDescriptionKey : "Data was not retrieved from request"]) as Error
        return (nil, error)
    }
    
    if let error = try? decoder.decode(SEError.self, from: jsonData) {
        let err = NSError(domain: error.errorClass, code: 0, userInfo: [NSLocalizedDescriptionKey : error.errorMessage]) as Error
        return (jsonData, err)
    }
    
    return (jsonData, nil)
}

private extension JSONDecoder {
    var dateDecodingStrategyFormatters: [DateFormatter]? {
        get {
            return nil
        }
        set {
            guard let formatters = newValue else { return }

            self.dateDecodingStrategy = .custom { decoder in
                let container = try decoder.singleValueContainer()
                let dateString = try container.decode(String.self)

                for formatter in formatters {
                    if let date = formatter.date(from: dateString) {
                        return date
                    }
                }

                throw DecodingError.dataCorruptedError(in: container, debugDescription: "Cannot decode date string \(dateString)")
            }
        }
    }
}
