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
    private let indexPath: IndexPath
    
    init(service: HayServiceable, cell: DesignerTableCell, viewData: DesignerViewData, navigationController: UINavigationController, indexPath: IndexPath) {
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
