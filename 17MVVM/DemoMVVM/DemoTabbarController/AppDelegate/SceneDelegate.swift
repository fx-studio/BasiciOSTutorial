//
//  SceneDelegate.swift
//  DemoTabbarController
//
//  Created by Le Phuong Tien on 12/6/19.
//  Copyright © 2019 Fx Studio. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    enum TypeScreen {
        case login
        case tabbar
    }

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        window.makeKeyAndVisible()
        
        changeScreen(type: .login)
    }

    func sceneDidDisconnect(_ scene: UIScene) {
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
    }

    func sceneWillResignActive(_ scene: UIScene) {
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
    }

    private func createTabbar() {
        //Home
        let homeVC = HomeViewController()
        let homeNavi = UINavigationController(rootViewController: homeVC)
        homeNavi.tabBarItem = UITabBarItem(tabBarSystemItem: .featured, tag: 0)
        
        //Messages
        let messagesVC = MessagesViewController()
        let messagesNavi = UINavigationController(rootViewController: messagesVC)
        messagesNavi.tabBarItem = UITabBarItem(title: "Messages", image: UIImage(named: "ic-tabbar-messages"), selectedImage: UIImage(named: "ic-tabbar-messages-selected"))
        messagesNavi.tabBarItem.badgeValue = "99"
        messagesNavi.tabBarItem.badgeColor = .blue
        
        //Friends
        let friendsVC = FriendsViewController()
        let friendsNavi = UINavigationController(rootViewController: friendsVC)
        friendsNavi.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "ic-tabbar-friends"), tag: 2)
        
        
        //Profile
        let profileVC = ProfileViewController()
        let profileNavi = UINavigationController(rootViewController: profileVC)
        profileNavi.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(named: "ic-tabbar-profile"), tag: 3)
        
        
        //tabbar controller
        let tabbarController = UITabBarController()
        tabbarController.delegate = self
        tabbarController.viewControllers = [homeNavi, messagesNavi, friendsNavi, profileNavi]
        tabbarController.tabBar.tintColor = .red
        
        window!.rootViewController = tabbarController
    }
    
    private func createLogin() {
        let loginVC = LoginViewController()
        let loginNavi = BaseNavigationController(rootViewController: loginVC)
        
        window?.rootViewController = loginNavi
    }
    
    func changeScreen(type: TypeScreen) {
        switch type {
        case .login:
            createLogin()
        case .tabbar:
            createTabbar()
        }
    }

}


extension SceneDelegate: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        print("Selected Tab : \(tabBarController.selectedIndex)")
    }
}
