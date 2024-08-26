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
    private let productId: Int
    private let categoryName: String?
    private let service: HayServiceable?
    
    init(service: HayServiceable?, categoryName: String?, productId: Int, navigationController: UINavigationController) {
        self.service = service
        self.categoryName = categoryName
        self.productId = productId
        self.navigationController = navigationController
    }
    
    func start() {
        showModule()
    }
    
    func finish() {
        navigationController.popViewController(animated: true)
    }
}

private extension ProductCoordinator {
    func showModule() {
        let viewModel = ProductViewModel(service: service, coordinator: self, categoryName: categoryName, productId: productId)
        let viewController = ProducViewController(viewModel: viewModel)
        viewModel.subscribe(observer: viewController)
        navigationController.pushViewController(viewController, animated: true)
    }
}
