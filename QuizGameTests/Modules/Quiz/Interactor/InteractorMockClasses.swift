//  ABSTRACT:
//      QuizInteractor unit tests.

import XCTest
@testable import QuizGame

class MockPresenter: QuizInteractorDelegate {
    
    var expectedQuestion: String?
    var expectedAnswer: [String]?
    var expectedError: QuizRequestError?
    var successExpectation: XCTestExpectation?
    var failureExpectation: XCTestExpectation?
    
    func didRetrieveQuiz(quizQuestion: String, quizAnswer: [String]) {
        XCTAssertEqual(expectedQuestion, quizQuestion)
        XCTAssertEqual(expectedAnswer, quizAnswer)
        successExpectation!.fulfill()
    }
    
    func retrievingQuizFailed(with error: QuizRequestError) {
        XCTAssertEqual(expectedError, error)
        failureExpectation!.fulfill()
    }
    
    func newAcceptedAnswerAdded(answer: String) {
        // TODO
    }
    
    func timerDidUpdate(remainingTime: Int) {
        // TODO
    }
    
    func gameDidStart() {
        // TODO
    }
    
    func gameDidStop() {
        // TODO
    }
    
    func playerDidWinQuizGame() {
        // TODO
    }
    
    func playerDidLoseQuizGame() {
        // TODO
    }
}
