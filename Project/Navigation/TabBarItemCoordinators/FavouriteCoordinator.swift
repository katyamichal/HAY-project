//
//  FavouriteCoordinator.swift
//  Project
//
//  Created by Catarina Polakowsky on 18.07.2024.
//

import UIKit

protocol IFavouriteCoordinator: AnyObject {
    //func showProductDetail()
}

final class FavouriteCoordinator: Coordinator, IFavouriteCoordinator {
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    private let dataService: any ICoreDataService
    private let navigationController: UINavigationController
    
    init(dataService: any ICoreDataService, navigationController: UINavigationController) {
        self.dataService = dataService
        self.navigationController = navigationController
    }
    
    func start() {
        showModule()
    }
    
    func finish() {
    }
}

private extension FavouriteCoordinator {
    func showModule() {
        let viewModel = FavouriteProductsViewModel(coordinator: self, dataService: dataService)
        let viewController = FavouriteProductsViewController(viewModel: viewModel)
       // viewModel.subscribe
        navigationController.pushViewController(viewController, animated: true)
    }
}
