//
//  SceneDelegate.swift
//  HAYproject
//
//  Created by Catarina Polakowsky on 08.07.2024.
//

import UIKit

final class HayTabBarController: UITabBarController {
    
    init(tabBarControllers: [UIViewController]) {
        super.init(nibName: nil, bundle: nil)
        for tab in tabBarControllers {
            addChild(tab)
        }
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }
}

private extension HayTabBarController {
    func setupTabBar() {
        tabBar.tintColor = Colours.Main.hayAccent
        tabBar.backgroundColor = Colours.Main.hayBackground
        tabBar.barTintColor = Colours.Main.hayBackground
        tabBar.unselectedItemTintColor = .black
    }
}
       
