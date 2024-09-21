//
//  BasketCoordinator.swift
//  Project
//
//  Created by Catarina Polakowsky on 19.09.2024.
//

import Foundation

import UIKit

final class BasketCoordinator: Coordinator {
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

    func showProductDetail(hayEndpoint: ProductEndpoint, itemId: Int, productId: Int) {
        let productCoordinator = ProductCoordinator(service: service, hayEndpoint: hayEndpoint, itemId: itemId, productId: productId, navigationController: navigationController)
        productCoordinator.parentCoordinator = self
        childCoordinators.append(productCoordinator)
        productCoordinator.start()
    }
}

private extension BasketCoordinator {
    func showModule() {
        let viewModel = BasketViewModel(coordinator: self)
        let viewController = BasketViewController(viewModel: viewModel)
        viewModel.subscribe(observer: viewController)
        navigationController.pushViewController(viewController, animated: true)
    }
}
