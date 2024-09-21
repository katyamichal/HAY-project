//
//  FavouriteProductsViewModel.swift
//  Project
//
//  Created by Catarina Polakowsky on 18.07.2024.
//

import UIKit

protocol IFavouriteProductsViewModel: AnyObject {
    var count: Int { get }
    var productName: String { get }
    var price: String { get }
    var image: UIImage { get }
    var headerTitle: String { get }
    var headerFont: UIFont { get }
    var isFavourite: Bool { get }
    var productId: Int { get }
    var likeButtonIsUpdating: Bool { get }
    
    func subscribe(observer: IObserver)
    func unsubscribe(observer: IObserver)
    
    func setupView(with view: IFavouriteProductsView)
    func getData()
    func setCurrentProduct(at index: Int)
    func showDetail(at index: Int)
}

final class FavouriteProductsViewModel {
    private weak var coordinator: Coordinator?
    private weak var view: IFavouriteProductsView?
    
    private let likeManager = LikeButtonManager.shared
    private let buyButtonManager = BuyButtonManager.shared
    
    private var viewData: [FavouriteViewData] = []
    private var currentProduct: FavouriteViewData?
    private var isUpdating: Bool = false
    
    // MARK: - Init
    
    init(coordinator: Coordinator) {
        self.coordinator = coordinator
    }
}

// MARK: - IFavouriteProductsViewModel Protocol

extension FavouriteProductsViewModel: IFavouriteProductsViewModel {
    
    // MARK: - Like Button Managing
    
    var likeButtonIsUpdating: Bool {
        isUpdating
    }
    
    var isFavourite: Bool {
        guard let currentProduct else { return false }
        if likeManager.favouriteProducts.value?.products.first(where: { $0.productId == currentProduct.productId }) != nil {
            return true
        }
        return false
    }
    
    func subscribe(observer: IObserver) {
        likeManager.favouriteProducts.subscribe(observer: observer)
    }
    
    func unsubscribe(observer: IObserver) {
        likeManager.favouriteProducts.unsubscribe(observer: observer)
    }
    
    // MARK: - View Settings
    
    var headerFont: UIFont {
        (viewData.count == 0) ? Fonts.Subtitles.defaultFont : Fonts.Subtitles.largeFont
    }
    
    var headerTitle: String {
        (viewData.count == 0) ?  Constants.EmptyData.noFavouriteProduct : "favourite".uppercased()
    }
    
    var count: Int {
        viewData.count
    }
    
    func setupView(with view: IFavouriteProductsView) {
        self.view = view
    }
    
    // MARK: - Computed properties for a single product
    
    var productId: Int {
        guard let currentProduct else { return 0 }
        return currentProduct.productId
    }
    
    var productName: String {
        guard let currentProduct else { return emptyData }
        return currentProduct.productName
    }
    
    var price: String {
        guard let currentProduct else { return emptyData }
        return "£\(currentProduct.price)"
    }
    
    var image: UIImage {
        guard
            let currentProduct,
            let image = UIImage(named: currentProduct.image) else {
            return UIImage()
        }
        return image
    }
    
    func setCurrentProduct(at index: Int) {
        currentProduct = viewData[index]
    }
    
    // MARK: - Fetching Data
    
    func getData() {
        defer {
            view?.updateView()
            view?.updateViewHeader()
        }
        guard let data = likeManager.favouriteProducts.value else {
//            view?.updateViewHeader()
            return
        }
        viewData = data.products.map({FavouriteViewData(with: $0)})
    }
    
    // MARK: - Navigation Managing
    
    func showDetail(at index: Int) {
        let product = viewData[index]
        (coordinator as? FavouriteCoordinator)?.showProductDetail(hayEndpoint: product.endpoint, itemId: product.itemIdentifier, productId: product.productId)
    }
}

// MARK: - Like Button Delegate

extension FavouriteProductsViewModel: ILikeButton {
    func changeStatus(with id: Int) {
        defer { isUpdating = false }
        guard let product = viewData.first(where: { $0.productId == id }) else { return }
        isUpdating = true
        likeManager.changeProductStatus(with: product)
    }
}

// MARK: - Buy Button Delegate

extension FavouriteProductsViewModel: IBuyButton {
    func changeProductCount(with id: Int) {
        guard let product = viewData.first(where: { $0.productId == id }) else { return }
        buyButtonManager.changeProductStatus(with: product)
    }
}


// MARK: - Private

private extension FavouriteProductsViewModel {
    var emptyData: String {
        Constants.EmptyData.noData
    }
}
