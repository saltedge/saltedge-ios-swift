//
//  SERequestManager.swift
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

public class SERequestManager {
    // MARK: Setup
    private init() {}

    public static let shared = SERequestManager()
    
    public func set(sslPinningEnabled: Bool) {
        SessionManager.initializeManager(isSSLPinningEnabled: sslPinningEnabled)
    }
    
    /**
     Links your Client ID and App Secret to the request manager. All outgoing requests will have the proper app-related HTTP headers set by default.
     
     - parameters:
         - appSecret: The App Secret of the app.
         - clientId: The ID of the client.
     */
    public func set(appId: String, appSecret: String) {
        SEHeaders.cached.set(appId: appId, appSecret: appSecret)
    }
    
    /**
     Links your Customer Secret to the request manager. All outgoing requests related to Connections will have the proper customer-related HTTP headers set by default.
     
     - parameters:
         - customerSecret: The string identifying the customer.
     
     [Salt Edge API Reference](https://docs.saltedge.com/reference/#customers-create)
     */
    public func set(customerSecret: String) {
        SEHeaders.cached.set(customerSecret: customerSecret)
    }

    // MARK: Providers
    /**
     Fetches a set of providers based on given parameters.

     - parameters:
         - params: Optional constraints set to the fetch query.
         - completion: The code to be executed once the request has finished.
     
     ```
     let params = SEProviderParams(fromId: 108)
     SERequestManager.shared.getProviders(with: params) { response in
         switch response {
             case .success(let value): print(value)
             case .failure(let error): print(error)
         }
     }
     ```

     [Salt Edge API Reference](https://docs.saltedge.com/reference/#providers-list)
     */
    public func getProviders(with params: SEProviderParams? = nil, completion: SEHTTPResponse<[SEProvider]>) {
        HTTPService<[SEProvider]>.makeRequest(ProviderRouter.list(params), completion: completion)
    }
    
    /**
     Fetches the whole providers list.
     
     - parameters:
         - params: Optional constraints set to the fetch query.
         - completion: The code to be executed once the request has finished.
     
     [Salt Edge API Reference](https://docs.saltedge.com/reference/#providers-list)
     */
    public func getAllProviders(with params: SEProviderParams? = nil, completion: SEHTTPResponse<[SEProvider]>) {
        HTTPPaginatedService<SEProvider>.makeRequest(ProviderRouter.list(params), completion: completion)
    }
    
    /**
     Fetches a certain provider.
     
     - parameters:
         - code: The code of the provider that will be fetched.
         - completion: The code to be executed once the request has finished.

     - warning: **code** cannot be nil.
     
     [Salt Edge API Reference](https://docs.saltedge.com/reference/#providers-show)
     */
    public func getProvider(code: String, completion: SEHTTPResponse<SEProvider>) {
        HTTPService<SEProvider>.makeRequest(ProviderRouter.show(code), completion: completion)
    }
    
    // MARK: Countries
    /**
     Fetches full Countries list
     
     - parameters:
         - completion: The code to be executed once the request has finished.
     
     [Salt Edge API Reference](https://docs.saltedge.com/reference/#countries-list)
     */
    public func getCountries(completion: SEHTTPResponse<[SECountry]>) {
        HTTPService<[SECountry]>.makeRequest(CountryRouter.list, completion: completion)
    }
    
    // MARK: Customer
    /**
     Creates a new customer or returns an error if such customer exists.
     
     - parameters:
         - params: Parameters needed to create new customer.
         - completion: The code to be executed once the request has finished.
     
     [Salt Edge API Reference](https://docs.saltedge.com/reference/#customers-create)
     */
    public func createCustomer(with params: SECustomerParams, completion: SEHTTPResponse<SECustomer>) {
        HTTPService<SECustomer>.makeRequest(CustomerRouter.create(params), completion: completion)
    }
    
    // MARK: Connection
    /**
     Creates a connection with given parameters.
     
     - parameters:
         - params: The parameters of the connection that is to be created.
         - fetchingDelegate: The delegate of the connection creation process that can respond to certain events.
         - completion: The code to be executed once the request has finished.


     [Salt Edge API Reference](https://docs.saltedge.com/reference/#logins-create)
     */
    public func createConnection(with params: SEConnectionParams, fetchingDelegate: SEConnectionFetchingDelegate, completion: SEHTTPResponse<SEConnection>) {
        SEConnectionFetcher.createConnection(with: params, fetchingDelegate: fetchingDelegate, completion: completion)
    }
    
