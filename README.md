# Salt Edge iOS Swift

A handful of classes to help you interact with the Salt Edge API from your iOS app.

## Requirements

iOS 10.0+, Swift 4+

## Installation
### CocoaPods

Add the pod to your `Podfile`

```ruby
pod 'SaltEdge-iOS-Swift', '~> 1.0.0'
```

Install the pod

`$ pod install`

Import SDK into your app

`import SaltEdge`

## Connecting logins using the sample app

1. Install dependencies by running `$ pod install`
2. Replace the `clientId`, `secret` and `customerIdentifier` constants in [AppDelegate.m:49-51](https://github.com/saltedge/saltedge-ios-swift/blob/master/Example/saltedge-ios/AppDelegate.m#L49-L51) with your Client ID and corresponding App secret
3. Run the app

*Note*: You can find your Client ID and App secret at your [secrets](https://www.saltedge.com/clients/profile/secrets) page.

## SEWebView

A small `WKWebView` subclass for using [Salt Edge Connect](https://docs.saltedge.com/guides/connect/) within your iOS app.

### Example

Let your view controller conform to the `SEWebViewDelegate` protocol.

```swift
class MyViewController : UIViewController, SEWebViewDelegate {
  // ... snip ...
}
```

Instantiate a `SEWebView` and add it to the controller:

```swift
let connectWebView = SEWebView(frame: self.view.bounds)
connectWebView.stateDelegate = self
self.view.addSubview(connectWebView)
```

Implement the `SEWebViewDelegate` methods in the controller:

```swift
// ... snip ...

func webView(_ webView: SEWebView, didReceiveCallbackWithResponse response: SEConnectResponse) {
    switch response.stage {
    case .success: 
	    // Login successfully connected
    case .fetching: 
	    // Login is fetching. You can safe login secret if it is present.
    case .error:
	    // Handle error
    }
}

func webView(_ webView: SEWebView, didReceiveCallbackWithError error: Error) {
	// Handle error
}
```

Load the Salt Edge Connect URL into the web view and you're good to go:

```swift
SERequestManager.shared.createToken(params: tokenParams) { response in
	switch response {
	case .success(let value):
		if let url = URL(string: value.data.connectUrl) {
		    self.webView.load(URLRequest(url: url))
		}
	case .failure(let error):
		// Handle error
	}
} 

```

## SEAPIRequestManager

A class designed with convenience methods for interacting with and querying the Salt Edge API. Contains methods for fetching entities (logins, transactions, accounts, et al.), for requesting login tokens for connecting, reconnecting and refreshing logins via a `SEWebView`, and also for connecting logins via the REST API.

Each successful request via `SEAPIRequestManager` returns `SEResponse` containing `data` and `meta`.

Each failed request returns standard Swift's `Error` .

### Usage

Link your Client ID and App secret in the first place before using it.

``` swift
SERequestManager.shared.set(appId: appId, appSecret: appSecret)
```

### Example

```swift
let params = SECustomerParams(identifier: "your-customer-unique-id")
SERequestManager.shared.createCustomer(with: params) { response in
	switch response {
	case .success(let value):
		// Save customer secret to your storage and the link it with API manager
		SERequestManager.shared.set(customerSecret: value.data.secret)
	case .failure(let error):
		// Handle error 
	}
}	
```

Use the manager to interact with the provided API:

```swift
let loginParams = SELoginParams(countryCode: "XF",
                                providerCode: "fakebank_simple_xf",
                                credentials: ["login": "username", "password": "secret"],
                                fetchType: "recent")
SERequestManager.shared.createLogin(with: loginParams) { response in
    switch response {
    case .success(let value): 
	    // value.data is a valid SELogin
    case .failure(let error): 
    	// Handle error 
    }
}
```

## Models

There are some provided models for serializing the objects received in the API responses. These represent the providers, logins, accounts, transactions, provider fields and their options. Whenever you request a resource that returns one of these types, they will always get serialized into Swift structs. For instance, the `getAllTransactions(for loginSecret: String, params: SETransactionParams? = nil, completion: SEHTTPResponse<[SETransaction]>)` method has a `SEResponse` containing `data` and `meta` where `data` is `[SETransaction]` in it's success callback.

Models contained within the components:

* `SEProvider`
* `SELogin`
* `SEAccount`
* `SETransaction`
* `SETokenResponse`
* `SEAttempt`
* `SECountry`
* `SECustomer`
* `SEStage`
* `SEError`
* `SEProviderField`
* `SEProviderFieldOption`

For a supplementary description of the models listed above that is not included in the sources' docs, feel free to visit the [API Reference](https://docs.saltedge.com/reference/).

## Documentation

Documentation is available for all of the components. Use quick documentation (Alt+Click) to get a quick glance at the documentation for a method or a property.

## Running the demo

To run the demo app contained in here, you have to provide the demo with your client ID, app secret, and a customer identifier.
Set up the `clientId`, `appSecret` and `customerIdentifier` constants to your Client ID and corresponding App secret in [AppDelegate.m:49-51](https://github.com/saltedge/saltedge-ios-swift/blob/master/Example/saltedge-ios/AppDelegate.m#L49-L51).

## Versioning

The current version of the SDK is [1.0.0](https://github.com/saltedge/saltedge-ios-swift/releases/tag/v1.0), and supports the latest available version of Salt Edge API. Any backward-incompatible changes in the API will result in changes to the SDK.

## Security

The SDK has SSL pinning enabled. That means that every API request that originates in `SEAPIRequestManager` will have SSL certificate validation. The current Salt Edge SSL certificate will expire on 1st of May 2018, meaning that it will be renewed in the first week of April 2018. Following the SSL certificate renewal, the SDK will be updated to use the new certificate for SSL pinning. As a result of that, usage of older versions of the SDK will not be possible since every request will fail because of the old SSL certificate. Salt Edge clients will be notified about this and there will be enough time in order to update the apps to the newer version of the SDK.

## License

See the LICENSE file.

## References

1. [Salt Edge Connect Guide](https://docs.saltedge.com/guides/connect/)
2. [Salt Edge API Reference](https://docs.saltedge.com/reference/)
