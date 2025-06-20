//
//  TabBarViewController.swift
//  WatchMeGo
//
//  Created by Liza on 31/05/2025.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mainVC = MainViewController()
        mainVC.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 0)
        
        let challengeNav = UINavigationController(rootViewController: ChallengeViewController())
        challengeNav.tabBarItem = UITabBarItem(title: "Challenge", image: UIImage(systemName: "flag.fill"), tag: 1)
        
        let friendsVC = FriendsViewController()
        friendsVC.tabBarItem = UITabBarItem(title: "Friends", image: UIImage(systemName: "person.3"), tag: 2)
        
        viewControllers = [mainVC, challengeNav, friendsVC]
    }
}
