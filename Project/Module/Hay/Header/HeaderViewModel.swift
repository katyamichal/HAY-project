//
//  HeaderViewModel.swift
//  Project
//
//  Created by Catarina Polakowsky on 14.07.2024.
//

import UIKit

protocol IHeaderViewModel: AnyObject {
    func setupView(with view: IHeaderView)
    func showDetail(at index: Int)
}

final  class HeaderViewModel {
    
    private weak var coordinator: Coordinator?
    private weak var view: IHeaderView?
    private var viewData: HeaderViewData
    
    init(coordinator: Coordinator?, viewData: HeaderViewData) {
        self.coordinator = coordinator
        self.viewData = viewData
    }
}

extension HeaderViewModel: IHeaderViewModel {
    
    func setupView(with view: IHeaderView) {
        self.view = view
        view.update(with: viewData.inspiration)
    }
    
    func showDetail(at index: Int) {
        (coordinator as? HeaderCoordinator)?.showDetail(with: index)
    }
}
