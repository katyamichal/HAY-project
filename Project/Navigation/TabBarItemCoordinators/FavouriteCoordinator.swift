//
//  FavouriteCoordinator.swift
//  Project
//
//  Created by Catarina Polakowsky on 18.07.2024.
//

import UIKit

protocol IFavouriteCoordinator: AnyObject {
    //func showProductDetail()
}

final class FavouriteCoordinator: Coordinator, IFavouriteCoordinator {
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showModule()
    }
    
    func finish() {
    }
  
    // MARK: - Detail Coordinators

    func showProductDetail(productId: Int) {
        let productCoordinator = ProductCoordinator(service: nil, categoryName: nil, productId: productId, navigationController: navigationController)
        productCoordinator.parentCoordinator = self
        childCoordinators.append(productCoordinator)
        productCoordinator.start()
    }
}

private extension FavouriteCoordinator {
    func showModule() {
        let viewModel = FavouriteProductsViewModel(coordinator: self)
        let viewController = FavouriteProductsViewController(viewModel: viewModel)
        viewModel.subscribe(observer: viewController)
        navigationController.pushViewController(viewController, animated: true)
    }
}
