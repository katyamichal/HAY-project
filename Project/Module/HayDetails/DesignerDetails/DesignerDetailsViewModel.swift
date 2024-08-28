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
    
    var productCount: Int { get }
    var productName: String { get }
    var productPrice: String { get }
    var productImage: UIImage { get }
    var isFavourite: Bool { get }
    var productId: Int { get }
    func setCurrentProduct(at index: Int)
    
    func setupView(view: IDesignerDetailView)
    func getData()
    
    func subscribe(observer: IObserver)
    func unsubscibe(observer: IObserver)
    
    func showDetail(at index: Int)
}

final class DesignerDetailsViewModel {
    private weak var coordinator: Coordinator?
    private weak var view: IDesignerDetailView?
    
    private let service: HayServiceable
    private let likeManager = LikeButtonManager.shared

    private let designerId: Int
    private var currentProduct: ProductCDO?
    
    private var loadingError = Observable<String>()
    private var viewData: Observable<DesignerDetailsViewData>
   
    
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
        return data.designerName + " x HAY: " + data.collectionName.lowercased()
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
    var productCount: Int {
        return viewData.value?.products.count ?? 0
    }
    
    var isFavourite: Bool {
        guard let currentProduct else { return false }
        if likeManager.favouriteProducts.value?.products.first(where: { $0.productId == currentProduct.productId }) != nil {
            return true
        }
        return false
    }
    
    var productId: Int {
        guard let currentProduct else { return 0 }
        return currentProduct.productId
    }
    
    var productName: String {
        guard let currentProduct else { return emptyData }
        return currentProduct.productName
    }
    
    var productPrice: String {
        guard let currentProduct else { return emptyData }
        return "£\(currentProduct.price)"
    }
    
    var productImage: UIImage {
        guard
            let currentProduct,
            let image = UIImage(named: currentProduct.image) else {
            return UIImage()
        }
        return image
    }
    
    func setCurrentProduct(at index: Int) {
        currentProduct = viewData.value?.products[index]
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
    
    func showDetail(at index: Int) {
        guard let data = viewData.value else { return }
        (coordinator as? DesignerDetailsCoordinator)?.showProductDetail(hayEndpoint: .designers, itemId: data.designerId, productId: data.products[index].productId)
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
