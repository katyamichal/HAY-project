//
//  DesignerDetailsViewModel.swift
//  Project
//
//  Created by Catarina Polakowsky on 16.08.2024.
//

import UIKit

protocol IDesignerDetailsViewModel: AnyObject {
    var designerName: String { get }
    var designerImage: UIImage { get }
    var designerDescription: String { get }
    
    func setupView(view: IDesignerDetailView)
    func getData()
    func subscribe(observer: IObserver)
    func unsubscibe(observer: IObserver)
}

final class DesignerDetailsViewModel {
    private weak var coordinator: Coordinator?
    private weak var view: IDesignerDetailView?
    private let service: HayServiceable
    private var viewData: Observable<DesignerDetailsViewData>
    private let likeManager = LikeButtonManager.shared
    private let designerId: Int
    
    // MARK: - Inits

    init(coordinator: Coordinator, service: HayServiceable, designerId: Int) {
        self.coordinator = coordinator
        self.service = service
        self.designerId = designerId
        viewData = Observable<DesignerDetailsViewData>()
    }
    
    deinit {
        print("DesignerDetailsViewModel deinit")
    }
}

// MARK: - IDesignerDetailsViewModel Protocol

extension DesignerDetailsViewModel: IDesignerDetailsViewModel {
    var designerName: String {
        guard let designer = viewData.value else { return "" }
        return designer.designerName
    }
    
    var designerImage: UIImage {
        guard let designer = viewData.value, let image = UIImage(named: designer.designerImage) else { return UIImage() }
        return image
    }
    
    var designerDescription: String {
        guard let designer = viewData.value else { return "" }
        return designer.designerInfo
    }
    
    func subscribe(observer: IObserver) {
        viewData.subscribe(observer: observer)
    }
    
    func unsubscibe(observer: IObserver) {
        viewData.unsubscribe(observer: observer)
    }
    
    func getData() {
        Task {
            do {
                async let designersResponse = try service.getDesigners()
                let designers = try await designersResponse.designers
    
                guard let designer = designers.first(where: { $0.id == designerId }) else {
                    return
                }
                self.viewData.value = DesignerDetailsViewData(with: designer)
            }
        }
    }
    
    func setupView(view: IDesignerDetailView) {
        self.view = view
        self.view?.viewIsSetUp()
    }
}
