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
//      QuizView is a UIViewController subclass that contains all the UI of the Quiz Module.
//
//  NOTES:
//      - It was decided to avoid the use of a UINavigationBar (or UINavigationController) because Apple discourages resizing
//        UINavigationBar's height - see https://forums.developer.apple.com/thread/88202
//        Highlights to this statement, from Apple Staff:
//            "Finally the internal layout of the navigation bar is an implementation detail *including all class names and
//             orderings*. Any code that relies upon the ordering of the navigation bar's subviews or the names of any of their
//             classes is likely to encounter issues in the future, as these are all private details. Please do not rely upon
//             them."
//        Also, large title configuration seems to be suitable for one line titles, not multiline titles. All solutions for
//        multiline titles are hacky and should face problems in the future.

import UIKit

protocol QuizViewInterface: AnyObject {
    var presenter: QuizPresenterInterface? { get set }
    func startLoadingScreen()
    func dismissLoadingScreen()
    func showHiddenItems()
    func setQuizTitle(_ title: String)
    func showErrorMessage(title: String, text: String)
}

class QuizView: UIViewController, QuizViewInterface {
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var guessTextField: UITextField!
    @IBOutlet weak var answerTableView: UITableView!
    @IBOutlet weak var hitsLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var startResetButton: UIButton!
    @IBOutlet weak var bottomViewVerticalSpaceConstraint: NSLayoutConstraint!
    
    var presenter: QuizPresenterInterface?
    private var loadingView: UIView?
    
    func startLoadingScreen() {
        DispatchQueue.main.async {
            if let loadingView = Bundle.main.loadNibNamed("LoadingView", owner: nil, options: nil)?.first as? UIView {
                self.loadingView = loadingView
                self.view.addSubview(loadingView)
            }
        }
    }
    
    func dismissLoadingScreen() {
        DispatchQueue.main.async {
            self.loadingView?.removeFromSuperview()
        }
    }
    
    func showHiddenItems() {
        DispatchQueue.main.async {
            self.questionLabel.isHidden = false
            self.guessTextField.isHidden = false
        }
    }
    
    func setQuizTitle(_ title: String) {
        DispatchQueue.main.async {
            self.questionLabel.text = title
        }
    }
    
    func showErrorMessage(title: String, text: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: text, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
    }
    
}

// MARK: - Lifecycle

extension QuizView {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Call all initial view configurations
        configureGuessTextField()
        configureStartResetButton()
        configureAnswerTableView()
        
        // Inform the presenter that all the initial configuration is done
        presenter?.viewDidLoad()
    }

}

// MARK: - View Configuration

extension QuizView {
    
    private func configureGuessTextField() {
        // Remove border
        guessTextField.setPaddingPoints(10)
        guessTextField.borderStyle = .none
        guessTextField.layer.masksToBounds = true
        guessTextField.layer.cornerRadius = 5.0;
        guessTextField.layer.backgroundColor = UIColor.white.cgColor
        guessTextField.layer.borderColor = UIColor.clear.cgColor
    }
    
    private func configureStartResetButton() {
        startResetButton.layer.masksToBounds = true
        startResetButton.layer.cornerRadius = 10.0
    }
    
    private func configureAnswerTableView() {
        answerTableView.dataSource = self
    }
    
}