    /**
     Update status, store_credentials or daily_refresh of the connection.

     - parameters:
        - params: The parameters of the connection that is to be updated.
        - id: The id of connection, which status is to be updated.
        - secret: The secret of the connection which status is to be updated.
        - fetchingDelegate: The delegate of the connection creation process that can respond to certain events.
        - completion: The code to be executed once the request has finished.

     [Salt Edge API Reference](https://docs.saltedge.com/reference/#logins-create)
     */
    public func updateConnectionUpdateStatus(with params: SEConnectionUpdateStatusParams, id: String, secret: String, fetchingDelegate: SEConnectionFetchingDelegate, completion: SEHTTPResponse<SEConnection>) {
        SEConnectionFetcher.updateConnectionStatus(with: params, id: id, secret: secret, fetchingDelegate: fetchingDelegate, completion: completion)
    }

    /**
     Fetches a connection with a given connection secret.
     
     - parameters:
         - connectionSecret: The secret of the connection which is to be fetched.
         - completion: The code to be executed once the request has finished.
     
     [Salt Edge API Reference](https://docs.saltedge.com/reference/#logins-show)
     */
    public func getConnection(with secret: String, completion: SEHTTPResponse<SEConnection>) {
        HTTPService<SEConnection>.makeRequest(ConnectionRouter.show(secret), completion: completion)
    }
    
    /**
     Reconnects a connection.
     
     - parameters:
         - secret: The secret of the connection which is to be reconnected.
         - params: The parameters of the connection that is to be reconnected.
         - completion: The code to be executed once the request has finished.
     
     - warning: **credentials** in SEReconnectSessionsParams cannot be nil.
     

     [Salt Edge API Reference](https://docs.saltedge.com/reference/#logins-reconnect)
     */
    public func reconnectConnection(with secret: String, with params: SEConnectionReconnectParams, fetchingDelegate: SEConnectionFetchingDelegate, completion: SEHTTPResponse<SEConnection>) {
        SEConnectionFetcher.reconnectConnection(secret: secret, params: params, fetchingDelegate: fetchingDelegate, completion: completion)
    }
    
    /**
     Provides an interactive connection with a set of credentials.
     
     - parameters:
         - secret: The secret of the connection which is to be connected.
         - params: The parameters of the connection that is to be connected using interactive step.
         - fetchingDelegate: The delegate of the connection creation process that can respond to certain events.
         - completion: The code to be executed once the request has finished.
     
     - warning: **credentials** in SEConnectionInteractiveParams cannot be nil.
     
     
     [Salt Edge API Reference](https://docs.saltedge.com/reference/#logins-interactive)
     */
    public func confirmConnection(with secret: String, params: SEConnectionInteractiveParams, fetchingDelegate: SEConnectionFetchingDelegate, completion: SEHTTPResponse<SEConnection>) {
        SEConnectionFetcher.interactiveConnection(with: params, secret: secret, fetchingDelegate: fetchingDelegate, completion: completion)
    }
    
    /**
     Refreshes a connection.
     
     - parameters:
         - secret: The secret of the connection which is to be refreshed.
         - params: The parameters of the connection that is to be refreshed.
         - fetchingDelegate: The delegate of the connection creation process that can respond to certain events.
         - completion: The code to be executed once the request has finished.

     - warning: Only automatic connection can be refreshed.
     
     [Salt Edge API Reference](https://docs.saltedge.com/reference/#logins-refresh)
     */
    public func refreshConnection(with secret: String, params: SEConnectionRefreshParams? = nil, fetchingDelegate: SEConnectionFetchingDelegate, completion: SEHTTPResponse<SEConnection>) {
        SEConnectionFetcher.refreshConnection(secret: secret, params: params, fetchingDelegate: fetchingDelegate, completion: completion)
    }

    /**
     Removes a connection from our system. All the associated accounts and transactions to that connection will be destroyed as well.

     - parameters:
         - secret: The secret of the connection which is to be removed.
         - completion: The code to be executed once the request has finished.
     
     
     [Salt Edge API Reference](https://docs.saltedge.com/reference/#logins-remove)
     */
    public func removeConnection(with secret: String, completion: SEHTTPResponse<SERemovedConnectionResponse>) {
        HTTPService<SERemovedConnectionResponse>.makeRequest(ConnectionRouter.remove(secret), completion: completion)
    }

