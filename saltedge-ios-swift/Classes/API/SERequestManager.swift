//
//  SERequestManager.swift
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

public struct SERequestManager {
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
     Links your Customer Secret to the request manager. All outgoing requests related to logins will have the proper customer-related HTTP headers set by default.
     
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
    
    // MARK: Login
    /**
     Creates a login with given parameters.
     
     - parameters:
         - params: The parameters of the login that is to be created.
         - fetchingDelegate: The delegate of the login creation process that can respond to certain events.
         - completion: The code to be executed once the request has finished.


     [Salt Edge API Reference](https://docs.saltedge.com/reference/#logins-create)
     */
    public func createLogin(with params: SELoginParams, fetchingDelegate: SELoginFetchingDelegate, completion: SEHTTPResponse<SELogin>) {
        SELoginFetcher.createLogin(with: params, fetchingDelegate: fetchingDelegate, completion: completion)
    }
    
    /**
     Fetches a login with a given login secret.
     
     - parameters:
         - loginSecret: The secret of the login which is to be fetched.
         - completion: The code to be executed once the request has finished.
     
     [Salt Edge API Reference](https://docs.saltedge.com/reference/#logins-show)
     */
    public func getLogin(with secret: String, completion: SEHTTPResponse<SELogin>) {
        HTTPService<SELogin>.makeRequest(LoginRouter.show(secret), completion: completion)
    }
    
    /**
     Reconnects a login.
     
     - parameters:
         - secret: The secret of the login which is to be reconnected.
         - params: The parameters of the login that is to be reconnected.
         - completion: The code to be executed once the request has finished.
     
     - warning: **credentials** in SELoginReconnectParams cannot be nil.
     

     [Salt Edge API Reference](https://docs.saltedge.com/reference/#logins-reconnect)
     */
    public func reconnectLogin(with secret: String, with params: SELoginReconnectParams, fetchingDelegate: SELoginFetchingDelegate, completion: SEHTTPResponse<SELogin>) {
        SELoginFetcher.reconnectLogin(secret: secret, params: params, fetchingDelegate: fetchingDelegate, completion: completion)
    }
    
    /**
     Provides an interactive login with a set of credentials.
     
     - parameters:
         - secret: The secret of the login which is to be connected.
         - params: The parameters of the login that is to be connected using interactive step.
         - fetchingDelegate: The delegate of the login creation process that can respond to certain events.
         - completion: The code to be executed once the request has finished.
     
     - warning: **credentials** in SELoginInteractiveParams cannot be nil.
     
     
     [Salt Edge API Reference](https://docs.saltedge.com/reference/#logins-interactive)
     */
    public func confirmLogin(with secret: String, params: SELoginInteractiveParams, fetchingDelegate: SELoginFetchingDelegate, completion: SEHTTPResponse<SELogin>) {
        SELoginFetcher.interactiveLogin(with: params, secret: secret, fetchingDelegate: fetchingDelegate, completion: completion)
    }
    
    /**
     Refreshes a login.
     
     - parameters:
         - secret: The secret of the login which is to be refreshed.
         - params: The parameters of the login that is to be refreshed.
         - fetchingDelegate: The delegate of the login creation process that can respond to certain events.
         - completion: The code to be executed once the request has finished.

     - warning: Only automatic logins can be refreshed.
     
     [Salt Edge API Reference](https://docs.saltedge.com/reference/#logins-refresh)
     */
    public func refreshLogin(with secret: String, params: SELoginRefreshParams? = nil, fetchingDelegate: SELoginFetchingDelegate, completion: SEHTTPResponse<SELogin>) {
        SELoginFetcher.refreshLogin(secret: secret, params: params, fetchingDelegate: fetchingDelegate, completion: completion)
    }
    
    /**
     Inactivates a login.
     Marks a login from the system as inactive. In order to activate the login, you have to perform a successful reconnect.
     
     - parameters:
         - secret: The secret of the login which is to be inactivated.
         - completion: The code to be executed once the request has finished.
     

     [Salt Edge API Reference](https://docs.saltedge.com/reference/#logins-inactivate)
     */
    public func inactivateLogin(with secret: String, completion: SEHTTPResponse<SELogin>) {
        HTTPService<SELogin>.makeRequest(LoginRouter.inactivate(secret), completion: completion)
    }

    /**
     Removes a login from our system. All the associated accounts and transactions to that login will be destroyed as well.

     - parameters:
         - secret: The secret of the login which is to be removed.
         - completion: The code to be executed once the request has finished.
     
     
     [Salt Edge API Reference](https://docs.saltedge.com/reference/#logins-remove)
     */
    public func removeLogin(with secret: String, completion: SEHTTPResponse<SERemovedLoginResponse>) {
        HTTPService<SERemovedLoginResponse>.makeRequest(LoginRouter.remove(secret), completion: completion)
    }
    
