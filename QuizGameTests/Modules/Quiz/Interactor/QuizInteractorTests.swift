//  ABSTRACT:
//      QuizInteractor unit tests.

import XCTest
@testable import QuizGame

class QuizInteractorTests: XCTestCase {
    
    // MARK: - QuizInteractor Setup
    
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
    
    // MARK: - QuizInteractor Tests
    
    /// Test if the correct error message is passed to the Presenter if an invalid quiz name is informed.
    func testGetNewQuiz_InvalidQuizName() {
        // Inject expected error, and failure expectation in the mocked presenter
        quizPresenter.expectedError = .invalidQuizName
        let failureExpectation = XCTestExpectation(description: "Fails to find quiz with quizName")
        quizPresenter.failureExpectation = failureExpectation
        
        // Test requestNewQuiz method with an invalid name
        let quizName = "C"
        quizInteractor.requestNewQuiz(withName: quizName)
        
        // Wait for the successExpectation to be fulfilled
        wait(for: [failureExpectation], timeout: 0.1)
    }
    
    /// Test if the correct data is passed to the Presenter if the quiz request is successful.
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
    
    /// Test if the correct error message is passed to the Presenter if there was a problem with internet connection.
    func testGetNewQuiz_NoConnection() {
        // Inject expected data in the mocked session
        session.nextError = QuizRequestError.connectionError
        
        // Inject expected question, answer, and expectation in the mocked presenter
        quizPresenter.expectedError = .connectionError
        let failureExpectation = XCTestExpectation(description: "Connection error")
        quizPresenter.failureExpectation = failureExpectation
        
        // Test requestNewQuiz method
        let quizName = "Java"
        quizInteractor.requestNewQuiz(withName: quizName)
        
        // Wait for the successExpectation to be fulfilled
        wait(for: [failureExpectation], timeout: 0.1)
    }
    
    /// Test if the correct error message is passed to the Presenter if the JSON data cannot be properly parsed.
    func testGetNewQuiz_JSONParsingError() {
        // Inject expected data in the mocked session
        let jsonURL = Bundle(for: type(of: self)).url(forResource: "malformed_json", withExtension: "json")!
        session.nextData = try! Data(contentsOf: jsonURL)
        
        // Inject expected question, answer, and success expectation in the mocked presenter
        quizPresenter.expectedError = .jsonParsingError
        let failureExpectation = XCTestExpectation(description: "Cannot parse JSON data")
        quizPresenter.failureExpectation = failureExpectation
        
        // Test requestNewQuiz method with a valid name
        let quizName = "Java"
        quizInteractor.requestNewQuiz(withName: quizName)
        
        // Wait for the successExpectation to be fulfilled
        wait(for: [failureExpectation], timeout: 0.1)
    }

}
