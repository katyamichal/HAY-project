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
}

final class CategoryViewModel {
    private weak var coordinator: Coordinator?
    private weak var view: ICategoryTableCell?
    private var viewData: CategoryViewData?
    private let likeManager = LikeButtonManager.shared
    private var currentProduct: Product?
    
    private var isUpdating: Bool = false
    
    init(coordinator: Coordinator, viewData: CategoryViewData) {
        self.coordinator = coordinator
        self.viewData = viewData
    }
}

extension CategoryViewModel: ICategoryViewModel {
    var likeButtonIsUpdating: Bool {
        isUpdating
    }
    
    func subscribe(observer: IObserver) {
          likeManager.favouriteProducts.subscribe(observer: observer)
    }
    
    var productId: Int {
        guard let currentProduct else { return 0 }
        return currentProduct.id
    }
    
    func setCurrentProduct(at index: Int) {
        currentProduct = viewData?.category.products[index]
    }
    
    // MARK: - Computed properties for a single product

    var isFavourite: Bool {
        guard let currentProduct else { return false }
        if likeManager.favouriteProducts.value?.products.first(where: { $0.id == currentProduct.id }) != nil {
          //  print(isFavourite)
            return true
        }
        return false
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
    
    var numberOfItemInSection: Int {
        guard let viewData else { return 0 }
        return viewData.category.products.count
    }
    
    func setupView(with view: ICategoryTableCell) {
        self.view = view
        guard let viewData else { return }
        view.update(with: viewData.category.categoryName.uppercased())
        view.updateData()
    }
    
    func showDetail(with index: Int) {
        guard let product = viewData?.category.products[index] else {return}
        (coordinator as? CategoryCoordinator)?.showDetail(with: product)
    }
}

extension CategoryViewModel: ILikeButton {
    func changeStatus(with id: Int) {
        defer {
            isUpdating = false
        }
        guard let product = viewData?.category.products.first(where: { $0.id == id }) else { return }
       // print(product)
        isUpdating = true
        likeManager.changeProductStatus(with: product)
    }
}

