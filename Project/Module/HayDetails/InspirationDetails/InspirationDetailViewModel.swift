//
//  InspirationDetailViewModel.swift
//  Project
//
//  Created by Catarina Polakowsky on 23.08.2024.
//

import UIKit

protocol InspirationDetailViewModelProtocol: AnyObject {
    var productCount: Int { get }
    var collectionName: String { get }
    var imageCollection: [UIImage] { get }
    var description: String { get }
    var productName: String { get }
    var productPrice: String { get }
    var productImage: UIImage { get }
    var isFavourite: Bool { get }
    var productId: Int { get }
    
    func setupView(with view: InspirationDetailViewProtocol)
    func subscribe(_ observer: IObserver)
    func unsubscribe(_ observer: IObserver)
    func setCurrentProduct(at index: Int)
    func goBack()
}

final class InspirationDetailViewModel {
    private weak var coordinator: Coordinator?
    private weak var view: InspirationDetailViewProtocol?
    private let service: HayServiceable
    private let inspirationIndex: Int
    private var viewData: Observable<InspirationDetailViewData>
    private var loadingError = Observable<String>()
    private let likeManager = LikeButtonManager.shared
    
    private var currentProduct: ProductCDO?
    
    // MARK: - Inits
    
    init(service: HayServiceable, coordinator: Coordinator, inspirationIndex: Int) {
        self.service = service
        self.coordinator = coordinator
        self.inspirationIndex = inspirationIndex
        self.viewData = Observable<InspirationDetailViewData>()
    }
    
    deinit {
        print("InspirationDetailViewModel deinit")
    }
    
    func fetchData() {
        Task {
            do {
                async let inspirationResponse = try service.getInspiration()
                let inspiration = try await inspirationResponse.inspiration[inspirationIndex]
                viewData.value = InspirationDetailViewData(with: inspiration)
            } catch {
                self.loadingError.value = ErrorHandler.getErrorResponse(with: error)
            }
        }
    }
}

extension InspirationDetailViewModel: InspirationDetailViewModelProtocol {
    // MARK: - Data For Gallery Cell
    
    var imageCollection: [UIImage] {
        return [coverImage] + images
    }
    
    var collectionName: String {
        return viewData.value?.collectionName ?? emptyData
    }
    
    var description: String {
        return viewData.value?.description ?? emptyData
    }
    
    // MARK: - Data for Product Cell
    
    var productCount: Int {
        return viewData.value?.products.count ?? 0
    }
    
    var isFavourite: Bool {
        guard let currentProduct else { return false }
        if likeManager.favouriteProducts.value?.products.first(where: { $0.id == currentProduct.id }) != nil {
            return true
        }
        return false
    }
    
    var productId: Int {
        guard let currentProduct else { return 0 }
        return currentProduct.id
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
    
    // MARK: - Basic Protocol Methods
    
    func setupView(with view: InspirationDetailViewProtocol) {
        self.view = view
        fetchData()
    }
    
    func subscribe(_ observer: IObserver) {
        viewData.subscribe(observer: observer)
        loadingError.subscribe(observer: observer)
    }
    
    func unsubscribe(_ observer: IObserver) {
        viewData.unsubscribe(observer: observer)
        loadingError.unsubscribe(observer: observer)
    }
    
    func setCurrentProduct(at index: Int) {
        currentProduct = viewData.value?.products[index]
    }
    
    func goBack() {
        (coordinator as? InspirationDetailCoordinator)?.goBack()
    }
}

private extension InspirationDetailViewModel {
    var emptyData: String {
        return "No data"
    }
    
    var coverImage: UIImage {
        return UIImage(named: viewData.value?.coverImage ?? "") ?? UIImage()
    }
    
    var images: [UIImage] {
        return viewData.value?.images.compactMap { UIImage(named: $0) } ?? []
    }
}