    // MARK: OAuth Providers
    /**
     Creates an OAuth connection with given parameters.
     
     - parameters:
         - params: The parameters of the OAuth connection that is to be created.
         - completion: The code to be executed once the request has finished.
     
     [Salt Edge API Reference](https://docs.saltedge.com/account_information/v5/#oauth_providers-create)
     */
    public func createOAuthConnection(params: SECreateOAuthParams, completion: SEHTTPResponse<SEOAuthResponse>) {
        HTTPService<SEOAuthResponse>.makeRequest(OAuthRouter.create(params), completion: completion)
    }

    /**
     Authorizes an OAuth connection with given parameters.
     
     - parameters:
     - secret: The secret of the OAuth connection to authorize.
     - params: The parameters of the OAuth connection that is to be authorized.
     - completion: The code to be executed once the request has finished.
     
     [Salt Edge API Reference](https://docs.saltedge.com/account_information/v5/#oauth_providers-authorize)
     */
    public func authorizeOAuthConnection(with secret: String, params: SEAuthorizeOAuthParams, completion: SEHTTPResponse<SEConnection>) {
        HTTPService<SEConnection>.makeRequest(OAuthRouter.authorize(secret, params), completion: completion)
    }

    /**
     Reconnects an OAuth connection with given parameters.
     
     - parameters:
         - secret: The secret of the OAuth connection to reconnect.
         - params: The parameters of the OAuth connection that is to be reconnected.
         - completion: The code to be executed once the request has finished.
     
     [Salt Edge API Reference](https://docs.saltedge.com/account_information/v5/#oauth_providers-reconnect)
     */
    public func reconnectOAuthConnection(with secret: String, params: SEReconnectOAuthParams, completion: SEHTTPResponse<SEOAuthResponse>) {
        HTTPService<SEOAuthResponse>.makeRequest(OAuthRouter.reconnect(secret, params), completion: completion)
    }

    /**
     Handles a openURL call from your application delegate class when connecting an OAuth provider.
     
     - parameters:
         - url: The URL that was passed in the application:openURL:sourceApplication:annotation: method of your app delegate class.
         - connectionFetchingDelegate: The delegate of the connection creation process that can respond to certain events.
     */
    public func handleOpen(url: URL, connectionFetchingDelegate: SEConnectionFetchingDelegate) {
        guard let parameters = url.queryParameters else { return }
        
        if let errorMessage = parameters["error_message"] {
            if let connectionSecret = parameters["connection_secret"] {
                SERequestManager.shared.getConnection(with: connectionSecret) { response in
                    switch response {
                    case .success(let value):
                        connectionFetchingDelegate.failedToFetch(connection: value.data, message: errorMessage)
                    case .failure(_):
                        connectionFetchingDelegate.failedToFetch(connection: nil, message: errorMessage)
                    }
                }
            } else {
                connectionFetchingDelegate.failedToFetch(connection: nil, message: errorMessage)
            }
        } else {
            guard let connectionSecret = parameters["connection_secret"] else { return }

            SEConnectionFetcher.handleOAuthConnection(connectionSecret: connectionSecret, fetchingDelegate: connectionFetchingDelegate)
        }
    }
    
    // MARK: Connect Session
    /**
     Requests a Connect Session for connecting a Connection via a web view.
     
     - parameters:
         - params: The parameters that will go in the request payload.
         - completion: The code to be executed once the request has finished.
     
     [Salt Edge API Reference](https://docs.saltedge.com/account_information/v5/#connect_sessions-create)
     */
    public func createConnectSession(params: SEConnectSessionsParams, completion: SEHTTPResponse<SEConnectSessionResponse>) {
        HTTPService<SEConnectSessionResponse>.makeRequest(ConnectSessionsRouter.create(params), completion: completion)
    }
    
    /**
     Allows you to create a connect session, which will be used to access Salt Edge Connect to reconnect a connection.
     
     - parameters:
         - connectionSecret: The connection secret for which the Reconnect Session is requested.
         - params: The parameters that will go in the request payload.
         - completion: The code to be executed once the request has finished.
     
     [Salt Edge API Reference](https://docs.saltedge.com/account_information/v5/#connect_sessions-reconnect)
     */
    public func reconnectSession(with secret: String, params: SEReconnectSessionsParams, completion: SEHTTPResponse<SEConnectSessionResponse>) {
        HTTPService<SEConnectSessionResponse>.makeRequest(ConnectSessionsRouter.reconnect(secret, params), completion: completion)
    }
    
