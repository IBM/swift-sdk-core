/**
* Copyright IBM Corporation 2020
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

import XCTest
@testable import IBMSwiftSDKCore

class SDKInitializerTests: XCTestCase {

    #if os(Linux)
    static var allTests = [
        ("testSomeSDKInit", testSomeSDKInit),
        ("testSomeSDKNewInstance", testSomeSDKNewInstance),
        ("testSomeSDKNewInstanceWithAuthenticator", testSomeSDKNewInstanceWithAuthenticator),
        ("testSomeSDKNewInstanceWithServiceName", testSomeSDKNewInstanceWithServiceName),
        ("testAnotherSDKInit", testAnotherSDKInit),
        ("testAnotherSDKInitWithAuthenticator", testAnotherSDKInitWithAuthenticator),
        ("testAnotherSDKInitWithServiceName", testAnotherSDKInitWithServiceName),
    ]
    #endif

    // MARK: SDK Initializer methods

    public class Shared {
        public static let userAgent = "this is the user agent string"
    }

    // SomeSDK is the code generated for a service that does not specify `includeExternalConfig = true`
    public class SomeSDK {
        public var serviceURL: String? = "http://cloud.ibm.com/somesdk/v1"
        public static let defaultServiceName = "service1"

        public let authenticator: Authenticator

        #if os(Linux)
        class public func newInstance(authenticator: Authenticator? = nil, serviceName: String = defaultServiceName) throws -> SomeSDK {
            let theAuthenticator = try authenticator ?? ConfigBasedAuthenticatorFactory.getAuthenticator(credentialPrefix: serviceName)
            let myInstance = SomeSDK.init(authenticator: theAuthenticator)
            if let serviceURL = CredentialUtils.getServiceURL(credentialPrefix: serviceName) {
                myInstance.serviceURL = serviceURL
            }
            return myInstance
        }
        #endif

        /**
          Create a `SomeSDK` object.

          - parameter authenticator: The Authenticator object used to authenticate requests to the service
          */
         public init(authenticator: Authenticator) {
             self.authenticator = authenticator
             RestRequest.userAgent = Shared.userAgent
         }
    }

    // AnotherSDK is the code generated for a service that specifies `includeExternalConfig = true`
    public class AnotherSDK {
        public var serviceURL: String? = "http://cloud.ibm.com/anothersdk/v1"
        public static let defaultServiceName = "service1"

        public let authenticator: Authenticator

        #if os(Linux)
        public init(authenticator: Authenticator? = nil, serviceName: String = defaultServiceName) throws {
            self.authenticator = try authenticator ?? ConfigBasedAuthenticatorFactory.getAuthenticator(credentialPrefix: serviceName)
            if let serviceURL = CredentialUtils.getServiceURL(credentialPrefix: serviceName) {
                self.serviceURL = serviceURL
            }
            RestRequest.userAgent = Shared.userAgent
        }
        #else
        public init(authenticator: Authenticator) {
            self.authenticator = authenticator
            RestRequest.userAgent = Shared.userAgent
        }
        #endif
    }

    // MARK: includeExternalConfig disabled

    // Test SDK initializers for a service that does not specify `includeExternalConfig = true`

    // Test normal init method
    func testSomeSDKInit() {
        let authenticator = BasicAuthenticator(username: "username", password: "password")
        let somesdk = SomeSDK(authenticator: authenticator)
        XCTAssertNotNil(somesdk)
        XCTAssertNotNil(somesdk.authenticator as? BasicAuthenticator)
        XCTAssert(somesdk.serviceURL == "http://cloud.ibm.com/somesdk/v1")
    }

    #if os(Linux)
    // Test NewInstance method without supplied authenticator
    func testSomeSDKNewInstance() {
        if ProcessInfo.processInfo.environment["VCAP_SERVICES"] == nil {
            XCTFail("VCAP_SERVICES is not defined in the test environment")
        }

        do {
            let somesdk = try SomeSDK.newInstance()
            XCTAssertNotNil(somesdk)
            XCTAssertNotNil(somesdk.authenticator as? BasicAuthenticator)
            XCTAssertNotNil(somesdk.serviceURL == "https://myhost.com/my/service1/base/url") // from TestVcapServices.json
        } catch {
            XCTFail("newInstance method failed: \(error)")
        }
    }

    // Test NewInstance method with supplied authenticator
    func testSomeSDKNewInstanceWithAuthenticator() {
        if ProcessInfo.processInfo.environment["VCAP_SERVICES"] == nil {
            XCTFail("VCAP_SERVICES is not defined in the test environment")
        }

        do {
            let authenticator = IAMAuthenticator(apiKey: "apikey")
            let somesdk = try SomeSDK.newInstance(authenticator: authenticator)
            XCTAssertNotNil(somesdk)
            XCTAssertNotNil(somesdk.authenticator as? IAMAuthenticator)
            XCTAssertNotNil(somesdk.serviceURL == "https://myhost.com/my/service1/base/url") // from TestVcapServices.json
        } catch {
            XCTFail("newInstance method failed: \(error)")
        }
    }

    // Test NewInstance method with specified service name
    func testSomeSDKNewInstanceWithServiceName() {
        if ProcessInfo.processInfo.environment["VCAP_SERVICES"] == nil {
            XCTFail("VCAP_SERVICES is not defined in the test environment")
        }

        do {
            let somesdk = try SomeSDK.newInstance(serviceName: "service2")
            XCTAssertNotNil(somesdk)
            XCTAssertNotNil(somesdk.authenticator as? IAMAuthenticator)
            XCTAssertNotNil(somesdk.serviceURL == "https://myhost.com/my/service2/base/url") // from TestVcapServices.json
        } catch {
            XCTFail("newInstance method failed: \(error)")
        }
    }
    #endif

    // MARK: includeExternalConfig enabled

    // Test SDK initializers for a service that specifies `includeExternalConfig = true`

    #if !os(Linux)
    // Test normal init method
    func testAnotherSDKInit() {
        let authenticator = BasicAuthenticator(username: "username", password: "password")
        let anothersdk = AnotherSDK(authenticator: authenticator)
        XCTAssertNotNil(anothersdk)
        XCTAssertNotNil(anothersdk.authenticator as? BasicAuthenticator)
        XCTAssert(anothersdk.serviceURL == "http://cloud.ibm.com/anothersdk/v1")
    }

    #else
    // Test init method without supplied authenticator
    func testAnotherSDKInit() {
        if ProcessInfo.processInfo.environment["VCAP_SERVICES"] == nil {
            XCTFail("VCAP_SERVICES is not defined in the test environment")
        }

        do {
            let anothersdk = try AnotherSDK()
            XCTAssertNotNil(anothersdk)
            XCTAssertNotNil(anothersdk.authenticator as? BasicAuthenticator)
            XCTAssertNotNil(anothersdk.serviceURL == "https://myhost.com/my/service1/base/url") // from TestVcapServices.json
        } catch {
            XCTFail("init method failed: \(error)")
        }
    }

    // Test init method with supplied authenticator
    func testAnotherSDKInitWithAuthenticator() {
        if ProcessInfo.processInfo.environment["VCAP_SERVICES"] == nil {
            XCTFail("VCAP_SERVICES is not defined in the test environment")
        }

        do {
            let authenticator = IAMAuthenticator(apiKey: "apikey")
            let anothersdk = try AnotherSDK(authenticator: authenticator)
            XCTAssertNotNil(anothersdk)
            XCTAssertNotNil(anothersdk.authenticator as? IAMAuthenticator)
            XCTAssertNotNil(anothersdk.serviceURL == "https://myhost.com/my/service1/base/url") // from TestVcapServices.json
        } catch {
            XCTFail("init method failed: \(error)")
        }
    }

    // Test init method with specified service name
    func testAnotherSDKInitWithServiceName() {
        if ProcessInfo.processInfo.environment["VCAP_SERVICES"] == nil {
            XCTFail("VCAP_SERVICES is not defined in the test environment")
        }

        do {
            let anothersdk = try AnotherSDK(serviceName: "service2")
            XCTAssertNotNil(anothersdk)
            XCTAssertNotNil(anothersdk.authenticator as? IAMAuthenticator)
            XCTAssertNotNil(anothersdk.serviceURL == "https://myhost.com/my/service2/base/url") // from TestVcapServices.json
        } catch {
            XCTFail("init method failed: \(error)")
        }
    }
    #endif
}
