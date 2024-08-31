//
//  DesignerCoordinator.swift
//  Project
//
//  Created by Catarina Polakowsky on 16.08.2024.
//

import UIKit

final class DesignerCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    
    private let viewData: DesignerViewData
    private let cell: DesignerTableCell
    private let navigationController: UINavigationController
    private let service: HayServiceable
    
    init(service: HayServiceable, cell: DesignerTableCell, viewData: DesignerViewData, navigationController: UINavigationController) {
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
    
    func showProductDetail(with itemId: Int, productId: Int) {
        let productCoordinator = ProductCoordinator(service: service, hayEndpoint: .designers, itemId: itemId, productId: productId, navigationController: navigationController)
        productCoordinator.parentCoordinator = self
        childCoordinators.append(productCoordinator)
        productCoordinator.start()
    }
}

private extension DesignerCoordinator {
    func showModule() {
        cell.viewModel = DesignerViewModel(coordinator: self, viewData: viewData)
    }
}
