//  ABSTRACT:
//      QuizPresenter intermediates the communication between the passive view (QuizView) and the application logic (QuizInteractor).
//      This class would also inform the Wireframe about the need to present a new screen, but this application does not need
//      a Wireframe for now, since it has only one screen.

protocol QuizPresenterInterface: AnyObject {
    var view: QuizViewInterface? { get set }
    var interactor: QuizInteractorInterface? { get set }
    var presentingAnswers: [String]? { get }
    func viewDidLoad()
    func textFieldHasNewWord(word: String)
    func startResetButtonTapped(withButtonName buttonName: String)
}

class QuizPresenter: QuizPresenterInterface {
    
    weak var view: QuizViewInterface?
    var interactor: QuizInteractorInterface?
    var presentingAnswers: [String]?
    
    func viewDidLoad() {
        view?.startLoadingScreen()
        // Currently, Java is the only possible Quiz.
        // In the future, if more quizzes are supported, this needs to be changed.
        interactor?.requestNewQuiz(withName: "Java")
    }
    
    func textFieldHasNewWord(word: String) {
        interactor?.check(answer: word)
    }
    
    func startResetButtonTapped(withButtonName buttonName: String) {
        if buttonName == "Start" {
            interactor?.startGame()
        } else {
            interactor?.resetGame()
        }
    }
    
}

// MARK: - QuizInteractorDelegate

extension QuizPresenter: QuizInteractorDelegate {
    
    func retrievingQuizFailed(with error: QuizRequestError) {
        view?.dismissLoadingScreen()
        switch error {
        case .invalidQuizName:
            // Currently, there's nothing that the user can do about this, since the quiz name is hardcoded
            view?.displayAlert(title: "Invalid Quiz Name", text: "The quiz name is invalid. Try choosing another quiz.", buttonText: nil)
        case .connectionError:
            view?.displayAlert(title: "Connection Error", text: "There was a connection error. Check your internet connection.", buttonText: nil)
        case .jsonParsingError:
            // Since there's nothing that the user can do about a JSON parsing error,
            // it's better to tell him/her to choose another quiz, if available.
            view?.displayAlert(title: "Unavailable Quiz", text: "Right now this quiz is unavailable. Try another one.", buttonText: nil)
        }
    }
    
    func didRetrieveQuiz(quizQuestion: String, quizAnswer: [String]) {
        view?.showQuestionLabel()
        view?.showGuessTextField()
        view?.setQuizTitle(quizQuestion)
        view?.dismissLoadingScreen()
        view?.enableStartResetButton()
        updateHitsLabel(answersCount: 0, totalAnswersCount: quizAnswer.count)
    }
    
    func newAcceptedAnswerAdded(answer: String) {
        presentingAnswers?.append(answer.capitalized)
        updateViewOnCurrentState()
    }
    
    func gameDidStart() {
        presentingAnswers = [String]()
        view?.enableGuessTextField()
        view?.hideTableView()
        view?.updateStartResetButtonTitle(title: "Reset")
        updateViewOnCurrentState()
    }
    
    func gameDidStop() {
        view?.updateStartResetButtonTitle(title: "Start")
    }
    
    func timerDidUpdate(remainingTime: Int) {
        let min = remainingTime / 60
        let sec = remainingTime % 60
        let minStr = min < 10 ? "0\(min)" : "\(min)"
        let secStr = sec < 10 ? "0\(sec)" : "\(sec)"
        view?.updateTimerLabelText("\(minStr):\(secStr)")
    }
    
    func playerDidWinQuizGame() {
        view?.displayAlert(title: "Congratulations", text: "Good job! You found all the answers on time. Keep up with the great work.", buttonText: "Play Again")
        interactor?.resetGame()
    }
    
    func playerDidLoseQuizGame() {
        guard let answersCount = interactor?.acceptedAnswers?.count,
              let remainingAnswersCount = interactor?.remainingAnswers?.count else {
            preconditionFailure("[QuizPresenter]: acceptedAnswers and remainingAnswers should be initialized")
        }
        let totalAnswersCount = answersCount + remainingAnswersCount
        view?.displayAlert(title: "Time finished", text: "Sorry, time is up! You got \(answersCount) out of \(totalAnswersCount) answers.", buttonText: "Try Again")
        interactor?.resetGame()
    }
    
}

// MARK: - Private Methods

extension QuizPresenter {

    private func updateHitsLabel(answersCount: Int, totalAnswersCount: Int) {
        let answersCountStr = answersCount < 10 ? "0\(answersCount)" : "\(answersCount)"
        let totalAnswersCountStr = totalAnswersCount < 10 ? "0\(totalAnswersCount)" : "\(totalAnswersCount)"
        view?.setHitsLabelText("\(answersCountStr)/\(totalAnswersCountStr)")
    }
    
    private func updateViewOnCurrentState() {
        guard let answersCount = interactor?.acceptedAnswers?.count,
              let remainingAnswersCount = interactor?.remainingAnswers?.count else {
            preconditionFailure("[QuizPresenter]: acceptedAnswers and remainingAnswers should be initialized")
        }
        
        if answersCount == 1 {
            view?.showTableView()
        }
        
        let totalAnswersCount = answersCount + remainingAnswersCount
        updateHitsLabel(answersCount: answersCount, totalAnswersCount: totalAnswersCount)
        view?.cleanTextField()
        view?.updateTableView()
    }
    
}
