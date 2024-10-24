//
//  SceneDelegate.swift
//  InfoApp
//
//  Created by Thalia on 24/10/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else {
            return
        }
        
        window = UIWindow(frame: UIScreen.main.bounds)
        self.window = UIWindow(frame: UIScreen.main.bounds)
        if let window = self.window {
            
            
            window.rootViewController = getTabBar()
            window.makeKeyAndVisible()
        }
        window?.windowScene = windowScene
    }
}

extension SceneDelegate {
    private func getTabBar() -> UITabBarController {
        let tabBar = UITabBarController()
        
        let g1FeedViewController = G1FeedViewController()
        let g1NavigationViewController = UINavigationController(rootViewController: g1FeedViewController)
        g1FeedViewController.title = "G1 Notícias"
        
        let agroFeedViewController = AgroNegocioViewController()
        let agroNavigationViewController = UINavigationController(rootViewController: agroFeedViewController)
        agroFeedViewController.title = "Agro Notícias"
        
//        let menuViewController = MenuViewController()
//        let menuNavigationViewController = UINavigationController(rootViewController: menuViewController)
//        menuViewController.title = "Menu"
        
        tabBar.viewControllers = [g1NavigationViewController, agroNavigationViewController]
        g1NavigationViewController.tabBarItem = UITabBarItem(title: "G1",
                                                             image: UIImage(named: "home"),
                                                             tag: 1)
        agroNavigationViewController.tabBarItem = UITabBarItem(title: "Agro",
                                                               image: UIImage(named: "news"),
                                                               tag: 1)
//        menuNavigationViewController.tabBarItem = UITabBarItem(title: "Menu",
//                                                               image: UIImage(named: "menu"),
//                                                               tag: 1)
        return tabBar
    }
}
