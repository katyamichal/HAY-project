//
//  BasketViewModel.swift
//  Project
//
//  Created by Catarina Polakowsky on 19.09.2024.
//

import UIKit

protocol IBasketViewModel: AnyObject {
    var productsCount: Int { get }
    var productName: String { get }
    var price: String { get }
    var image: UIImage { get }
    var headerTitle: String { get }
    var headerFont: UIFont { get }
    var isFavourite: Bool { get }
    var productId: Int { get }
    var countOfSingleProduct: String? { get }
    
    var subtotalPrice: String { get }
    var deliveryPrice: String { get }
    var totalPrice: String { get }
    
    func setupView(with view: IBasketView)
    func setCurrentProduct(at index: Int)
    func getData()
    
    func showDetail(at index: Int)
}

final class BasketViewModel {
    private weak var coordinator: Coordinator?

    private weak var view: IBasketView?
    private var viewData: [BasketViewData] = []
    private var currentProduct: BasketViewData?
    
    private let buyButtonManager = BuyButtonManager.shared
    private let likeManager = LikeButtonManager.shared
    
    
    init(coordinator: Coordinator) {
        self.coordinator = coordinator
    }
}

extension BasketViewModel: IBasketViewModel {

    var isFavourite: Bool {
        guard let currentProduct else { return false }
        if likeManager.favouriteProducts.value?.products.first(where: { $0.productId == currentProduct.productId }) != nil {
            return true
        }
        return false
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
    
    var countOfSingleProduct: String? {
        guard let currentProduct else { return nil }
        return (currentProduct.count == 1) ? nil : "x\(currentProduct.count)"
    }
    
    func setCurrentProduct(at index: Int) {
        currentProduct = viewData[index]
    }
    
    // MARK: - Order Info Properties
    
    var subtotalPrice: String {
        return "Subtotal  £\(subtotal)"
    }
    
    var deliveryPrice: String {
        delivery == 0 ? "Free delivery" : "Delivery: £15"
    }
    
    var totalPrice: String {
        "£\(total)"
    }
    
    // MARK: - View Settings
    
    var headerFont: UIFont {
        (viewData.count == 0) ? Fonts.Subtitles.defaultFont : Fonts.Subtitles.largeFont
    }
    
    var headerTitle: String {
        (viewData.count == 0) ?  Constants.EmptyData.noFavouriteProduct : "Basket".uppercased()
    }
    
    func setupView(with view: IBasketView) {
        self.view = view
    }
    
    var productsCount: Int {
        viewData.count
    }
    
    // MARK: - Fetching Data
    
    func getData() {
        defer {
            view?.updateView()
            view?.updateViewHeader()
        }
        guard let data = buyButtonManager.basketProducts.value else {
            return
        }
        print(data.products.count)
        viewData = data.products.map({ BasketViewData(with: $0)})
    }
    
    // MARK: - Subscriptions

    func subscribe(observer: IObserver) {
        buyButtonManager.basketProducts.subscribe(observer: observer)
        likeManager.favouriteProducts.subscribe(observer: observer)
    }
    
    func unsubscribe(observer: IObserver) {
        likeManager.favouriteProducts.unsubscribe(observer: observer)
        buyButtonManager.basketProducts.unsubscribe(observer: observer)
    }
    
    // MARK: - Navigation Managing
    
    func showDetail(at index: Int) {
        let product = viewData[index]
        (coordinator as? BasketCoordinator)?.showProductDetail(hayEndpoint: product.endpoint, itemId: product.itemIdentifier, productId: product.productId)
    }
}

// MARK: - Private

private extension BasketViewModel {
    var emptyData: String {
        Constants.EmptyData.noData
    }
    
    var subtotal: Int {
        var price = 0
        viewData.forEach({ product in
            price += product.price })
        return price
    }
    
    var delivery: Int {
        subtotal > 1000 ? 0 : 15
    }
    
    var total: Int { subtotal + delivery }
}
