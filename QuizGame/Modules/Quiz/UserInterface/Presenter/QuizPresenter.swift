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
//      QuizPresenter intermediates the communication between the passive view (QuizView) and the application logic (QuizInteractor).
//      This class would also inform the Wireframe about the need to present a new screen, but this application does not need a Wireframe
//      for now, since it has only one screen.

protocol QuizPresenterInterface: AnyObject {
    var view: QuizViewInterface? { get set }
    var interactor: QuizInteractorInterface? { get set }
    var acceptedAnswers: [String]? { get }
    func viewDidLoad()
    func textFieldHasNewWord(word: String)
}

class QuizPresenter: QuizPresenterInterface {
    
    weak var view: QuizViewInterface?
    var interactor: QuizInteractorInterface?
    var acceptedAnswers: [String]?
    
    func viewDidLoad() {
        view?.startLoadingScreen()
        // Currently, Java is the only possible Quiz.
        // In the future, if more quizzes are supported, this needs to be changed.
        interactor?.requestNewQuiz(withName: "Java")
    }
    
    func textFieldHasNewWord(word: String) {
        guard let interactor = interactor else {
            preconditionFailure("Interactor should be initialized")
        }
        if interactor.check(answer: word) {
            if let firstItem = acceptedAnswers?.isEmpty, firstItem {
                view?.showTableView()
            }
            acceptedAnswers?.append(word.capitalized)
            view?.cleanTextField()
            view?.updateTableView()
        }
    }
    
}

extension QuizPresenter: QuizInteractorDelegate {
    
    func retrievingQuizFailed(with error: QuizRequestError) {
        view?.dismissLoadingScreen()
        switch error {
        case .invalidQuizName:
            // Currently, there's nothing that the user can do about this, since the quiz name is hardcoded
            view?.showErrorMessage(title: "Invalid Quiz Name", text: "The quiz name is invalid. Try choosing another quiz.")
        case .connectionError:
            view?.showErrorMessage(title: "Connection Error", text: "There was a connection error. Check your internet connection.")
        case .jsonParsingError:
            // Since there's nothing that the user can do about a JSON parsing error,
            // it's better to tell him/her to choose another quiz, if available.
            view?.showErrorMessage(title: "Unavailable Quiz", text: "Right now this quiz is unavailable. Try another one.")
        }
    }
    
    func didRetrieveQuiz(quizQuestion: String, quizAnswer: [String]) {
        view?.showHiddenItems()
        view?.setQuizTitle(quizQuestion)
        view?.dismissLoadingScreen()
        view?.setHitsLabelText("00/\(quizAnswer.count)")
        
        acceptedAnswers = [String]()
    }
    
    func playerDidWinQuizGame() {
        // TODO
    }
    
}
