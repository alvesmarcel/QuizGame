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
    func showAlert(title: String, text: String, buttonText: String?)
    func cleanTextField()
    func updateTableView()
    func showTableView()
    func setHitsLabelText(_ text: String)
    func enableGuessTextField()
    func updateStartResetButtonTitle(title: String)
    func updateTimerLabelText(_ text: String)
    func hideTableView()
}

class QuizView: UIViewController, QuizViewInterface {
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var guessTextField: UITextField!
    @IBOutlet weak var answerTableView: UITableView!
    @IBOutlet weak var hitsLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var startResetButton: UIButton!
    @IBOutlet weak var bottomViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomView: UIView!
    
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
    
    func showAlert(title: String, text: String, buttonText: String? = "OK") {
        DispatchQueue.main.async {
            self.view.endEditing(true)
            let alert = UIAlertController(title: title, message: text, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: buttonText, style: .default, handler: nil))
            self.present(alert, animated: true)
        }
    }
    
    func cleanTextField() {
        DispatchQueue.main.async {
            self.guessTextField.text = ""
        }
    }
    
    func updateTableView() {
        DispatchQueue.main.async {
            self.answerTableView.reloadData()
        }
    }
    
    func showTableView() {
        DispatchQueue.main.async {
            self.answerTableView.isHidden = false
        }
    }
    
    func setHitsLabelText(_ text: String) {
        DispatchQueue.main.async {
            self.hitsLabel.text = text
        }
    }
    
    func enableGuessTextField() {
        DispatchQueue.main.async {
            self.guessTextField.isEnabled = true
        }
    }
    
    func updateStartResetButtonTitle(title: String) {
        DispatchQueue.main.async {
            self.startResetButton.setTitle(title, for: .normal)
        }
    }
    
    func updateTimerLabelText(_ text: String) {
        DispatchQueue.main.async {
            self.timerLabel.text = text
        }
    }
    
    func hideTableView() {
        DispatchQueue.main.async {
            self.answerTableView.isHidden = true
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
        configureTimerLabel()
        
        // Inform the presenter that all the initial configuration is done
        presenter?.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
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
        
        guessTextField.delegate = self
    }
    
    private func configureStartResetButton() {
        startResetButton.layer.masksToBounds = true
        startResetButton.layer.cornerRadius = 10.0
    }
    
    private func configureAnswerTableView() {
        answerTableView.dataSource = self
    }
    
    private func configureTimerLabel() {
        // This avoids the label "shaking" when it's updated
        timerLabel.font = UIFont.monospacedSystemFont(ofSize: 24, weight: .bold)
    }
    
    @objc func keyboardChange(notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        guard let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        
        // Calculate the vertical displacement
        // TODO: Change the constraint using an animation that matches the keyboard animation
        let verticalDistance = view.frame.height - keyboardFrame.minY - bottomView.frame.height
        self.bottomViewConstraint.constant = verticalDistance >= 0 ? verticalDistance : 0
    }
    
}

// MARK: - Actions

extension QuizView {
    
    @IBAction func onStartButtonTap(sender: UIButton) {
        presenter?.startResetButtonTapped(withButtonName: sender.titleLabel?.text ?? "")
    }
    
}
