//
//  Compat.swift
//  TDOAuth
//
//  Created by Adam Kaplan on 3/9/20.
//

import Foundation

//var Signer: HMACSigner? = nil

@objc public class TDOAuthCompat: NSObject {

    static var OAuth1Type: OAuth1.Type = OAuth1<HMACSigner>.self

    @objc public static func signRequest(_ urlRequest: URLRequest,
                                  consumerKey: String,
                                  consumerSecret: String,
                                  accessToken: String?,
                                  tokenSecret: String?,
                                  signatureMethod: TDOAuthSignatureMethod) -> URLRequest? {


        let hmacAlgo: OAuth1HmacAlgorithm
        switch signatureMethod {
        case .hmacSha1:
            hmacAlgo = .sha1
        case .hmacSha256:
            hmacAlgo = .sha256
        default:
            return nil
        }

        let key: HMACSigner.KeyMaterial = (consumerSecret: consumerSecret, accessTokenSecret: tokenSecret)
        let signer = HMACSigner(algorithm: hmacAlgo, material: key)
        let oauth1 = OAuth1Type.init(withConsumerKey: consumerKey, accessToken: accessToken, signer: signer)

        return oauth1.sign(request: urlRequest)
    }
}

@objc public extension NSString {
    @objc var TDOAuth_addingUrlSafePercentEncoding: String { (self as String).addingUrlSafePercentEncoding() }
}
