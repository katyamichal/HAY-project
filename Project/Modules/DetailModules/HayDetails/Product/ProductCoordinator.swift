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
    private let hayEndpoint: ProductEndpoint
    private let productId: Int
    private let itemId: Int
    private let service: HayServiceable
    
    init(service: HayServiceable, hayEndpoint: ProductEndpoint, itemId: Int, productId: Int, navigationController: UINavigationController) {
        self.service = service
        self.hayEndpoint = hayEndpoint
        self.itemId = itemId
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
        let viewModel = ProductViewModel(service: createProductFetchService(for: hayEndpoint), coordinator: self, hayEndpoint: hayEndpoint, itemId: itemId, productId: productId)
        let viewController = ProducViewController(viewModel: viewModel)
        viewModel.subscribe(observer: viewController)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func createProductFetchService(for endpoint: ProductEndpoint) -> ProductFetchService {
        switch endpoint {
        case .categories:
            return CategoriesFetchService(service: service)
        case .designers:
            return DesignersFetchService(service: service)
        case .inspiration:
            return InspirationFetchService(service: service)
        }
    }
}
