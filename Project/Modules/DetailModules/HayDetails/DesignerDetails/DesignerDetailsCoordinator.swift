//
//  DesignerDetailsCoordinator.swift
//  Project
//
//  Created by Catarina Polakowsky on 16.08.2024.
//

import UIKit

final class DesignerDetailsCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    private let service: HayServiceable
    private let navigationController: UINavigationController
    private let designerId: Int
    
    init(service: HayServiceable, navigationController: UINavigationController, designerId: Int) {
        self.service = service
        self.navigationController = navigationController
        self.designerId = designerId
    }
    
    
    func start() {
        showModule()
    }
    
    func finish() {
        
    }
    
    func showProductDetail(hayEndpoint: ProductEndpoint, itemId: Int, productId: Int) {
        let productCoordinator = ProductCoordinator(service: service, hayEndpoint: hayEndpoint, itemId: itemId, productId: productId, navigationController: navigationController)
        productCoordinator.parentCoordinator = self
        childCoordinators.append(productCoordinator)
        productCoordinator.start()
    }
}

private extension DesignerDetailsCoordinator {
    func showModule() {
        let viewModel = DesignerDetailsViewModel(coordinator: self, service: service, designerId: designerId)
        let viewController = DesignerDetailViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
}
