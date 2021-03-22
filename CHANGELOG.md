# Changelog

## [3.3.13] - 2021-03-17

### Fixed.

- Fixed parsing of `interactive_fields` and `required_fileds` in `SEProvider`. 

## [3.3.10] - 2021-02-03

### Fixed.

- Fixed SSL pinning.

## [3.3.9] - 2020-11-02

### Added.

- Added missed attributes to `SEProvider`.

## [3.3.8] - 2020-10-16

### Fixed.

- Fixed dates decoding.

## [3.3.7] - 2020-10-07 

### Added.

- Added missed attributes to `SEAttempt`.

## [3.3.6] - 2020-10-02 

### Added.

- Added missed attributes to `SEProvider`.

## [3.3.5] - 2020-07-20  

### Changed.  

- Downgraded SDK target iOS version to 10.+

## [3.3.4] - 2020-06-23  

### Added.  

- Added `theme` and `override_credentials_strategy` into `SESessionsParams`
  
## [3.3.3] - 2020-05-04

### Removed.

- Removed deprecated files

## [3.3.2] - 2020-04-09

### Added.

- Added `per_page` parameter in `SEProviderParams`, `SEAccountParams`, `SETransactionParams`, `SEConsentsListParams`, `SEAttemptParams`. Default value is 1000.

### Changed.

- Made `documentation_url` field optional for `SEError`

## [3.3.1] - 2020-03-06

### Added.

- Added logoURL to SEProvider model

## [3.3.0] - 2019-10-29

### Removed.

- Removed SaltEdge Partners API support

## [3.2.4] - 2019-10-17

### Changed

- Opened lead session parameters (`SELeadSessionParams`)
- Added `customerId` to `SELeadSessionParams`

## [3.2.3] - 2019-10-02

### Fixed.

- SEWebView tinColor set to .black

## [3.2.1] - 2019-09-27

### Fixed.

- Fixed `disable_provider_search` field typo of the `SELeadSessionParams`

## [3.2.0] - 2019-09-18

### Added.

- Added `SEAuthorizeOAuthParams`
- Added `authorize` endpoint in `OAuthRouter`
- Added `connectionSecret` field in `SEOAuthResponse`
- Added `disableProvidersSearch` field in `SEBaseSessionsParams`
- Added `authorizeOAuthConnection` request in `SERequestManager`

### Removed.

- Removed `returnTo` field from `SEOAuthParams`
- Removed `refresh` endpoint from `OAuthRouter`

## [3.1.4] - 2019-08-29

### Modified.

- Modified `SEWebView` access level.

## [3.1.3] - 2019-08-23

### Fixed.

- Fixed `SEAccount` extra expected type for `assets` field in `ExtraExtensions.swift`.

## [3.1.2] - 2019-08-22

### Fixed.

- Fixed `SEError` decoding.

## [3.1.1] - 2019-08-22

### Changed.

- Modified `extra` field type.

### Fixed.

- Fixed `SEWebView` links loader bug.
- Fixed `SEDuplicateTransactionsParams` request params.

## [3.1.0] - 2019-08-20

### Added.

- Added missed `Connection-secret` header for `TransactionRouter`.
- Added route `remove` in `TransactionRouter` for removing transactions for specified account.

## [3.0.1] - 2019-08-12

### Added.

- Added possibility to handle `SEWebView` request urls.

## [3.0.0] - 2019-08-05

### Added.

- Added Partners API v1 support.

## [2.1.1] - 2019-07-24

### Changed.

- Modified date parser.

### Removed.

- Removed redundant `locale` field.

## [2.0.0] - 2019-04-01

### Added.

- Added `SEConsent` model.
- Added `documentationUrl` to `SEError`.
- Added functions:

  1. `getConsents` - Returns all the consents accessible to your application for certain customer or connection.
      ```swift
      SERequestManager.shared.getConsents(params: SEConsentsListParams, completion: SEHTTPResponse<[SEConsent]>)
      ```

  2.  `getConsent` - Returns the consent object by `id`. 

      ```swift
      SERequestManager.shared.getConsent(by id: String, params: SEBaseConsentsParams, completion: SEHTTPResponse<SEConsent>)
      ```

  3. `revokeConsent` - Revoke a consent with `id`.

      ```swift
      SERequestManager.shared.revokeConsent(with id: String, params: SEBaseConsentsParams, completion: SEHTTPResponse<SEConsent>)
      ```

  4. `updateConnectionUpdateStatus` - Update `status`, `store_credentials` or `daily_refresh` of the connection.

     ```swift
     SERequestManager.shared.updateConnectionUpdateStatus(with params: SEConnectionUpdateStatusParams, id: String, secret: String, fetchingDelegate: SEConnectionFetchingDelegate, completion: SEHTTPResponse<SEConnection>)
     ```

  5. `getDuplicatedTransations` - Returns the list of duplicated transactions.

     ```swift
     SERequestManager.shared.getDuplicatedTransations(params: SETransactionParams? = nil, completion: SEHTTPResponse<[SETransaction]>)
     ```

### Changed.

- Renamed entity `Login` to `Connection`. 

- Renamed entity `Token` to `Connect Session`.

### Removed.

- Removed `/connections/inactivate`. Should use `SERequestManager.shared.updateConnectionUpdateStatus` method.

- Removed `connections/destroy_credentials`.  Should use `SERequestManager.shared.updateConnectionUpdateStatus` method.

- Removed `oauth/refresh`.

- Removed `fetchScopes` from `SECreateTokenParams`. Should use `SEConsent(scopes: ..)` instead.
