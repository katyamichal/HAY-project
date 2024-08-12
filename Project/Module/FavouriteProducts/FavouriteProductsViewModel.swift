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
    func setupView(with view: IFavouriteProductsView)
    func getData()
    func subscribe(observer: IObserver)
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
    func setCurrentProduct(at index: Int) {
        currentProduct = viewData[index]
    }
    
    var productName: String {
        guard let currentProduct else { return "no data" }
        return currentProduct.name
    }
    
    var price: String {
        guard let currentProduct else { return "no data" }
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
        }
        guard let data = likeManager.favouriteProducts.value else { return }
        viewData = data.products.map({FavouriteViewData(name: $0.productName, price: $0.price, image: $0.image)})
    }
}

