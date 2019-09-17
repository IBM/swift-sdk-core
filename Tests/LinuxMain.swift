import XCTest

@testable import IBMSwiftSDKCoreTests

XCTMain([
    testCase(AuthenticationTests.allTests),
    testCase(CodableExtensionsTests.allTests),
    testCase(JSONTests.allTests),
    testCase(RestErrorTests.allTests),
    testCase(ResponseTests.allTests),
    testCase(MultiPartFormDataTests.allTests),
    testCase(CredentialUtilsTests.allTests),
    testCase(ConfigBasedAuthenticatorFactoryTests.allTests),
])
