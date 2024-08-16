//
//  DesignerDetailsCoordinator.swift
//  Project
//
//  Created by Catarina Polakowsky on 16.08.2024.
//

import UIKit

final class DesignerDetailsCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    private let service: HayServiceable
    private let navigationController: UINavigationController
    
    init(service: HayServiceable, navigationController: UINavigationController) {
        self.service = service
        self.navigationController = navigationController
    }
    
    
    func start() {
        showModule()
    }
    
    func finish() {
        
    }
}

private extension DesignerDetailsCoordinator {
    func showModule() {}
}
