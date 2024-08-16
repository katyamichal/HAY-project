//
//  DesignerViewModel.swift
//  Project
//
//  Created by Catarina Polakowsky on 16.08.2024.
//

import Foundation

protocol IDesignerViewModel: AnyObject {}

final class DesignerViewModel {
    private weak var coordinator: Coordinator?
    private weak var view: IDesignerView?
    private let viewData: DesignerViewData
    private let likeManager = LikeButtonManager.shared
    
    init(coordinator: Coordinator? = nil, viewData: DesignerViewData) {
        self.coordinator = coordinator
        self.viewData = viewData
    }
}

extension DesignerViewModel: IDesignerViewModel {}
