//
//  SEWebViewDelegate.swift
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
import WebKit

public protocol SEWebViewDelegate: NSObjectProtocol {
    /**
     Invoked when a callback is triggered from the Salt Edge Connect page.
     
     - parameters:
         - webView: The web view which displays the Salt Edge Connect page from which the callback is triggered.
         - response: The payload within the callback. It contains three keys: **connection_id**, **secret** and **state**. Note that if the connection is duplicated, you will receive a payload with the key **duplicated_connection_id** and the **state** being **error**. See an example response above.
     
     ```
     // usual response
     {
         "data": {
             "connection_id": 997671551,
             "secret": "Dk4WGvf71TMMp4ZQSodLa-n5Ay8WStFG0-gd-k2jPUM",
             "state": "success"
         }
     }
     // if the connection is duplicated
     {
         "data": {
             "duplicated_connection_id": 997674446,
             "state": "error"
         }
     }
     ```
     */
    func webView(_ webView: SEWebView, didReceiveCallbackWithResponse response: SEConnectResponse)

    /**
     Invoked when webView handle request urls from the Salt Edge Connect page.

     - parameters:
     - webView: The web view which displays the Salt Edge Connect page from which the callback is triggered.
     - url: The request url.
     */
    func webView(_ webView: SEWebView, didHandleRequestUrl url: URL)

    /**
     Invoked when a error occurs within the callback from the Salt Edge Connect page.
     
     - parameters:
         - webView: The web view which displays the Salt Edge Connect page from which the callback is triggered.
         - error: The error that has occured.
     */
    func webView(_ webView: SEWebView, didReceiveCallbackWithError error: Error)
}
