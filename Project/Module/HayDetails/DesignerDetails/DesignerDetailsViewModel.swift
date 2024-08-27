//
//  DesignerDetailsViewModel.swift
//  Project
//
//  Created by Catarina Polakowsky on 16.08.2024.
//

import UIKit

protocol IDesignerDetailsViewModel: AnyObject {
    var collaborationName: String { get }
    var designerImage: UIImage { get }
    var designerDescription: String { get }
    
    var designerQuotesPart1: String { get }
    var designerQuotesPart2: String { get }
    
    var collectionImagesPart1: [UIImage] { get }
    var collectionImagesPart2: [UIImage] { get }
    
    var productsCount: Int { get }
    
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
 
    // MARK: - Section Info
    
    var collaborationName: String {
        guard let data = viewData.value else { return emptyData }
        return data.designerName + " X HAY: " + data.collectionName
    }
    
    var designerImage: UIImage {
        guard let designer = viewData.value, let image = UIImage(named: designer.designerImage) else { return UIImage() }
        return image
    }
    
    var designerDescription: String {
        viewData.value?.designerInfo ?? emptyData
    }
    
    // MARK: - Images
    
    var collectionImagesPart1: [UIImage] {
         Array<UIImage>(collectionImages[0..<collectionImages.count / 2])
    }
    
    var collectionImagesPart2: [UIImage] {
        Array<UIImage>(collectionImages[(collectionImages.count / 2)..<collectionImages.count])
    }
    
    // MARK: - Quotes

    var designerQuotesPart1: String {
        designerQuotes.first ?? emptyData
    }
    
    var designerQuotesPart2: String {
        designerQuotes.last ?? emptyData
    }

    // MARK: - Products
    
    var productsCount: Int {
        viewData.value?.products.count ?? 0
    }
    
    // MARK: - Observer

    func subscribe(observer: IObserver) {
        viewData.subscribe(observer: observer)
    }
    
    func unsubscibe(observer: IObserver) {
        viewData.unsubscribe(observer: observer)
    }
    
    // MARK: - Fetching data from a server

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

private extension DesignerDetailsViewModel {
    var emptyData: String {
        return "No data"
    }
    
    var collectionImages: [UIImage] {
        return viewData.value?.collectionImages.compactMap { UIImage(named: $0) } ?? []
    }
    
    var designerQuotes: [String] {
        guard let designer = viewData.value else { return [] }
        return designer.designerQuotes
    }
}
