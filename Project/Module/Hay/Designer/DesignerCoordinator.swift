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
        
    }
}

private extension DesignerCoordinator {
    func showModule() {
       // cell.viewModel = DesignerViewModel(coordinator: self, viewData: viewData)
    }
}
