//
//  CategoryCoordinator.swift
//  Project
//
//  Created by Catarina Polakowsky on 14.07.2024.
//

import UIKit

final class CategoryCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    
    private let viewData: CategoryViewData
    private let cell: CategoryTableCell
    var navigationController: UINavigationController
    private let service: HayServiceable
    private let indexPath: IndexPath
    
    init(service: HayServiceable, cell: CategoryTableCell, viewData: CategoryViewData, navigationController: UINavigationController, indexPath: IndexPath) {
        self.service = service
        self.cell = cell
        self.viewData = viewData
        self.navigationController = navigationController
        self.indexPath = indexPath
    }
    
    // MARK: - Coordinator Cycle

    func start() {
        showModule()
    }
    
    func leave() {
        (parentCoordinator as? HayCoordinator)?.removeSubCoordinator(at: indexPath)
    }
    
    func finish() {
        navigationController.popToRootViewController(animated: true)
    }
    
    // MARK: - Show Detail
    func showDetail(with productId: Int) {
        let productCoordinator = ProductCoordinator(service: service, hayEndpoint: .categories, itemId: viewData.id, productId: productId, navigationController: navigationController)
        productCoordinator.parentCoordinator = self
        childCoordinators.append(productCoordinator)
        productCoordinator.start()
    }
}

private extension CategoryCoordinator {
    func showModule() {
        cell.viewModel = CategoryViewModel(coordinator: self, viewData: viewData)
    }
}
