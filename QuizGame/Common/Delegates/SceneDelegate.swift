//  ABSTRACT:
//      SceneDelegate is responsible for controlling the scene lifecycle since iOS 13.0.

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = QuizModuleFactory.createQuizModule()
            self.window = window
            window.makeKeyAndVisible()
        }
    }

}