    /**
     Destroys credentials of the login.

     - parameters:
         - secret: The secret of the login to destroy credentials.
         - completion: The code to be executed once the request has finished.

     [Salt Edge API Reference](https://docs.saltedge.com/v4_apps/reference/#logins-destroy_credentials)
     */
    public func destroyLoginCredentials(with secret: String, completion: SEHTTPResponse<SELogin>) {
        HTTPService<SELogin>.makeRequest(LoginRouter.destroyCredentials(secret), completion: completion)
    }
    
    // MARK: OAuth Providers
    /**
     Creates a OAuth login with given parameters.
     
     - parameters:
         - params: The parameters of the OAuth login that is to be created.
         - completion: The code to be executed once the request has finished.
     
     [Salt Edge API Reference](https://docs.saltedge.com/v4_apps/reference/#oauth_providers-create)
     */
    public func createOAuthLogin(params: SECreateOAuthParams, completion: SEHTTPResponse<SEOAuthResponse>) {
        HTTPService<SEOAuthResponse>.makeRequest(OAuthRouter.create(params), completion: completion)
    }
    
    /**
     Reconnects a OAuth login with given parameters.
     
     - parameters:
         - secret: The secret of the OAuth login to reconnect.
         - params: The parameters of the OAuth login that is to be reconnected.
         - completion: The code to be executed once the request has finished.
     
     [Salt Edge API Reference](https://docs.saltedge.com/v4_apps/reference/#oauth_providers-reconnect)
     */
    public func reconnectOAuthLogin(with secret: String, params: SEUpdateOAuthParams, completion: SEHTTPResponse<SEOAuthResponse>) {
        HTTPService<SEOAuthResponse>.makeRequest(OAuthRouter.reconnect(secret, params), completion: completion)
    }
    
    /**
     Refreshes a OAuth login with given parameters.
     
     - parameters:
         - secret: The secret of the OAuth login to refresh.
         - params: The parameters of the OAuth login that is to be refreshed.
         - completion: The code to be executed once the request has finished.
     
     [Salt Edge API Reference](https://docs.saltedge.com/v4_apps/reference/#oauth_providers-refresh)
     */
    public func refreshOAuthLogin(with secret: String, params: SEUpdateOAuthParams, completion: SEHTTPResponse<SEOAuthResponse>) {
        HTTPService<SEOAuthResponse>.makeRequest(OAuthRouter.refresh(secret, params), completion: completion)
    }
    
    /**
     Handles a openURL call from your application delegate class when connecting an OAuth provider.
     
     - parameters:
         - url: The URL that was passed in the application:openURL:sourceApplication:annotation: method of your app delegate class.
         - loginFetchingDelegate: The delegate of the login creation process that can respond to certain events.
     */
    public func handleOpen(url: URL, loginFetchingDelegate: SELoginFetchingDelegate) {
        guard let parameters = url.queryParameters else { return }
        
        if let errorMessage = parameters["error_message"] {
            if let loginSecret = parameters["login_secret"] {
                SERequestManager.shared.getLogin(with: loginSecret) { response in
                    switch response {
                    case .success(let value):
                        loginFetchingDelegate.failedToFetch(login: value.data, message: errorMessage)
                    case .failure(_):
                        loginFetchingDelegate.failedToFetch(login: nil, message: errorMessage)
                    }
                }
            } else {
                loginFetchingDelegate.failedToFetch(login: nil, message: errorMessage)
            }
        } else {
            guard let loginSecret = parameters["login_secret"] else { return }
            
            SELoginFetcher.handleOAuthLogin(loginSecret: loginSecret, fetchingDelegate: loginFetchingDelegate)
        }
    }
    
    // MARK: Token
    /**
     Requests a token for connecting a login via a web view.
     
     - parameters:
         - params: The parameters that will go in the request payload.
         - completion: The code to be executed once the request has finished.
     
     [Salt Edge API Reference](https://docs.saltedge.com/v4_apps/reference/#tokens-create)
     */
    public func createToken(params: SECreateTokenParams, completion: SEHTTPResponse<SETokenResponse>) {
        HTTPService<SETokenResponse>.makeRequest(TokenRouter.create(params), completion: completion)
    }
    
    /**
     Requests a token for reconnecting a login via a web view.
     
     - parameters:
         - loginSecret: The login secret for which the reconnect token is requested.
         - params: The parameters that will go in the request payload.
         - completion: The code to be executed once the request has finished.
     
     [Salt Edge API Reference](https://docs.saltedge.com/v4_apps/reference/#tokens-reconnect)
     */
    public func reconnectToken(with secret: String, params: SEReconnectTokenParams, completion: SEHTTPResponse<SETokenResponse>) {
        HTTPService<SETokenResponse>.makeRequest(TokenRouter.reconnect(secret, params), completion: completion)
    }
    
