//  ABSTRACT:
//      UITableViewDataSource fetches the items that need to be displayed in the table view from QuizPresenter.

import UIKit

extension QuizView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.presentingAnswers?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AnswerTableViewCell")
        cell?.textLabel?.text = presenter?.presentingAnswers?[indexPath.row]
        return cell ?? UITableViewCell()
    }
    
}
