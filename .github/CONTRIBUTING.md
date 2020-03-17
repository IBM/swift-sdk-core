This document contains information and guidelines about contributing to this project. Please read it before you start participating.

# Asking Questions

If you are having problems using this SDK or have a question about IBM Cloud services,
please ask a question on [Stack Overflow][stackoverflow] or [dW Answers][dw].

[dw]: https://developer.ibm.com/answers/questions/ask/?topics=ibm-cloud
[stackoverflow]: http://stackoverflow.com/questions/ask?tags=ibm-ibm-cloud

# Reporting Issues

If you encounter an issue with the project, you are welcome to submit a [bug report](https://github.com/IBM/swift-sdk-core/issues).
Before that, please search for similar issues. It's possible that someone has already reported the problem.

# Coding Style

Contributions should follow the established coding style and conventions for this project,
which are loosely based on [The Official raywenderlich.com Swift Style Guide][styleguide]
and [Swift API Design Guidelines][api-guidelines].
The project is set up so that developers can use [SwiftLint][swiftlint] to check conformance
to the coding style guidelines.

[styleguide]: https://github.com/raywenderlich/swift-style-guide
[api-guidelines]: https://swift.org/documentation/api-design-guidelines
[swiftlint]: https://github.com/realm/SwiftLint

# Pull Requests

If you want to contribute to the repository, here's a quick guide:
  1. Fork the repository.
  2. Develop and test your code changes.
    * Please respect the original code [style guide][styleguide].
    * Create minimal diffs - disable on save actions like reformat source code or organize imports. If you feel the source code should be reformatted create a separate PR for this change.
    * Check for unnecessary whitespace with `git diff --check` before committing.
  3. Verify that tests pass successfully.
  4. Push to your fork and submit a pull request to the **master** branch.

## Additional Resources
+ [General GitHub documentation](https://help.github.com/)
+ [GitHub pull request documentation](https://help.github.com/send-pull-requests/)

# Running the Tests

## MacOS

To run tests in Xcode, select the `IBMSwiftSDKCore` scheme and press `cmd-u`.

## Linux

Instructions for testing the Swift SDK Core for Linux on a Mac can be found in [the project wiki][wiki-linux-testing].

[wiki-linux-testing] : https://github.com/IBM/swift-sdk-core/wiki/Testing-the-Swift-SDK-Core-for-Linux-on-a-Mac

# Code Coverage

<Instructions here>

# Developer's Certificate of Origin 1.1

By making a contribution to this project, I certify that:

(a) The contribution was created in whole or in part by me and I
   have the right to submit it under the open source license
   indicated in the file; or

(b) The contribution is based upon previous work that, to the best
   of my knowledge, is covered under an appropriate open source
   license and I have the right under that license to submit that
   work with modifications, whether created in whole or in part
   by me, under the same open source license (unless I am
   permitted to submit under a different license), as indicated
   in the file; or

(c) The contribution was provided directly to me by some other
   person who certified (a), (b) or (c) and I have not modified
   it.

(d) I understand and agree that this project and the contribution
   are public and that a record of the contribution (including all
   personal information I submit with it, including my sign-off) is
   maintained indefinitely and may be redistributed consistent with
   this project or the open source license(s) involved.


---

*Some of the ideas and wording for the statements above were based on work by the [Alamofire](https://github.com/Alamofire/Alamofire/blob/master/CONTRIBUTING.md), [Docker](https://github.com/docker/docker/blob/master/CONTRIBUTING.md), and [Linux](http://elinux.org/Developer_Certificate_Of_Origin) communities. We commend them for their efforts to facilitate collaboration in their projects.*
