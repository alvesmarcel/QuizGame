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
//      QuizInteractor unit tests.

import XCTest
@testable import QuizGame

class QuizInteractorTests: XCTestCase {
    
    class MockPresenter: QuizInteractorDelegate {
        
        var expectedQuestion: String?
        var expectedAnswer: [String]?
        var expectedErrorMessage: String?
        var successExpectation: XCTestExpectation?
        var failureExpectation: XCTestExpectation?
        
        func didRetrieveQuiz(quizQuestion: String, quizAnswer: [String]) {
            XCTAssertEqual(expectedQuestion, quizQuestion)
            XCTAssertEqual(expectedAnswer, quizAnswer)
            successExpectation!.fulfill()
        }
        
        func retrievingQuizFailed(with message: String) {
            XCTAssertEqual(expectedErrorMessage, message)
            failureExpectation!.fulfill()
        }
        
    }
    
    var session: MockURLSession!
    var quizPresenter: MockPresenter!
    var quizInteractor: QuizInteractorInterface!

    override func setUp() {
        super.setUp()
        session = MockURLSession()
        quizPresenter = MockPresenter()
        quizInteractor = QuizInteractor(networkService: NetworkService(session: self.session))
        quizInteractor.presenter = quizPresenter
    }
    
    func testGetNewQuiz_InvalidQuizName() {
        // Inject expected error, and failure expectation in the mocked presenter
        quizPresenter.expectedErrorMessage = QuizRequestError.invalidQuizName.localizedDescription
        let failureExpectation = XCTestExpectation(description: "Fails to find quiz with quizName")
        quizPresenter.failureExpectation = failureExpectation
        
        // Test requestNewQuiz method with an invalid name
        let quizName = "C"
        quizInteractor.requestNewQuiz(withName: quizName)
        
        // Wait for the successExpectation to be fulfilled
        wait(for: [failureExpectation], timeout: 0.1)
    }
    
    func testGetNewQuiz_Succeed() {
        // Inject expected data in the mocked session
        let jsonURL = Bundle(for: type(of: self)).url(forResource: "java_keywords", withExtension: "json")!
        session.nextData = try! Data(contentsOf: jsonURL)
        
        // Inject expected question, answer, and success expectation in the mocked presenter
        let decoder = JSONDecoder()
        let quiz = try! decoder.decode(QuizResource.self, from: session.nextData!)
        quizPresenter.expectedQuestion = quiz.question
        quizPresenter.expectedAnswer = quiz.answer
        let successExpectation = XCTestExpectation(description: "Successfully retrieved and parsed JSON quiz data")
        quizPresenter.successExpectation = successExpectation
        
        // Test requestNewQuiz method with a valid name
        let quizName = "Java"
        quizInteractor.requestNewQuiz(withName: quizName)
        
        // Wait for the successExpectation to be fulfilled
        wait(for: [successExpectation], timeout: 0.1)
    }
    
    func testGetNewQuiz_NoConnection() {
        // Inject expected data in the mocked session
        session.nextError = QuizRequestError.connectionError
        
        // Inject expected question, answer, and expectation in the mocked presenter
        quizPresenter.expectedErrorMessage = QuizRequestError.connectionError.localizedDescription
        let failureExpectation = XCTestExpectation(description: "Connection error")
        quizPresenter.failureExpectation = failureExpectation
        
        // Test requestNewQuiz method
        let quizName = "Java"
        quizInteractor.requestNewQuiz(withName: quizName)
        
        // Wait for the successExpectation to be fulfilled
        wait(for: [failureExpectation], timeout: 0.1)
    }
    
    func testGetNewQuiz_UnavailableQuiz() {
        // Inject expected data in the mocked session
        let jsonURL = Bundle(for: type(of: self)).url(forResource: "malformed_json", withExtension: "json")!
        session.nextData = try! Data(contentsOf: jsonURL)
        
        // Inject expected question, answer, and success expectation in the mocked presenter
        quizPresenter.expectedErrorMessage = QuizRequestError.jsonParsingError.localizedDescription
        let failureExpectation = XCTestExpectation(description: "Cannot parse JSON data")
        quizPresenter.failureExpectation = failureExpectation
        
        // Test requestNewQuiz method with a valid name
        let quizName = "Java"
        quizInteractor.requestNewQuiz(withName: quizName)
        
        // Wait for the successExpectation to be fulfilled
        wait(for: [failureExpectation], timeout: 0.1)
    }

}