    /**
     Allows you to create a connect session, which will be used to access Salt Edge Connect to refresh a connection.
     
     - parameters:
         - connectionSecret: The connection secret for which the refresh token is requested.
         - params: The parameters that will go in the request payload.
         - completion: The code to be executed once the request has finished.
     
     [Salt Edge API Reference](https://docs.saltedge.com/account_information/v5/#connect_sessions-refresh)
     */
    public func refreshSession(with secret: String, params: SERefreshSessionsParams, completion: SEHTTPResponse<SEConnectSessionResponse>) {
        HTTPService<SEConnectSessionResponse>.makeRequest(ConnectSessionsRouter.refresh(secret, params), completion: completion)
    }

    // MARK: Account
    /**
     Fetches page of accounts tied to a connection.
     
     - parameters:
         - connectionSecret: The secret of the connection whose accounts are going to be fetched.
         - params: Optional constraints set to the fetch query. You can set **from_id** to fetch paginated results manually. **next_id** could be obtained from response meta.
         - completion: The code to be executed once the request has finished.
     
     [Salt Edge API Reference](https://docs.saltedge.com/account_information/v5/#accounts-list)
     */
    public func getAccounts(for connectionSecret: String, params: SEAccountParams?, completion: SEHTTPResponse<[SEAccount]>) {
        HTTPService<[SEAccount]>.makeRequest(AccountRouter.list(connectionSecret, params), completion: completion)
    }
    
    /**
     Fetches all accounts tied to a connection.
     
     - parameters:
         - connectionSecret: The secret of the connection whose accounts are going to be fetched.
         - params: Optional constraints set to the fetch query. You can set **from_id** to start fetching all account from particular **account_id**
         - completion: The code to be executed once the request has finished.

     [Salt Edge API Reference](https://docs.saltedge.com/account_information/v5/#accounts-list)
     */
    public func getAllAccounts(for connectionSecret: String, params: SEAccountParams?, completion: SEHTTPResponse<[SEAccount]>) {
        HTTPPaginatedService<SEAccount>.makeRequest(AccountRouter.list(connectionSecret, params), completion: completion)
    }
    
    // MARK: Transaction
    /**
     Fetches page of transactions for a connection.
     
     - parameters:
         - connectionSecret: The connection secret of the accounts connection.
         - params: Optional constraints set to the fetch query. Set **account_id** if you want to fetch transcation only for particular account. Set **from_id** to start fetching transaction from particular **transaction_id**. *next_id* could be obtained from response meta.
         - completion: The code to be executed once the request has finished.
     
     [Salt Edge API Reference](https://docs.saltedge.com/account_information/v5/#transactions-list)
     */
    public func getTransactions(for connectionSecret: String, params: SETransactionParams? = nil, completion: SEHTTPResponse<[SETransaction]>) {
        HTTPService<[SETransaction]>.makeRequest(TransactionRouter.list(connectionSecret, params), completion: completion)
    }
    
    /**
     Fetches all transactions for a connection.
     
     - parameters:
         - connectionSecret: The connection secret of the accounts' connection.
         - params: Optional constraints set to the fetch query. Set **account_id** if you want to fetch transcation only for particular account. Set **from_id** to start fetching all transactions from particular **transaction_id**
         - completion: The code to be executed once the request has finished.
     
     [Salt Edge API Reference](https://docs.saltedge.com/account_information/v5/#transactions-list)
     */
    public func getAllTransactions(for connectionSecret: String, params: SETransactionParams? = nil, completion: SEHTTPResponse<[SETransaction]>) {
        HTTPPaginatedService<SETransaction>.makeRequest(TransactionRouter.list(connectionSecret, params), completion: completion)
    }

    /**
     Fetches page of pendding transactions for a connection.

     - parameters:
         - connectionSecret: The connection secret of the accounts' connection.
         - params: Optional constraints set to the fetch query. Set **account_id** if you want to fetch transcation only for particular account. Set **from_id** to start fetching transaction from particular **transaction_id**. *next_id* could be obtained from response meta.
         - completion: The code to be executed once the request has finished.
     
     [Salt Edge API Reference](https://docs.saltedge.com/account_information/v5/#transactions-pending)
     */
    public func getPendingTransations(for connectionSecret: String, params: SETransactionParams? = nil, completion: SEHTTPResponse<[SETransaction]>) {
        HTTPService<[SETransaction]>.makeRequest(TransactionRouter.pending(connectionSecret, params), completion: completion)
    }

