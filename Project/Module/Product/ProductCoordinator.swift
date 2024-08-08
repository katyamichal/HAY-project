//
//  ProductCoordinator.swift
//  Project
//
//  Created by Catarina Polakowsky on 16.07.2024.
//

import UIKit

final class ProductCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    private let navigationController: UINavigationController
    private let product: Product
    
    init(product: Product, navigationController: UINavigationController) {
        self.product = product
        self.navigationController = navigationController
    }
    
    func start() {
        showModule()
    }
    
    func finish() {
        parentCoordinator?.finish()
    }
}

private extension ProductCoordinator {
    func showModule() {
        let viewModel = ProductViewModel(coordinator: self, product: product)
        let viewController = ProducViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
}
