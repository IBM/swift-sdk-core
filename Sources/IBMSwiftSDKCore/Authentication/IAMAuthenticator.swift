/**
 * Copyright IBM Corporation 2018, 2019
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 **/

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

/** Authenticate with an IAM API key. The API key is used to automatically retrieve and refresh access tokens. */
public class IAMAuthenticator: TokenSourceAuthenticator {

    public init(apiKey: String, url: String? = nil) {
        super.init(tokenSource: IAMTokenSource(apiKey: apiKey, url: url))
    }

    public func setClientCredentials(clientID: String, clientSecret: String) {
        if let tokenSource = self.tokenSource as? IAMTokenSource {
            tokenSource.setClientCredentials(clientID: clientID, clientSecret: clientSecret)
        }
    }
}

class IAMTokenSource: TokenSource {

    let url: String

    var headers: [String: String]?

    var session = URLSession(configuration: URLSessionConfiguration.default)

    private let apiKey: String
    private var token: String?
    private var expireDate: Date?
    private var refreshDate: Date?
    private var clientAuthenticator: Authenticator = NoAuthAuthenticator()

    // Dispatch queue for token refresh.  This is a serial queue (the default), so only one refresh at a time
    private var refreshQueue = DispatchQueue.init(label: "com.ibm.cloud.swift-sdk-core.token-refresh", qos: .background)

    // Dispatch queue for token fetch.  This is a serial queue (the default), so only one fetch at a time
    private var fetchQueue = DispatchQueue.init(label: "com.ibm.cloud.swift-sdk-core.token-fetch", qos: .userInitiated)

    init(apiKey: String, url: String? = nil) {
        self.apiKey = apiKey
        if let url = url {
            self.url = url
        } else {
            self.url = "https://iam.cloud.ibm.com/identity/token"
        }
    }

    #if !os(Linux)
    /**
     Allow network requests to a server without verification of the server certificate.
     **IMPORTANT**: This should ONLY be used if truly intended, as it is unsafe otherwise.
     */
    func disableSSLVerification() {
        session = InsecureConnection.session()
    }
    #endif

    func setClientCredentials(clientID: String, clientSecret: String) {
        self.clientAuthenticator = BasicAuthenticator(username: clientID, password: clientSecret)
    }

    func getToken(completionHandler: @escaping (String?, RestError?) -> Void) {
        // If we have a token, pass it to the completion handler.
        if let token = self.token,
           let expireDate = expireDate, expireDate.timeIntervalSinceNow > 0 {
            completionHandler(token, nil)
            if let refreshDate = refreshDate, refreshDate.timeIntervalSinceNow < 0 {
                refreshQueue.async{ self.refreshToken() }
            }
        } else {
            fetchQueue.async {
                // Check if token was obtained by an earlier fetch
                if let token = self.token {
                    completionHandler(token, nil)
                } else {
                    self.requestToken(completionHandler: completionHandler)
                }
            }
        }
    }

    // request a new access token if the refresh time for the current token is passed
    func refreshToken() {
        // If refreshDate is set and still in the future, no refresh needed -- just return
        if let refreshDate = refreshDate, refreshDate.timeIntervalSinceNow > 0 {
            return
        }

        // This is running in a serial dispatch queue, so update to refreshDate is serialized
        self.refreshDate = Date(timeIntervalSinceNow: 60) // Update refreshDate to 60 seconds from now
        requestToken { (_, _) in /* dummy completion handler */ }
    }

    internal func errorResponseDecoder(data: Data, response: HTTPURLResponse) -> RestError {
        var errorMessage: String?
        var metadata = [String: Any]()

        do {
            let json = try JSON.decoder.decode([String: JSON].self, from: data)
            metadata["response"] = json
            if case let .some(.string(message)) = json["errorMessage"] {
                errorMessage = message
            } else {
                errorMessage = HTTPURLResponse.localizedString(forStatusCode: response.statusCode)
            }
        } catch {
            metadata["response"] = data
            errorMessage = HTTPURLResponse.localizedString(forStatusCode: response.statusCode)
        }

        return RestError.http(statusCode: response.statusCode, message: errorMessage, metadata: metadata)
    }

    private func requestToken(completionHandler: @escaping (String?, RestError?) -> Void) {
        var headerParameters = ["Content-Type": "application/x-www-form-urlencoded", "Accept": "application/json"]
        if let headers = headers {
            headerParameters.merge(headers) { (old, _) in old }
        }
        let form = ["grant_type=urn:ibm:params:oauth:grant-type:apikey", "apikey=\(apiKey)", "response_type=cloud_iam"]
        let request = RestRequest(
            session: session,
            authenticator: clientAuthenticator,
            errorResponseDecoder: errorResponseDecoder,
            method: "POST",
            url: url,
            headerParameters: headerParameters,
            messageBody: form.joined(separator: "&").data(using: .utf8)
        )
        request.responseObject { (response: RestResponse<IAMToken>?, error) in
            guard let iamToken = response?.result, error == nil else {
                completionHandler(nil, error)
                return
            }
            self.token = iamToken.accessToken
            // Compute refreshDate for token
            let expirationDate = Date(timeIntervalSince1970: Double(iamToken.expiration))
            // We want a little buffer to make sure we refresh proactively
            let buffer = expirationDate.timeIntervalSinceNow * -0.2
            self.expireDate = expirationDate
            self.refreshDate = expirationDate.addingTimeInterval(buffer)
            completionHandler(self.token, nil)
        }
    }
}

/** An IAM token. */
internal struct IAMToken: Decodable {

    let accessToken: String
    let refreshToken: String
    let tokenType: String
    let expiresIn: Int
    let expiration: Int

    private enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
        case tokenType = "token_type"
        case expiresIn = "expires_in"
        case expiration = "expiration"
    }
}
