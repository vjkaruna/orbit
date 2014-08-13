Orbit
===========

iOS Stellar client with multicurrency support (alpha)

![alt tag](https://raw.githubusercontent.com/vjkaruna/stellar-ios/master/readme_screenshot_1.png)

Orbit is a Stellar client for iOS 8 written in Swift. By default, it authenticates with the launch Stellar wallets at wallet.stellar.org, and the gateway hosted at live.stellar.org. 

The project uses Mattt Thompson's [Alamofire](https://github.com/Alamofire/Alamofire) networking library (a Swift successor to AFNetworking) and the enumeration-based approach of [Swifty-JSON](https://github.com/lingoer/SwiftyJSON) to parse the Stellar API. The rocket ship logo is taken from [Unrestricted Stock](http://unrestrictedstock.com/use-agreement/)

# Authentication

Authentication with wallet.stellar.org uses the [default client's](https://github.com/stellar/stellar-client) Javascript implementation of scrypt, hosted in an iOS8 WKWebView - the username and password are sent to wallet.stellar.org exactly as in the default client, and are not stored locally. The secret key from the wallet is used for further API calls, but only for the lifetime of the app, and not stored locally. Further exploration might include using alternate keys from the secret key used in the default client.

# Trustlines

Orbit is intended for the management of trust across multiple currencies and issuers, in addition to STR (Stellar's native currency.) For example, a Stellar user may receive BTC on a gateway they trust, up to a specified limit of BTC, by creating a trustline for BTC with that gateway.
