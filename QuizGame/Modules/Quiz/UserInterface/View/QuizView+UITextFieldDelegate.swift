//  ABSTRACT:
//      UITextFieldDelegate informs the text field events to the QuizPresenter.

import UIKit

extension QuizView: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let resultWord = (textField.text ?? "") + string
        presenter?.textFieldHasNewWord(word: resultWord)
        return true
    }
    
}
