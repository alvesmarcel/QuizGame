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
//      QuizRequestError represents the errors that can happen when a quiz is requested.
//      The localizedDescription is used by the Interactor to pass a proper message to the Presenter.

enum QuizRequestError: Error {
    case invalidQuizName
    case connectionError
    case jsonParsingError
    
    var localizedDescription: String {
        switch self {
        case .invalidQuizName:
            return "The quiz name is invalid. Try choosing another quiz."
        case .connectionError:
            return "There was a connection error. Check your internet connection."
        case .jsonParsingError:
            return "The Internet connection appears to be offline."
        }
    }
}
