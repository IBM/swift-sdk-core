// swift-tools-version:5.0

/**
 * (C) Copyright IBM Corp. 2016, 2019.
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

import PackageDescription

let package = Package(
    name: "IBMSwiftSDKCore",
    platforms: [
           .macOS(.v10_12),
           .iOS(.v10),
           .tvOS(.v10),
           .watchOS(.v3)
       ],
    products: [
        .library(name: "IBMSwiftSDKCore", targets: ["IBMSwiftSDKCore"]),
    ],
    targets: [
        .target(name: "IBMSwiftSDKCore", dependencies: []),
        .testTarget(name: "IBMSwiftSDKCoreTests", dependencies: ["IBMSwiftSDKCore"]),
    ]
)
