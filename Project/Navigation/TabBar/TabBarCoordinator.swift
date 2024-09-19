//
//  TabBarCoordinator.swift
//  HAYproject
//
//  Created by Catarina Polakowsky on 08.07.2024.
//

import UIKit

enum TabBarImageView: String, CaseIterable {
    case hay = "h.square"
    case favourite = "suit.heart"
    case basket = "bag"
}

final class TabBarCoordinator: Coordinator {
    
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    private var window: UIWindow
    private var tabBarController: HayTabBarController?
    private let networkService: HayServiceable
    
    init(window: UIWindow, networkService: HayServiceable) {
        self.window = window
        self.networkService = networkService
    }
    
    func start() {
        showTabBarFlow()
    }
    
    func finish() {}
}

private extension TabBarCoordinator {
    func showTabBarFlow() {
        let hayImage = UIImage(systemName: TabBarImageView.hay.rawValue)
        let hayNavigationController = UINavigationController()
        hayNavigationController.tabBarItem = UITabBarItem(title: "", image: hayImage, selectedImage: hayImage)
        
        let hayCoordinator = HayCoordinator(navigationController: hayNavigationController, networkService: networkService)
        hayCoordinator.parentCoordinator = self
        hayCoordinator.start()
        
        
        let favouriteImage = UIImage(systemName: TabBarImageView.favourite.rawValue)
        let favouriteNavigationController = UINavigationController()
        favouriteNavigationController.tabBarItem = UITabBarItem(title: "", image: favouriteImage, selectedImage: favouriteImage)
        
        let favouriteCoordinator = FavouriteCoordinator(service: networkService, navigationController: favouriteNavigationController)
        favouriteCoordinator.parentCoordinator = self
        favouriteCoordinator.start()
        
        
        let basketImage = UIImage(systemName: TabBarImageView.basket.rawValue)
        let basketNavigationController = UINavigationController()
        basketNavigationController.tabBarItem = UITabBarItem(title: "", image: basketImage, selectedImage: basketImage)
        
        let basketCoordinator = BasketCoordinator(service: networkService, navigationController: basketNavigationController)
        basketCoordinator.parentCoordinator = self
        basketCoordinator.start()
        
        
        childCoordinators.append(hayCoordinator)
        childCoordinators.append(favouriteCoordinator)
        childCoordinators.append(basketCoordinator)
        
        let tabBarControllers = [hayNavigationController, favouriteNavigationController, basketNavigationController]
        tabBarController = HayTabBarController(tabBarControllers: tabBarControllers)
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
    }
}
