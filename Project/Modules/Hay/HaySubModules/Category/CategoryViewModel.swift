//
//  CategoryViewModel.swift
//  Project
//
//  Created by Catarina Polakowsky on 14.07.2024.
//

import UIKit

protocol ICategoryViewModel: AnyObject {
    var numberOfItemInSection: Int { get }
    var productName: String { get }
    var price: String { get }
    var image: UIImage { get }
    var isFavourite: Bool { get }
    var productId: Int { get }
    var likeButtonIsUpdating: Bool { get }
    
    func setupView(with view: ICategoryTableCell)
    func showDetail(with index: Int)
    func setCurrentProduct(at index: Int)
    func subscribe(observer: IObserver)
    func unsubscribe(observer: IObserver)
    func finish()
}

final class CategoryViewModel {
    private weak var coordinator: Coordinator?
    private weak var view: ICategoryTableCell?
    private var viewData: CategoryViewData?
    private let likeManager = LikeButtonManager.shared
    private var currentProduct: IProductCDO?
    
    private var isUpdating: Bool = false
    
    init(coordinator: Coordinator, viewData: CategoryViewData) {
        self.coordinator = coordinator
        self.viewData = viewData
    }
}

extension CategoryViewModel: ICategoryViewModel {
    
    // MARK: - Like Buttin Managing
    
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
    
    // MARK: - Computed properties for a single product
    
    func setCurrentProduct(at index: Int) {
        currentProduct = viewData?.products[index]
    }
    
    var productId: Int {
        guard let currentProduct else { return 0 }
        return currentProduct.productId
    }
    
    var productName: String {
        guard let currentProduct else { return "No data" }
        return currentProduct.productName
    }
    
    var price: String {
        guard let currentProduct else { return "No data" }
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
    
    // MARK: - View Settings
    
    var numberOfItemInSection: Int {
        guard let viewData else { return 0 }
        return viewData.products.count
    }
    
    func setupView(with view: ICategoryTableCell) {
        self.view = view
        guard let viewData else { return }
        view.update(with: viewData.categoryName.uppercased())
        view.updateData()
    }
    
    // MARK: - Cell Cycle
    
    func finish() {
        (coordinator as? CategoryCoordinator)?.leave()
    }
    
    // MARK: - Navigation Managing
    
    func showDetail(with index: Int) {
        guard let product = viewData?.products[index] else {return}
        (coordinator as? CategoryCoordinator)?.showDetail(with: product.productId)
    }
}

// MARK: - Like Button Delegate

extension CategoryViewModel: ILikeButton {
    func changeStatus(with id: Int) {
        defer { isUpdating = false }
        guard let product = viewData?.products.first(where: { $0.productId == id }) else { return }
        isUpdating = true
        likeManager.changeProductStatus(with: product)
    }
}

