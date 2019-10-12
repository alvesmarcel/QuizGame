//  Copyright 2019 ArcTouch LLC.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//  ------------------------------------------------------------------------
//  ABSTRACT:
//      Mock classes for NetworkServiceTests.

import Foundation
@testable import QuizGame

class MockURLSession: URLSessionInterface {
    var nextData: Data?
    var nextError: Error?
    var nextDataTask = MockURLSessionDataTask()
    private (set) var lastURL: URL?
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskInterface {
        lastURL = url
        completionHandler(nextData, nil, nextError)
        return nextDataTask
    }
}

class MockURLSessionDataTask: URLSessionDataTaskInterface {
    private (set) var resumeWasCalled = false
    func resume() {
        resumeWasCalled = true
    }
}
