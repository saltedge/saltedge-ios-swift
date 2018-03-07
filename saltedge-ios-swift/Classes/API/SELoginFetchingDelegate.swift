//
//  SELoginFetchingDelegate.swift
//
//  Copyright (c) 2018 Salt Edge. https://saltedge.com
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
 SELoginFetchingDelegate is a protocol that is used to notify a delegate about events that are occuring in the process while some login actions are being performed (create, refresh, reconnect). Such events are: login required interactive credentials, login failed to fetch, login started fetching, login cannot be fetched and login failed to fetch.
 */
public protocol SELoginFetchingDelegate: class {
    /**
     This message is sent to the delegate when the login failed to fetch for some reason.
     
     - parameters:
         - login: The login which failed to fetch.
         - message: The reason why the login failed to fetch.
     */
    func failedToFetch(login: SELogin?, message: String)
    
    /**
     This message is sent to the delegate when the login has required interactive user input.
     Look for the requested fields in login's interactiveFieldsNames property.
     
     - parameter login: The login which requested interactive credentials input.
     */
    func interactiveInputRequested(for login: SELogin)
    
    /**
     This message is sent to the delegate when the login successfully finishes fetching.
     
     - parameter login: The login which was successfully connected and finished fetching.
     */
    func successfullyFinishedFetching(login: SELogin)
}
