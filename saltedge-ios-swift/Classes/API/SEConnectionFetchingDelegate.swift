//
//  SEConnectionFetchingDelegate.swift
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

/**
 SEConnectionFetchingDelegate is a protocol that is used to notify a delegate about events that are occuring in the process while some connection actions are being performed (create, refresh, reconnect). Such events are: connection required interactive credentials, connection failed to fetch, connection started fetching, connection cannot be fetched and connection failed to fetch.
 */
public protocol SEConnectionFetchingDelegate: class {
    /**
     This message is sent to the delegate when the connection failed to fetch for some reason.
     
     - parameters:
         - connection: The connection which failed to fetch.
         - message: The reason why the connection failed to fetch.
     */
    func failedToFetch(connection: SEConnection?, message: String)
    
    /**
     This message is sent to the delegate when the connection has required interactive user input.
     Look for the requested fields in connection interactiveFieldsNames property.
     
     - parameter connection: The connection which requested interactive credentials input.
     */
    func interactiveInputRequested(for connection: SEConnection)
    
    /**
     This message is sent to the delegate when the connection successfully finishes fetching.
     
     - parameter connection: The connection which was successfully connected and finished fetching.
     */
    func successfullyFinishedFetching(connection: SEConnection)
}
