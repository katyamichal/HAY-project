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
    func setupView(with view: IFavouriteProductsView)
    func getData()
    func setCurrentProduct(at index: Int)
}

final class FavouriteProductsViewModel {
    private weak var coordinator: IFavouriteCoordinator?
    private weak var view: IFavouriteProductsView?
    private let likeManager = LikeButtonManager.shared
    private var viewData: [FavouriteViewData] = []
    private var currentProduct: FavouriteViewData?
    
    // MARK: - Init

    init(coordinator: IFavouriteCoordinator) {
        self.coordinator = coordinator
    }
}

extension FavouriteProductsViewModel: IFavouriteProductsViewModel {
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
        viewData = data.products.map({FavouriteViewData(id: $0.id, name: $0.productName, price: $0.price, image: $0.image)})
    }
}

