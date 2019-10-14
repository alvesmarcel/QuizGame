//  ABSTRACT:
//      QuizInteractor is responsible for the application logic of the Quiz module.
//      Interactor responsabilities:
//        1) Use NetworkService to get quiz data (QuizResource) that will be delivered to the presenter;
//        2) Maintain the game state;
//        3) Inform the Presenter about changes in the game state that need to be displayed in the view.

import Foundation

protocol QuizInteractorInterface: AnyObject {
    var presenter: QuizInteractorDelegate? { get set }
    var networkService: NetworkServiceInterface { get }
    var acceptedAnswers: [String]? { get }
    var remainingAnswers: Set<String>? { get }
    func requestNewQuiz(withName quizName: String)
    func startGame()
    func resetGame()
    func check(answer: String)
}

protocol QuizInteractorDelegate: AnyObject {
    func didRetrieveQuiz(quizQuestion: String, quizAnswer: [String])
    func retrievingQuizFailed(with error: QuizRequestError)
    func newAcceptedAnswerAdded(answer: String)
    func timerDidUpdate(remainingTime: Int)
    func gameDidStart()
    func gameDidStop()
    func playerDidWinQuizGame()
    func playerDidLoseQuizGame()
}

class QuizInteractor: QuizInteractorInterface {
    
    weak var presenter: QuizInteractorDelegate?
    let networkService: NetworkServiceInterface
    var acceptedAnswers: [String]?
    var remainingAnswers: Set<String>?
    
    private var currentQuiz: QuizResource?
    private var currentTime: Int = 300
    private var timer: Timer?
    private var gameState: GameState = .notStarted
    
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
                self?.currentQuiz = quiz
            } catch {
                // Server Error: The JSON given by the server cannot be properly parsed
                self?.presenter?.retrievingQuizFailed(with: .jsonParsingError)
            }
        }
    }
    
    func startGame() {
        if gameState == .notStarted {
            guard let quiz = currentQuiz else {
                print("[QuizInteractor]: currentQuiz is empty. Failing silently.")
                return
            }
            acceptedAnswers = [String]()
            remainingAnswers = Set(quiz.answer.compactMap { $0.lowercased() })
            currentTime = 300
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(decreaseTime), userInfo: nil, repeats: true)
            gameState = .playing
            presenter?.gameDidStart()
        }
    }
    
    func resetGame() {
        if gameState == .playing {
            timer?.invalidate()
            timer = nil
            gameState = .notStarted
            presenter?.gameDidStop()
        }
    }
    
    func check(answer: String) {
        let lowercaseAnswer = answer.lowercased()
        if let foundAnswer = remainingAnswers?.contains(lowercaseAnswer), foundAnswer {
            acceptedAnswers?.append(answer)
            remainingAnswers?.remove(lowercaseAnswer)
            if let noMoreAnswer = remainingAnswers?.isEmpty, noMoreAnswer {
                presenter?.playerDidWinQuizGame()
            }
            presenter?.newAcceptedAnswerAdded(answer: answer)
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
    
    @objc private func decreaseTime() {
        currentTime -= 1
        presenter?.timerDidUpdate(remainingTime: currentTime)
        if currentTime <= 0 {
            presenter?.playerDidLoseQuizGame()
            timer?.invalidate()
            timer = nil
        }
    }
    
}
