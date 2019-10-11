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
//      NetworkService unit tests.

import XCTest
@testable import QuizGame

class NetworkServiceTests: XCTestCase {
    
    // MARK: - Mock Classes
    
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
    
    // MARK: - NetworkService Setup
    
    var networkService: NetworkService!
    let session = MockURLSession()
    let baseURL = URL(string: "https://codechallenge.arctouch.com/quiz/1")!

    override func setUp() {
        super.setUp()
        networkService = NetworkService(session: self.session)
    }

    // MARK: - NetworkService Tests

    func testRequestStart() {
        let dataTask = MockURLSessionDataTask()
        session.nextDataTask = dataTask
        networkService.requestDataFromURL(url: baseURL) { (_, _) in }
        XCTAssert(dataTask.resumeWasCalled)
    }
    
    func testRequestSuccessful() {
        let expectedData = "{}".data(using: String.Encoding.utf8)
        session.nextData = expectedData
        
        var actualData: Data?
        var actualError: Error?
        
        networkService.requestDataFromURL(url: baseURL) { (data, error) in
            actualData = data
            actualError = error
        }
        
        XCTAssertEqual(actualData, expectedData)
        XCTAssertNil(actualError)
    }
    
    func testRequestFailed() {
        let expectedError = NSError(domain: "AnyError", code: 0, userInfo: nil)
        session.nextError = expectedError
        
        var actualData: Data?
        var actualError: Error?
        
        networkService.requestDataFromURL(url: baseURL) { (data, error) in
            actualData = data
            actualError = error
        }
        
        XCTAssertNotNil(actualError)
        XCTAssertNil(actualData)
    }

}
