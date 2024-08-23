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
    private let service: HayServiceable
    
    init(service: HayServiceable, header: Header, viewData: [InspirationFeed], navigationController: UINavigationController) {
        self.view = header
        self.viewData = viewData
        self.navigationController = navigationController
        self.service = service
    }
    
    func start() {
        showModule()
    }
    
    func finish() {
    }
    
    func showDetail(with index: Int) {
        let inspirationDetailCoordinator = InspirationDetailCoordinator(service: service, inspirationIndex: index, navigationController: navigationController)
        inspirationDetailCoordinator.start()
    }
}

private extension HeaderCoordinator {
    func showModule() {
        let heaaderViewData = HeaderViewData(inspiration: viewData)
        view.viewModel = HeaderViewModel(coordinator: self, viewData: heaaderViewData)
    }
}
