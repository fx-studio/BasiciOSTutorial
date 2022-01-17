//
//  SceneDelegate.swift
//  MultipleStoryboard
//
//  Created by Tien Le P. VN.Danang on 1/13/22.
//

import UIKit

enum RootType {
    case tutorial
    case login
    case tabbar
}

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    //MARK: - Life cycle
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        let storyboard = UIStoryboard(name: "TutorialFlow", bundle: .main)
        let vc = storyboard.instantiateViewController(withIdentifier: "TutorialVC") as! TutorialVC
                
        window.rootViewController = vc
        self.window = window
        window.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {}

    func sceneDidBecomeActive(_ scene: UIScene) {}

    func sceneWillResignActive(_ scene: UIScene) {}

    func sceneWillEnterForeground(_ scene: UIScene) {}

    func sceneDidEnterBackground(_ scene: UIScene) {}

    //MARK: - Change roots
    func changeRoot(type: RootType) {
        switch type {
        case .tutorial:
            let storyboard = UIStoryboard(name: "TutorialFlow", bundle: .main)
            let vc = storyboard.instantiateViewController(withIdentifier: "TutorialVC") as! TutorialVC
            
            self.window?.rootViewController = vc
        case .login:
            let storyboard = UIStoryboard(name: "LoginFlow", bundle: .main)
            let navi = storyboard.instantiateViewController(withIdentifier: "LoginNavi") as! UINavigationController
            
            self.window?.rootViewController = navi
            
        case .tabbar:
            let storyboard = UIStoryboard(name: "TabbarFlow", bundle: .main)
            let tabbar = storyboard.instantiateViewController(withIdentifier: "tabbar") as! UITabBarController
            
            self.window?.rootViewController = tabbar
        }
    }
}

