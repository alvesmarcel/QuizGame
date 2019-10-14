//  ABSTRACT:
//      NetworkService is responsible for requesting raw data from the internet.

import Foundation

protocol NetworkServiceInterface {
    var session: URLSessionInterface { get }
    func requestData(fromURL url: URL, completionHandler: @escaping (_ data: Data?, _ error: Error?) -> Void)
}

class NetworkService: NetworkServiceInterface {
    
    let session: URLSessionInterface
    
    init(session: URLSessionInterface = defaultSession()) {
        self.session = session
    }
    
    func requestData(fromURL url: URL, completionHandler: @escaping (_ data: Data?, _ error: Error?) -> Void) {
        let task = session.dataTask(with: url) {(data, _, error) in
            guard let receivedData = data else {
                completionHandler(nil, error)
                return
            }
            completionHandler(receivedData, nil)
        }
        task.resume()
    }
    
    static func defaultSession() -> URLSession {
        let session = URLSession(configuration: .ephemeral)
        session.configuration.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        session.configuration.waitsForConnectivity = false
        return session
    }
    
}
