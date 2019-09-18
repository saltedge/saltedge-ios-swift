# How To...
  
* [Connect OAuth provider with Client Keys](#connect-oauth-provider-with-client-keys)

---
## Connect OAuth provider with Client Keys

Connect OAuth provider with Client Keys
Salt Edge now supports Account Information Services channels, which can be used with PSD2 and Open Banking compliant APIs.

Read about it in [Salt Edge Documentation](https://docs.saltedge.com/general/#client_provider_keys)

1. Register application deep-link (Custom URL Scheme, in example below it'll be `custom_scheme`) for your app target. See official [Apple documentation](https://developer.apple.com/documentation/uikit/inter-process_communication/allowing_apps_and_websites_to_link_to_your_content/defining_a_custom_url_scheme_for_your_app).

2. Create a `returnTo` constant as application deep link, which you will use for `createConnectSession`.

    ```swift
    static let returnTo = "custom_scheme://custom_host/custom_path"
    ```

3. Fetch providers and select one.

    ```swift
    let params = SEProviderParams(fromId: 108)
    SERequestManager.shared.getProviders(with: params) { response in
        // handle response here.
    }
    ```
4. Create Connect Session. In `SEConnectSessionsParams` add `SEAttempt` object with your `returnTo` url.

    ```swift
    let params = SEConnectSessionsParams(
        attempt: SEAttempt(returnTo: returnTo),
        providerCode: provider?.code,
        disableProvidersSearch: true,
        consent: consent
    )

    SERequestManager.shared.createConnectSession(
        params: params,
        completion: { [weak self] response in
            // Use recieved response.connectUrl
            self?.handleConnectSessionResponse(response)
        }
    )
    ```

5. Check Provier `mode`. If `mode` is `oauth` then open received `connectUrl` in external app, otherwise open it in `webView`.

    ```swift
    func handleConnectSessionResponse(_ response: SEConnectSessionResponse) {
        guard let url = URL(string: response.connectUrl) else { return }

        // Check if provider mode is "oauth". Then try to open it in external browser or app.
        if let provider = self.provider, provider.isOAuth, UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        } else {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
    ```

5. All connect operations (Authorizations, Fetching, etc.) will be performed in external app.

6. After openning your app with `deepLink`, handle it in your `AppDelegate.swift`, using next method:

    ```swift
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
            SERequestManager.shared.handleOpen(url: url, connectionFetchingDelegate: yourDelegate)
            return true
        }
    ```

---
Copyright © 2014 - 2019 Salt Edge Inc. https://www.saltedge.com