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
    private let navigationController: UINavigationController
    
    init(cell: CategoryTableCell, viewData: CategoryViewData, navigationController: UINavigationController) {
        self.cell = cell
        self.viewData = viewData
        self.navigationController = navigationController
    }
    
    func start() {
        showModule()
    }
    
    func finish() {
        navigationController.popViewController(animated: true)
    }
    
    func showDetail(with product: Product) {
        let productCoordinator = ProductCoordinator(product: product, navigationController: navigationController)
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
