//  ABSTRACT:
//      URLSessionDataTaskInterface and URLSessionInterface provide methods that are used in the mock classes
//      to test the NetworkService class.

import Foundation

protocol URLSessionDataTaskInterface {
    func resume()
}

protocol URLSessionInterface {
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskInterface
}

extension URLSessionDataTask: URLSessionDataTaskInterface {}

extension URLSession: URLSessionInterface {
    
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskInterface {
        return (dataTask(with: url, completionHandler: completionHandler) as URLSessionDataTask) as URLSessionDataTaskInterface
    }
    
}