    /**
     Requests a token for refreshing a login via a web view.
     
     - parameters:
         - loginSecret: The login secret for which the refresh token is requested.
         - params: The parameters that will go in the request payload.
         - completion: The code to be executed once the request has finished.
     
     [Salt Edge API Reference](https://docs.saltedge.com/v4_apps/reference/#tokens-refresh)
     */
    public func refreshToken(with secret: String, params: SERefreshTokenParams, completion: SEHTTPResponse<SETokenResponse>) {
        HTTPService<SETokenResponse>.makeRequest(TokenRouter.refresh(secret, params), completion: completion)
    }

    // MARK: Account
    /**
     Fetches page of accounts tied to a login.
     
     - parameters:
         - loginSecret: The secret of the login whose accounts are going to be fetched.
             - params: Optional constraints set to the fetch query. You can set **from_id** to fetch paginated results manually. **next_id** could be obtained from response meta.
             - completion: The code to be executed once the request has finished.
     
     [Salt Edge API Reference](https://docs.saltedge.com/reference/#accounts-list)
     */
    public func getAccounts(for loginSecret: String, params: SEAccountParams?, completion: SEHTTPResponse<[SEAccount]>) {
        HTTPService<[SEAccount]>.makeRequest(AccountRouter.list(loginSecret, params), completion: completion)
    }
    
    /**
     Fetches all accounts tied to a login.
     
     - parameters:
         - loginSecret: The secret of the login whose accounts are going to be fetched.
         - params: Optional constraints set to the fetch query. You can set **from_id** to start fetching all account from particular **account_id**
         - completion: The code to be executed once the request has finished.

     [Salt Edge API Reference](https://docs.saltedge.com/reference/#accounts-list)
     */
    public func getAllAccounts(for loginSecret: String, params: SEAccountParams?, completion: SEHTTPResponse<[SEAccount]>) {
        HTTPPaginatedService<SEAccount>.makeRequest(AccountRouter.list(loginSecret, params), completion: completion)
    }
    
    // MARK: Transaction
    /**
     Fetches page of transactions for a login.
     
     - parameters:
         - loginSecret: The login secret of the accounts' login.
         - params: Optional constraints set to the fetch query. Set **account_id** if you want to fetch transcation only for particular account. Set **from_id** to start fetching transaction from particular **transaction_id**. *next_id* could be obtained from response meta.
         - completion: The code to be executed once the request has finished.
     
     [Salt Edge API Reference](https://docs.saltedge.com/reference/#transactions-list)
     */
    public func getTransactions(for loginSecret: String, params: SETransactionParams? = nil, completion: SEHTTPResponse<[SETransaction]>) {
        HTTPService<[SETransaction]>.makeRequest(TransactionRouter.list(loginSecret, params), completion: completion)
    }
    
    /**
     Fetches all transactions for a login.
     
     - parameters:
     - loginSecret: The login secret of the accounts' login.
     - params: Optional constraints set to the fetch query. Set **account_id** if you want to fetch transcation only for particular account. Set **from_id** to start fetching all transactions from particular **transaction_id**
     - completion: The code to be executed once the request has finished.
     
     [Salt Edge API Reference](https://docs.saltedge.com/reference/#transactions-list)
     */
    public func getAllTransactions(for loginSecret: String, params: SETransactionParams? = nil, completion: SEHTTPResponse<[SETransaction]>) {
        HTTPPaginatedService<SETransaction>.makeRequest(TransactionRouter.list(loginSecret, params), completion: completion)
    }
    
    /**
     Fetches page of pendding transactions for a login.
     
     - parameters:
     - loginSecret: The login secret of the accounts' login.
     - params: Optional constraints set to the fetch query. Set **account_id** if you want to fetch transcation only for particular account. Set **from_id** to start fetching transaction from particular **transaction_id**. *next_id* could be obtained from response meta.
     - completion: The code to be executed once the request has finished.
     
     [Salt Edge API Reference](https://docs.saltedge.com/reference/#transactions-pending)
     */
    public func getPendingTransations(for loginSecret: String, params: SETransactionParams? = nil, completion: SEHTTPResponse<[SETransaction]>) {
        HTTPService<[SETransaction]>.makeRequest(TransactionRouter.pending(loginSecret, params), completion: completion)
    }
    
