//
//  InspirationDetailCoordinator.swift
//  Project
//
//  Created by Catarina Polakowsky on 23.08.2024.
//

import UIKit
final class InspirationDetailCoordinator: Coordinator {
    
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    private let service: HayServiceable
    private let inspirationIndex: Int
    private let navigationController: UINavigationController
    
    
    init(service: HayServiceable, inspirationIndex: Int, navigationController: UINavigationController) {
        self.service = service
        self.inspirationIndex = inspirationIndex
        self.navigationController = navigationController
    }
    
    func start() {
        showModule()
    }
    
    func finish() {}
    
    func goBack() {
        navigationController.popToRootViewController(animated: true)
    }
}

private extension InspirationDetailCoordinator {
    func showModule() {
        let viewModel = InspirationDetailViewModel(service: service, coordinator: self, inspirationIndex: inspirationIndex)
        let viewController = InspirationDetailViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
}