    /**
     Fetches page of duplicated transactions for a connection.

     - parameters:
         - connectionSecret: The connection secret of the accounts' connection.
         - params: Optional constraints set to the fetch query. Set **account_id** if you want to fetch transcation only for particular account. Set **from_id** to start fetching transaction from particular **transaction_id**. *next_id* could be obtained from response meta.
         - completion: The code to be executed once the request has finished.
     
     [Salt Edge API Reference](https://docs.saltedge.com/account_information/v5/#transactions-duplicates)
     */
    public func getDuplicatedTransations(for connectionSecret: String, params: SETransactionParams? = nil, completion: SEHTTPResponse<[SETransaction]>) {
        HTTPService<[SETransaction]>.makeRequest(TransactionRouter.duplicates(connectionSecret, params), completion: completion)
    }

    /**
     Mark a list of transactions as duplicated.
     
     - parameters:
         - connectionSecret: The connection secret of the accounts' connection.
         - params: Struct containing array of transaction_ids that should be set as duplicated.
         - completion: The code to be executed once the request has finished.
     
     [Salt Edge API Reference](https://docs.saltedge.com/account_information/v5/#transactions-duplicate)
     */
    public func markAsDuplicated(for connectionSecret: String, params: SEDuplicateTransactionsParams, completion: SEHTTPResponse<SEDuplicateTransactionResponse>) {
        HTTPService<SEDuplicateTransactionResponse>.makeRequest(TransactionRouter.duplicate(connectionSecret, params), completion: completion)
    }

    /**
     Remove duplicated flag from a list of transactions.
     
     - parameters:
         - connectionSecret: The connection secret of the accounts' connection.
         - params: Struct containing array of transaction_ids that should be set as unduplicated.
         - completion: The code to be executed once the request has finished.
     
     [Salt Edge API Reference](https://docs.saltedge.com/account_information/v5/#transactions-unduplicate)
     */
    public func markAsUnduplicated(for connectionSecret: String, params: SEDuplicateTransactionsParams, completion: SEHTTPResponse<SEUnduplicateTransactionResponse>) {
        HTTPService<SEUnduplicateTransactionResponse>.makeRequest(TransactionRouter.unduplicate(connectionSecret, params), completion: completion)
    }

    /**
     Remove transactions older than a specified period.
     
     - parameters:
     - connectionSecret: The connection secret of the accounts' connection.
     - params: Struct containing id of the account, which transactions should be removed and keep days - the amount of days for which the transactions will be kept.
     - completion: The code to be executed once the request has finished.
     
     [Salt Edge API Reference](https://docs.saltedge.com/account_information/v5/#transactions-remove)
     */
    public func removeTransactions(for connectionSecret: String, params: SERemoveTransactionParams, completion: SEHTTPResponse<SERemovedTransactionsResponse>) {
        HTTPService<SERemovedTransactionsResponse>.makeRequest(TransactionRouter.remove(connectionSecret, params), completion: completion)
    }

    // MARK: Currency
    /**
     Fetch the list of all the currencies that we support.
     
     - parameter completion: The code to be executed once the request has finished.
     
     [Salt Edge API Reference](https://docs.saltedge.com/account_information/v5/#currencies-list)
     */
    public func getCurrencies(completion: SEHTTPResponse<[SECurrency]>) {
        HTTPService<[SECurrency]>.makeRequest(CurrencyRouter.list, completion: completion)
    }
    
    /**
     Fetch the list of all the currency rates that we support.
     
     - parameter completion: The code to be executed once the request has finished.
     
     [Salt Edge API Reference](https://docs.saltedge.com/account_information/v5/#rates-list)
     */
    public func getRates(params: SERatesParameters? = nil, completion: SEHTTPResponse<[SERate]>) {
        HTTPService<[SERate]>.makeRequest(CurrencyRouter.rates(params), completion: completion)
    }

    // MARK: Consent
    /**
     Returns list of consents of a connection.

     - parameters:
         - connection_id: Optional. The id of the connection containing the consents
         - customer_id: Optional. The id of the customer containing the consents. Note: Will be ignored if connection_id is present.
         - params: Optional constraints set to the fetch query. You can set **from_id** to fetch paginated results manually. **next_id** could be obtained from response meta.
         - completion: The code to be executed once the request has finished.

     [Salt Edge API Reference](https://docs.saltedge.com/account_information/v5/#consents-list)
     */
    public func getConsents(params: SEConsentsListParams?, completion: SEHTTPResponse<[SEConsent]>) {
        HTTPPaginatedService<SEConsent>.makeRequest(ConsentRouter.list(params), completion: completion)
    }

