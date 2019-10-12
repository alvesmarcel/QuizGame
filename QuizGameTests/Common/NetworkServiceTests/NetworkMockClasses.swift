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
