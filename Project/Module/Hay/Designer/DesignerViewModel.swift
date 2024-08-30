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
    func setCurrentProduct(at index: Int)
    
    func setupView(view: IDesignerView)
    
    func showDetail(at index: Int)
}

final class DesignerViewModel {
    private weak var coordinator: Coordinator?
    private weak var view: IDesignerView?
    private var viewData: DesignerViewData
    
    private var loadingError = Observable<String>()
    private let likeManager = LikeButtonManager.shared
   
    private var currentProduct: ProductCDO?
    
    // MARK: - Init

    init(coordinator: Coordinator, viewData: DesignerViewData) {
        self.coordinator = coordinator
        self.viewData = viewData
    }
}

// MARK: - IDesignerViewModel Protocol

extension DesignerViewModel: IDesignerViewModel {
    var productCount: Int {
        return viewData.products.count
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
        currentProduct = viewData.products[index]
    }
    
    func setupView(view: IDesignerView) {
        self.view = view
        self.view?.updateTableCell(sectionName: Constants.LabelTitles.designerSection, name: viewData.designerName, collectionName: viewData.collectionName, image: UIImage(named: viewData.designerImage) ?? UIImage())
        self.view?.updateCollectionView()
    }
    
    func showDetail(at index: Int) {
        (coordinator as? DesignerCoordinator)?.showProductDetail(with: viewData.designerId, productId: viewData.products[index].productId)
    }
}

private extension DesignerViewModel {
    var emptyData: String {
        return "No data"
    }
}
