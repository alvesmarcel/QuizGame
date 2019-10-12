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
//      QuizInteractor is responsible for the application logic of the Quiz module.
//      Interactor responsabilities:
//        1) Use NetworkService to get quiz data (QuizResource) that will be delivered to the presenter;
//

import Foundation

protocol QuizInteractorInterface: AnyObject {
    var presenter: QuizInteractorDelegate? { get set }
    var networkService: NetworkServiceInterface { get }
    func requestNewQuiz(withName quizName: String)
}

protocol QuizInteractorDelegate: AnyObject {
    func didRetrieveQuiz(quizQuestion: String, quizAnswer: [String])
    func retrievingQuizFailed(with error: QuizRequestError)
}

class QuizInteractor: QuizInteractorInterface {
    
    weak var presenter: QuizInteractorDelegate?
    let networkService: NetworkServiceInterface
    
    init(networkService: NetworkServiceInterface = NetworkService()) {
        self.networkService = networkService
    }
    
    func requestNewQuiz(withName quizName: String) {
        guard let quizURL = quizNameToURL(quizName: quizName) else {
            // The quiz name is invalid
            presenter?.retrievingQuizFailed(with: .invalidQuizName)
            return
        }
        
        networkService.requestData(fromURL: quizURL) { [weak self] (data, _) in
            guard let jsonData = data else {
                // Inform the presenter that we had a connection error
                // Currently, we don't handle other types of network error,
                // so there's no need to use the error information provided by the closure
                self?.presenter?.retrievingQuizFailed(with: .connectionError)
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let quiz = try decoder.decode(QuizResource.self, from: jsonData)
                
                // Quiz retrieved and decoded successfully, so it is passed to the presenter
                self?.presenter?.didRetrieveQuiz(quizQuestion: quiz.question, quizAnswer: quiz.answer)
            } catch {
                // Server Error: The JSON given by the server cannot be properly parsed
                self?.presenter?.retrievingQuizFailed(with: .jsonParsingError)
            }
            
        }
    }
    
}

// MARK: - Private Methods

extension QuizInteractor {
    
    private func quizNameToURL(quizName: String) -> URL? {
        switch quizName {
        case "Java":
            return URL(string: "https://codechallenge.arctouch.com/quiz/1")
        default:
            return nil
        }
    }
    
}
