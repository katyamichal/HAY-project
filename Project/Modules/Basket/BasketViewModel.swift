//
//  BasketViewModel.swift
//  Project
//
//  Created by Catarina Polakowsky on 19.09.2024.
//

import Foundation

protocol IBasketViewModel: AnyObject {
    func setupView(with view: IBasketView)
    func getData()
}

final class BasketViewModel {
    private weak var coordinator: Coordinator?
    private weak var view: IBasketView?
    
    init(coordinator: Coordinator) {
        self.coordinator = coordinator
    }
}

extension BasketViewModel: IBasketViewModel {
    func setupView(with view: IBasketView) {
        self.view = view
    }
    
    func getData() {
    }
}
