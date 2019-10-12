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
