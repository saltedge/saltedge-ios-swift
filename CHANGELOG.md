# Changelog

## [3.1.0] - 2019-08-20

### Added.

- Added missed fields for `SETransactionExtra` and `SEAccountExtra`.
- Added missed `Connection-secret` header for `TransactionRouter`.
- Added route `remove` in `TransactionRouter` for removing transactions for specified account.

### Changed.

- Renamed `SEExtra` to `SEAccountExtra`.

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