    /**
     Returns the consent object.

     - parameters:
        - id: The id of the consent.
        - connection_id: Optional. The id of the connection containing the consents
        - customer_id: Optional. The id of the customer containing the consents. Note: Will be ignored if connection_id is present.
        - completion: The code to be executed once the request has finished.

     [Salt Edge API Reference](https://docs.saltedge.com/account_information/v5/#consents-show)
    */
    public func getConsent(by id: String, params: SEBaseConsentsParams, completion: SEHTTPResponse<SEConsent>) {
        HTTPService<SEConsent>.makeRequest(ConsentRouter.show(id, params), completion: completion)
    }

    /**
     Revokes the consent object.

     - parameters:
        - id: The id of the consent.
        - connection_id: Optional. The id of the connection containing the consents
        - customer_id: Optional. The id of the customer containing the consents. Note: Will be ignored if connection_id is present.
        - completion: The code to be executed once the request has finished.

     [Salt Edge API Reference](https://docs.saltedge.com/account_information/v5/#consents-revoke)
     */
    public func revokeConsent(with id: String, params: SEBaseConsentsParams, completion: SEHTTPResponse<SEConsent>) {
        HTTPService<SEConsent>.makeRequest(ConsentRouter.revoke(id, params), completion: completion)
    }

    // MARK: Attempt
    /**
     Returns all attempts for a certain connection.
     
     - parameters:
         - connectionSecret: The secret of the connection whose attempts will be requested.
         - params: Optional constraints set to the fetch query. You can set **from_id** to fetch paginated results manually. **next_id** could be obtained from response meta.
         - completion: The code to be executed once the request has finished.
     
     [Salt Edge API Reference](https://docs.saltedge.com/account_information/v5/#attempts-list)
     */
    public func getAttempts(for connectionSecret: String, params: SEAttemptParams? = nil, completion: SEHTTPResponse<[SEAttempt]>) {
        HTTPService<[SEAttempt]>.makeRequest(AttemptRouter.list(connectionSecret, params), completion: completion)
    }
    
    /**
     Returns a paginated list of all attempts for a certain connection.
     
     - parameters:
         - connectionSecret: The secret of the connection whose attempts will be requested.
         - params: Optional constraints set to the fetch query. You can set **from_id** to fetch paginated results manually. **next_id** could be obtained from response meta.
         - completion: The code to be executed once the request has finished.
     
     [Salt Edge API Reference](https://docs.saltedge.com/account_information/v5/#attempts-list)
     */
    public func getAllAttempts(for connectionSecret: String, params: SEAttemptParams, completion: SEHTTPResponse<[SEAttempt]>) {
        HTTPPaginatedService<SEAttempt>.makeRequest(AttemptRouter.list(connectionSecret, params), completion: completion)
    }
    
    /**
     Fetches a certain attempt for a connection.

     - parameters:
         - id: The id of the attempt that is going to be fetched.
         - connectionSecret: The secret of the connection whose attempt will be requested.
         - completion: The code to be executed once the request has finished.
     
     [Salt Edge API Reference](https://docs.saltedge.com/account_information/v5/#attempts-show)
     */
    public func showAttempt(id: String, connectionSecret: String, completion: SEHTTPResponse<SEAttempt>) {
        HTTPService<SEAttempt>.makeRequest(AttemptRouter.show(connectionSecret, id), completion: completion)
    }
    
    // MARK: Category
    /**
     Fwtch the list of all the categories that we support.
     
     - parameter completion: The code to be executed once the request has finished.

     [Salt Edge API Reference](https://docs.saltedge.com/account_information/v5/#categories-list)
     */
    public func getCategories(completion: SEHTTPResponse<[String: [String]]>) {
       HTTPService<[String: [String]]>.makeRequest(CategoryRouter.list, completion: completion)
    }
    
    /**
     Changes the categories of some transactions, thus improving the categorization accuracy.
     
     - parameters:
        - params: Struct containing array of structs with *transaction_id* and *category_code* that should be set learned.
        - completion: The code to be executed once the request has finished.

     [Salt Edge API Reference](https://docs.saltedge.com/account_information/v5/#categories-learn)
     */
    public func learnCategory(params: SELearnCategories, completion: SEHTTPResponse<SELearnedCategory>) {
        HTTPService<SELearnedCategory>.makeRequest(CategoryRouter.learn(params), completion: completion)
    }
}
