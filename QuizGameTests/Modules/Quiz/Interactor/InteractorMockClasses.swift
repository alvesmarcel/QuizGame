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
