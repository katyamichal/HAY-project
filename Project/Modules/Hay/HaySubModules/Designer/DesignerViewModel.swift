//
//  DesignerViewModel.swift
//  Project
//
//  Created by Catarina Polakowsky on 16.08.2024.
//

import UIKit

protocol IDesignerViewModel: AnyObject {
    var productCount: Int { get }
    var productName: String { get }
    var productPrice: String { get }
    var productImage: UIImage { get }
    var isFavourite: Bool { get }
    var productId: Int { get }
    
    var likeButtonIsUpdating: Bool { get }
    
    func setCurrentProduct(at index: Int)
    
    func setupView(view: IDesignerView)
    func subscribe(observer: IObserver)
    func unsubscribe(observer: IObserver)
    func showDetail(at index: Int)
    func finish()
}

final class DesignerViewModel {
    private weak var coordinator: Coordinator?
    private weak var view: IDesignerView?
    private var viewData: DesignerViewData
    
    private var loadingError = Observable<String>()
    private let likeManager = LikeButtonManager.shared
   
    private var currentProduct: ProductCDO?
    
    private var isUpdating: Bool = false
    
    // MARK: - Init

    init(coordinator: Coordinator, viewData: DesignerViewData) {
        self.coordinator = coordinator
        self.viewData = viewData
    }
}

// MARK: - IDesignerViewModel Protocol

extension DesignerViewModel: IDesignerViewModel {
    
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
        currentProduct = viewData.products[index]
    }
    
    // MARK: - View Settings
    
    func setupView(view: IDesignerView) {
        self.view = view
        self.view?.updateTableCell(sectionName: Constants.LabelTitles.designerSection, name: viewData.designerName, collectionName: viewData.collectionName, image: UIImage(named: viewData.designerImage) ?? UIImage())
        self.view?.updateCollectionView()
    }
    
    var productCount: Int {
        return viewData.products.count
    }
    
    // MARK: - Cell Cycle

    func finish() {
        (coordinator as? DesignerCoordinator)?.leave()
    }
    
    // MARK: - Navigation Managing

    func showDetail(at index: Int) {
        (coordinator as? DesignerCoordinator)?.showProductDetail(with: viewData.designerId, productId: viewData.products[index].productId)
    }
}

// MARK: - Like Button Delegate

extension DesignerViewModel: ILikeButton {
    func changeStatus(with id: Int) {
        defer { isUpdating = false }
        guard let product = viewData.products.first(where: { $0.productId == id }) else { return }
        isUpdating = true
        likeManager.changeProductStatus(with: product)
    }
}

// MARK: - Private

private extension DesignerViewModel {
    var emptyData: String {
        return "No data"
    }
}
