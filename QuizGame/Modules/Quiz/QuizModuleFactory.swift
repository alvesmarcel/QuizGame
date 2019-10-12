struct QuizModuleFactory {
    
    static func createQuizModule() -> QuizView {
        let view = QuizView(nibName: "QuizView", bundle: nil)
        let presenter: QuizPresenterInterface & QuizInteractorDelegate = QuizPresenter()
        let interactor: QuizInteractorInterface = QuizInteractor()

        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        interactor.presenter = presenter
        
        return view
    }
    
}
