//
//  HayCoordinator.swift
//  Project
//
//  Created by Catarina Polakowsky on 18.07.2024.
//

import UIKit

final class HayCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    private let navigationController: UINavigationController
    private let networkService: HayServiceable
    
    init(navigationController: UINavigationController, networkService: HayServiceable) {
        self.navigationController = navigationController
        self.networkService = networkService
    }
    
    func start() {
       showModule()
    }
    
    func finish() {
        let first = childCoordinators.first
        childCoordinators.removeAll()
        childCoordinators.append(first!)
    }
    
    // MARK: - Show Submodules

    func showCategoryCoordinator(cell: CategoryTableCell, viewData: Category) {
        let categoryViewData = CategoryViewData.init(with: viewData)
        let categoryCoordinator = CategoryCoordinator(service: networkService, cell: cell, viewData: categoryViewData, navigationController: navigationController)
        categoryCoordinator.parentCoordinator = self
        childCoordinators.append(categoryCoordinator)
        categoryCoordinator.start()
    }
    
    func showDesignerModule(cell: DesignerTableCell, viewData: Designer) {
        let designerViewData = DesignerViewData(with: viewData)
        let designerCoordinator = DesignerCoordinator(service: networkService, cell: cell, viewData: designerViewData, navigationController: navigationController)
        designerCoordinator.parentCoordinator = self
        childCoordinators.append(designerCoordinator)
        designerCoordinator.start()
    }
    
    func showInspiration(view: Header, viewData: [InspirationFeed]) {
        let headerCoordinator = HeaderCoordinator(service: networkService, header: view, viewData: viewData, navigationController: navigationController)
        headerCoordinator.parentCoordinator = self
        childCoordinators.append(headerCoordinator)
        headerCoordinator.start()
    }
  
    // MARK: - Show Detail Modules

    func showDesignerDetail(_ designerId: Int) {
        let designerDetailCoordinator = DesignerDetailsCoordinator(service: networkService, navigationController: navigationController, designerId: designerId)
        designerDetailCoordinator.parentCoordinator = self
        childCoordinators.append(designerDetailCoordinator)
        designerDetailCoordinator.start()
    }
}

private extension HayCoordinator {
    func showModule() {
        let viewModel = HayViewModel(coordinator: self, service: networkService)
        let viewController = HayViewController(mainViewModel: viewModel)
        viewModel.subscribe(observer: viewController)
        navigationController.pushViewController(viewController, animated: true)
    }
}
