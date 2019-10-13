import UIKit

struct QuizModuleFactory {
    
    static func createQuizModule() -> QuizView {
        guard let view = UIStoryboard(name: "QuizView", bundle: nil).instantiateInitialViewController() as? QuizView else {
            preconditionFailure("An initial QuizView has to be configured")
        }
        let presenter: QuizPresenterInterface & QuizInteractorDelegate = QuizPresenter()
        let interactor: QuizInteractorInterface = QuizInteractor()

        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        interactor.presenter = presenter
        
        return view
    }
    
}
