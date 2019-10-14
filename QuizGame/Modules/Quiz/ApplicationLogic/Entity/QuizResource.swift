//  ABSTRACT:
//      QuizResource is a struct with two stored properties (question, and answer).
//      QuizResource's instances are initialized using the JSON obtained from the data server.

struct QuizResource: Decodable {
    let question: String
    let answer: [String]
}
