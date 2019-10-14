//  ABSTRACT:
//      QuizRequestError represents the errors that can happen when a quiz is requested.

enum QuizRequestError: Error {
    case invalidQuizName
    case connectionError
    case jsonParsingError
}
