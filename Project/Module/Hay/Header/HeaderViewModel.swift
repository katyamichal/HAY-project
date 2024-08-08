//
//  HeaderViewModel.swift
//  Project
//
//  Created by Catarina Polakowsky on 14.07.2024.
//

import UIKit

final  class HeaderViewModel {
    
    private weak var coordinator: Coordinator?
    private weak var view: IHeaderView?
    private var viewData: HeaderViewData
    
    init(coordinator: Coordinator?, viewData: HeaderViewData) {
        self.coordinator = coordinator
        self.viewData = viewData
    }
    
    func setupView(with view: IHeaderView) {
        self.view = view
        view.update(with: viewData.inspiration)
    }
}
