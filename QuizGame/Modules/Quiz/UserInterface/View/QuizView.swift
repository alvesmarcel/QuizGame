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
//      QuizView 

import UIKit

protocol QuizViewInterface: AnyObject {
    var presenter: QuizPresenterInterface? { get set }
    func startLoadingScreen()
    func dismissLoadingScreen()
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
    
    func startLoadingScreen() {
        
    }
    
    func dismissLoadingScreen() {
        
    }
    
    func setQuizTitle(_ title: String) {
        
    }
    
    func showErrorMessage(title: String, text: String) {
        
    }
    
}

// MARK: - Lifecycle

extension QuizView {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
    }
    
}
