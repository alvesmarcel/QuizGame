//  ABSTRACT:
//      NetworkService unit tests. To allow offline testing, we use MockURLSession and MockURLSessionDataTask.

import XCTest
@testable import QuizGame

class NetworkServiceTests: XCTestCase {
    
    // MARK: - NetworkService Setup
    
    var networkService: NetworkServiceInterface!
    let session = MockURLSession()
    let baseURL = URL(string: "https://codechallenge.arctouch.com/quiz/1")!

    override func setUp() {
        super.setUp()
        networkService = NetworkService(session: self.session)
    }

    // MARK: - NetworkService Tests
    
    /// Test if the URL passed to requestData is the same that goes to URLSessionInterface's dataTask.
    func testRequestURL() {
        networkService.requestData(fromURL: baseURL) { (_, _) in }
        XCTAssertEqual(session.lastURL!.absoluteString, baseURL.absoluteString)
    }

    /// Test if resume is called to start the data request.
    func testRequestStart() {
        let dataTask = MockURLSessionDataTask()
        session.nextDataTask = dataTask
        networkService.requestData(fromURL: baseURL) { (_, _) in }
        XCTAssert(dataTask.resumeWasCalled)
    }
    
    /// Test a successful request, where data != nil and error == nil.
    func testRequestSuccessful() {
        let expectedData = "{}".data(using: String.Encoding.utf8)
        session.nextData = expectedData
        
        var actualData: Data?
        var actualError: Error?
        
        networkService.requestData(fromURL: baseURL) { (data, error) in
            actualData = data
            actualError = error
        }
        
        XCTAssertEqual(actualData, expectedData)
        XCTAssertNil(actualError)
    }
    
    /// Test a failed request, where data == nil and  error != nil.
    func testRequestFailed() {
        let expectedError = NSError(domain: "AnyError", code: 0, userInfo: nil)
        session.nextError = expectedError
        
        var actualData: Data?
        var actualError: Error?
        
        networkService.requestData(fromURL: baseURL) { (data, error) in
            actualData = data
            actualError = error
        }
        
        XCTAssertNotNil(actualError)
        XCTAssertNil(actualData)
    }

}
