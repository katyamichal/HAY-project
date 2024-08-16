//
//  DesignerDetailsViewModel.swift
//  Project
//
//  Created by Catarina Polakowsky on 16.08.2024.
//

import Foundation

protocol IDesignerDetailsViewModel: AnyObject {}

final class DesignerDetailsViewModel {
    private weak var coordinator: Coordinator?
    private weak var view: IDesignerDetailView?
    private let service: HayServiceable
    private let viewData: Observable<DesignerViewData>
    private let likeManager = LikeButtonManager.shared
    
    // MARK: - Inits

    init(coordinator: Coordinator, service: HayServiceable) {
        self.coordinator = coordinator
        self.service = service
        viewData = Observable<DesignerViewData>()
    }
    
    deinit {
        print("DesignerDetailsViewModel deinit")
    }
}

// MARK: - IDesignerDetailsViewModel Protocol

extension DesignerDetailsViewModel: IDesignerDetailsViewModel {}
