//
//  FavouriteCoordinator.swift
//  Project
//
//  Created by Catarina Polakowsky on 18.07.2024.
//

import UIKit

final class FavouriteCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    
    private let service: HayServiceable
    private let navigationController: UINavigationController
    
    init(service: HayServiceable, navigationController: UINavigationController) {
        self.service = service
        self.navigationController = navigationController
    }
    
    func start() {
        showModule()
    }
    
    func finish() {
    }
  
    // MARK: - Detail Coordinators

    func showProductDetail(hayEndpoint: HayEndpoints, categoryName: String, productId: Int) {
        let productCoordinator = ProductCoordinator(service: service, hayEndpoint: hayEndpoint, categoryName: categoryName, productId: productId, navigationController: navigationController)
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
