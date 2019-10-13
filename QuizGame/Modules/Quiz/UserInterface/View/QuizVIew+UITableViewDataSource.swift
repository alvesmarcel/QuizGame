import UIKit

extension QuizView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.acceptedAnswers?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AnswerTableViewCell")
        cell?.textLabel?.text = presenter?.acceptedAnswers?[indexPath.row]
        return cell ?? UITableViewCell()
    }
    
}
