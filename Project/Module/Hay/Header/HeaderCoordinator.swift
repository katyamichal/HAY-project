//
//  HeaderCoordinator.swift
//  Project
//
//  Created by Catarina Polakowsky on 15.07.2024.
//

import UIKit

final class HeaderCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    
    private let viewData: [InspirationFeed]
    private let view: Header
    private let navigationController: UINavigationController
    
    init(header: Header, viewData: [InspirationFeed], navigationController: UINavigationController) {
        self.view = header
        self.viewData = viewData
        self.navigationController = navigationController
    }
    
    func start() {
        showModule()
    }
    
    func finish() {
    }
    
    func showDetail(with id: Int) {
    }
}

private extension HeaderCoordinator {
    func showModule() {
        let heaaderViewData = HeaderViewData(inspiration: viewData)
        view.viewModel = HeaderViewModel(coordinator: self, viewData: heaaderViewData)
    }
}
