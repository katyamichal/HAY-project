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
    
    func finish() {}
    
    func showCategoryCoordinator(cell: UITableViewCell, viewData: Category) {
        let categoryCoordinator = CategoryCoordinator(cell: cell as! CategoryTableCell, viewData: CategoryViewData.init(category: viewData), navigationController: navigationController)
        categoryCoordinator.parentCoordinator = self
        childCoordinators.append(categoryCoordinator)
        categoryCoordinator.start()
    }
    
    func showInspiration(view: Header, viewData: [InspirationFeed]) {
        let headerCoordinator = HeaderCoordinator(header: view, viewData: viewData, navigationController: navigationController)
        headerCoordinator.parentCoordinator = self
        childCoordinators.append(headerCoordinator)
        headerCoordinator.start()
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