    /**
     Mark a list of transactions as duplicated.
     
     - parameters:
         - loginSecret: The login secret of the accounts' login.
         - params: Struct containing array of transaction_ids that should be set as duplicated.
         - completion: The code to be executed once the request has finished.
     
     [Salt Edge API Reference](https://docs.saltedge.com/v4_apps/reference/#transactions-duplicate)
     */
    public func markAsDuplicated(params: SEDuplicateTransactionsParams, completion: SEHTTPResponse<SEDuplicateTransactionResponse>) {
        HTTPService<SEDuplicateTransactionResponse>.makeRequest(TransactionRouter.duplicate(params), completion: completion)
    }
    
    /**
     Mark a list of transactions as duplicated.
     
     - parameters:
         - loginSecret: The login secret of the accounts' login.
         - params: Struct containing array of transaction_ids that should be set as unduplicated.
         - completion: The code to be executed once the request has finished.
     
     [Salt Edge API Reference](https://docs.saltedge.com/v4_apps/reference/#transactions-unduplicate)
     */
    public func markAsUnduplicated(params: SEDuplicateTransactionsParams, completion: SEHTTPResponse<SEUnduplicateTransactionResponse>) {
        HTTPService<SEUnduplicateTransactionResponse>.makeRequest(TransactionRouter.unduplicate(params), completion: completion)
    }
    
    // MARK: Currency
    /**
     Fetch the list of all the currencies that we support.
     
     - parameter completion: The code to be executed once the request has finished.
     
     [Salt Edge API Reference](https://docs.saltedge.com/v4_apps/reference/#currencies-list)
     */
    public func getCurrencies(completion: SEHTTPResponse<[SECurrency]>) {
        HTTPService<[SECurrency]>.makeRequest(CurrencyRouter.list, completion: completion)
    }
    
    /**
     Fetch the list of all the currency rates that we support.
     
     - parameter completion: The code to be executed once the request has finished.
     
     [Salt Edge API Reference](https://docs.saltedge.com/v4_apps/reference/#rates-list)
     */
    public func getRates(params: SERatesParameters? = nil, completion: SEHTTPResponse<[SERate]>) {
        HTTPService<[SERate]>.makeRequest(CurrencyRouter.rates(params), completion: completion)
    }
    
    // MARK: Attempt
    /**
     Returns a paginated list of all attempts for a certain login.
     
     - parameters:
         - loginSecret: The secret of the login whose attempts will be requested.
         - completion: The code to be executed once the request has finished.
     
     [Salt Edge API Reference](https://docs.saltedge.com/v4_apps/reference/#attempts-stages)
     */
    public func getAttempts(for loginSecret: String, completion: SEHTTPResponse<[SEAttempt]>) {
        HTTPService<[SEAttempt]>.makeRequest(AttemptRouter.list(loginSecret), completion: completion)
    }
    
    /**
     Returns all attempts for a certain login.
     
     - parameters:
         - loginSecret: The secret of the login whose attempts will be requested.
         - completion: The code to be executed once the request has finished.
     
     [Salt Edge API Reference](https://docs.saltedge.com/v4_apps/reference/#attempts-list)
     */
    public func getAllAttempts(for loginSecret: String, completion: SEHTTPResponse<[SEAttempt]>) {
        HTTPPaginatedService<SEAttempt>.makeRequest(AttemptRouter.list(loginSecret), completion: completion)
    }
    
    /**
     Fetches a certain attempt for a login.

     - parameters:
         - id: The id of the attempt that is going to be fetched.
         - loginSecret: The secret of the login whose attempt will be requested.
         - completion: The code to be executed once the request has finished.
     
     [Salt Edge API Reference](https://docs.saltedge.com/v4_apps/reference/#attempts-show)
     */
    public func showAttempt(id: String, loginSecret: String, completion: SEHTTPResponse<SEAttempt>) {
        HTTPService<SEAttempt>.makeRequest(AttemptRouter.show(loginSecret, id), completion: completion)
    }
    
    // MARK: Category
    /**
     Fwtch the list of all the categories that we support.
     
     - parameter completion: The code to be executed once the request has finished.

     [Salt Edge API Reference](https://docs.saltedge.com/v4_apps/reference/#categories-list)
     */
    public func getCategories(completion: SEHTTPResponse<[String: [String]]>) {
       HTTPService<[String: [String]]>.makeRequest(CategoryRouter.list, completion: completion)
    }
    
    /**
     Changes the categories of some transactions, thus improving the categorization accuracy.
     
     - parameters:
        - params: Struct containing array of structs with *transaction_id* and *category_code* that should be set learned.
        - completion: The code to be executed once the request has finished.

     [Salt Edge API Reference](https://docs.saltedge.com/reference/#categories-learn)
     */
    public func learnCategory(params: SELearnCategories, completion: SEHTTPResponse<SELearnedCategory>) {
        HTTPService<SELearnedCategory>.makeRequest(CategoryRouter.learn(params), completion: completion)
    }
}
