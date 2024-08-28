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
    
    func setupView(with view: IFavouriteProductsView)
    func getData()
    func setCurrentProduct(at index: Int)
    func showDetail(at index: Int)
}

final class FavouriteProductsViewModel {
    private weak var coordinator: Coordinator?
    private weak var view: IFavouriteProductsView?
    
    private let likeManager = LikeButtonManager.shared
  
    private var viewData: [FavouriteViewData] = []
    private var currentProduct: FavouriteViewData?
    
    // MARK: - Init

    init(coordinator: Coordinator) {
        self.coordinator = coordinator
    }
}

extension FavouriteProductsViewModel: IFavouriteProductsViewModel {
    func showDetail(at index: Int) {
        let product = viewData[index]
        (coordinator as? FavouriteCoordinator)?.showProductDetail(hayEndpoint: product.endpoint, itemId: product.itemIdentifier, productId: product.productId)
    }
    
    var productId: Int {
        guard let currentProduct else { return 0 }
        return currentProduct.productId
    }
    
    var isFavourite: Bool {
        guard let currentProduct else { return false }
        if likeManager.favouriteProducts.value?.products.first(where: { $0.productId == currentProduct.productId }) != nil {
            return true
        }
        return false
    }
    
    var headerFont: UIFont {
        (viewData.count == 0) ? Fonts.Subtitles.defaultFont : Fonts.Subtitles.largeFont
    }

    var emptyData: String {
        Constants.EmptyData.noData
    }
    
    var headerTitle: String {
        (viewData.count == 0) ?  Constants.EmptyData.noFavouriteProduct : "favourite".uppercased()
    }
    
    func setCurrentProduct(at index: Int) {
        currentProduct = viewData[index]
    }
    
    var productName: String {
        guard let currentProduct else { return emptyData }
        return currentProduct.name
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
    
    var count: Int {
        viewData.count
    }
    
    func setupView(with view: IFavouriteProductsView) {
        self.view = view
    }
    
    func subscribe(observer: IObserver) {
        likeManager.favouriteProducts.subscribe(observer: observer)
    }
    
    func getData() {
        defer {
            view?.updateView()
            view?.updateViewHeader()
        }
        guard let data = likeManager.favouriteProducts.value else {
            view?.updateViewHeader()
            return
        }
        viewData = data.products.map({FavouriteViewData(with: $0)})
    }
}

