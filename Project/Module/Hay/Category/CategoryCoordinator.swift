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
    private let service: HayServiceable
    
    init(service: HayServiceable, cell: CategoryTableCell, viewData: CategoryViewData, navigationController: UINavigationController) {
        self.service = service
        self.cell = cell
        self.viewData = viewData
        self.navigationController = navigationController
    }
    
    func start() {
        showModule()
    }
    
    func finish() {
        navigationController.popToRootViewController(animated: true)
    }
    
    func leave() {
        parentCoordinator?.finish()
    }
    
    func showDetail(with productId: Int) {
        let productCoordinator = ProductCoordinator(service: service, categoryName: viewData.categoryName, productId: productId, navigationController: navigationController)
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
